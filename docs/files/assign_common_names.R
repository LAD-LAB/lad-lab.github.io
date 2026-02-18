assign_common_names <- function(physeq, common_names_csv, 
                                report_conflicts = TRUE, 
                                report_all_conflicts = TRUE,
                                concatenate_conflicts = TRUE) {
  # Read the common names CSV
  common_names <- read.csv(common_names_csv, stringsAsFactors = FALSE)
  
  # Build genus lookup from ALL rows in CSV (only non-NA values)
  genus_key <- NULL
  if ("genus" %in% colnames(common_names) && "genus_conventional_name" %in% colnames(common_names)) {
    valid_genus <- !is.na(common_names$genus) & 
      !is.na(common_names$genus_conventional_name) & 
      common_names$genus != "" & 
      common_names$genus_conventional_name != ""
    
    # For each genus entry, split by ";" in case multiple genera are listed
    genus_list <- list()
    for (idx in which(valid_genus)) {
      genera <- strsplit(common_names$genus[idx], ";")[[1]]
      conv_names <- strsplit(common_names$genus_conventional_name[idx], ";")[[1]]
      
      # Trim whitespace
      genera <- trimws(genera)
      conv_names <- trimws(conv_names)
      
      # Add each genus-name pair
      for (j in seq_along(genera)) {
        if (j <= length(conv_names)) {
          genus_list[[genera[j]]] <- conv_names[j]
        }
      }
    }
    
    # Convert to named vector
    if (length(genus_list) > 0) {
      genus_key <- unlist(genus_list)
    }
  }
  
  # Get the tax_table from phyloseq
  tax_tab <- as.data.frame(tax_table(physeq))
  
  # Get ASV sequences
  if ("ASV" %in% colnames(tax_tab)) {
    asv_seqs <- tax_tab$ASV
  } else {
    asv_seqs <- rownames(tax_tab)
  }
  
  # Initialize common_name and taxa columns
  tax_tab$common_name <- NA_character_
  tax_tab$taxa <- NA_character_
  
  # Store all conflicts for reporting
  all_conflicts <- list()
  
  # Helper function to extract genus from taxon string
  extract_genera <- function(taxon_string) {
    species_list <- strsplit(taxon_string, "; ")[[1]]
    genera <- sapply(strsplit(species_list, " "), `[`, 1)
    return(unique(genera))
  }
  
  # Helper function to merge and alphabetize taxa
  merge_taxa <- function(taxa_vec) {
    # Split all taxa strings by semicolon
    all_taxa <- c()
    for (taxa_string in taxa_vec) {
      if (!is.na(taxa_string) && taxa_string != "") {
        split_taxa <- strsplit(taxa_string, "; ")[[1]]
        split_taxa <- trimws(split_taxa)
        all_taxa <- c(all_taxa, split_taxa)
      }
    }
    
    # Get unique taxa and alphabetize
    unique_taxa <- unique(all_taxa)
    unique_taxa <- sort(unique_taxa)
    
    # Concatenate with semicolons
    if (length(unique_taxa) > 0) {
      return(paste(unique_taxa, collapse = "; "))
    } else {
      return(NA_character_)
    }
  }
  
  # Helper function to singularize common names (basic rules)
  singularize <- function(word) {
    word <- tolower(trimws(word))
    
    # Special cases
    special_cases <- c(
      "berries" = "berry",
      "cherries" = "cherry",
      "strawberries" = "strawberry",
      "raspberries" = "raspberry",
      "blackberries" = "blackberry",
      "blueberries" = "blueberry",
      "cranberries" = "cranberry",
      "mulberries" = "mulberry",
      "gooseberries" = "gooseberry"
    )
    
    if (word %in% names(special_cases)) {
      return(special_cases[word])
    }
    
    # General rules
    if (grepl("sses$", word)) {
      return(sub("sses$", "ss", word))
    } else if (grepl("shes$", word)) {
      return(sub("shes$", "sh", word))
    } else if (grepl("ches$", word)) {
      return(sub("ches$", "ch", word))
    } else if (grepl("xes$", word)) {
      return(sub("xes$", "x", word))
    } else if (grepl("ies$", word) && !grepl("[aeiou]ies$", word)) {
      return(sub("ies$", "y", word))
    } else if (grepl("ves$", word)) {
      return(sub("ves$", "f", word))
    } else if (grepl("s$", word) && !grepl("ss$", word) && !grepl("us$", word)) {
      return(sub("s$", "", word))
    }
    
    return(word)
  }
  
  # Helper function to pluralize common names
  pluralize <- function(word) {
    word_lower <- tolower(trimws(word))
    
    # Special cases
    special_cases <- c(
      "potato" = "potatoes",
      "tomato" = "tomatoes",
      "cactus" = "cacti"
    )
    
    if (word_lower %in% names(special_cases)) {
      # Preserve original capitalization
      if (substring(word, 1, 1) == toupper(substring(word, 1, 1))) {
        return(paste0(toupper(substring(special_cases[word_lower], 1, 1)), 
                      substring(special_cases[word_lower], 2)))
      }
      return(special_cases[word_lower])
    }
    
    # Already plural?
    if (grepl("s$", word_lower)) {
      return(word)
    }
    
    # General rules
    if (grepl("y$", word_lower) && !grepl("[aeiou]y$", word_lower)) {
      return(sub("y$", "ies", word))
    } else if (grepl("(s|ss|sh|ch|x|z)$", word_lower)) {
      return(paste0(word, "es"))
    } else if (grepl("f$", word_lower)) {
      return(sub("f$", "ves", word))
    } else if (grepl("fe$", word_lower)) {
      return(sub("fe$", "ves", word))
    } else {
      return(paste0(word, "s"))
    }
  }
  
  # Helper function to check if one item is a subtype of another (e.g., "wild rice" is a type of "rice")
  is_subtype <- function(specific, general) {
    specific <- tolower(trimws(specific))
    general <- tolower(trimws(general))
    
    # Singularize both for comparison
    specific_sing <- singularize(specific)
    general_sing <- singularize(general)
    
    # Check if specific ends with general (e.g., "wild rice" ends with "rice")
    if (grepl(paste0("\\s", general_sing, "$"), specific_sing)) {
      return(TRUE)
    }
    
    # Also check plural form
    if (grepl(paste0("\\s", general, "$"), specific)) {
      return(TRUE)
    }
    
    return(FALSE)
  }
  
  # Helper function to consolidate subtypes
  consolidate_subtypes <- function(names_vec) {
    if (length(names_vec) <= 1) return(names_vec)
    
    # Track which items are subtypes of others
    is_subtype_of <- rep(FALSE, length(names_vec))
    general_terms <- character(length(names_vec))
    
    for (i in seq_along(names_vec)) {
      for (j in seq_along(names_vec)) {
        if (i != j && is_subtype(names_vec[i], names_vec[j])) {
          is_subtype_of[i] <- TRUE
          general_terms[i] <- names_vec[j]
          break
        }
      }
    }
    
    # If we have subtypes, replace general terms with pluralized versions
    if (any(is_subtype_of)) {
      # Identify unique general terms that have subtypes
      unique_generals <- unique(general_terms[is_subtype_of])
      
      result <- character(0)
      
      for (general in unique_generals) {
        # Pluralize the general term
        pluralized <- pluralize(general)
        result <- c(result, pluralized)
      }
      
      # Add any items that aren't subtypes and whose singular form isn't a general term
      for (i in seq_along(names_vec)) {
        if (!is_subtype_of[i]) {
          # Check if this is a general term for something else
          is_general <- names_vec[i] %in% general_terms
          
          if (!is_general) {
            result <- c(result, names_vec[i])
          }
        }
      }
      
      return(unique(result))
    }
    
    return(names_vec)
  }
  
  # Helper function to deduplicate considering plurals
  deduplicate_with_plurals <- function(names_vec) {
    if (length(names_vec) == 0) return(character(0))
    
    # Singularize all names
    singular_map <- sapply(names_vec, singularize)
    
    # For each unique singular form, keep the first occurrence (preserves original plural/singular)
    unique_singulars <- unique(singular_map)
    result <- character(length(unique_singulars))
    
    for (i in seq_along(unique_singulars)) {
      # Find first occurrence of this singular form
      first_idx <- which(singular_map == unique_singulars[i])[1]
      result[i] <- names_vec[first_idx]
    }
    
    return(result)
  }
  
  # Helper function to merge "X like Y" patterns
  merge_like_patterns <- function(names_vec) {
    # Find all "X like Y" patterns
    like_pattern <- "^(.+?)\\s+like\\s+(.+)$"
    like_indices <- grep(like_pattern, names_vec, ignore.case = TRUE)
    
    if (length(like_indices) == 0) {
      return(names_vec)
    }
    
    # Group by the "X" part
    like_groups <- list()
    for (idx in like_indices) {
      match <- regmatches(names_vec[idx], regexec(like_pattern, names_vec[idx], ignore.case = TRUE))[[1]]
      x_part <- trimws(match[2])
      y_part <- trimws(match[3])
      
      if (x_part %in% names(like_groups)) {
        like_groups[[x_part]] <- c(like_groups[[x_part]], y_part)
      } else {
        like_groups[[x_part]] <- y_part
      }
    }
    
    # Merge groups with same X
    merged_likes <- character(0)
    for (x in names(like_groups)) {
      y_parts <- unique(like_groups[[x]])
      if (length(y_parts) == 1) {
        merged_likes <- c(merged_likes, paste(x, "like", y_parts))
      } else {
        # Multiple Y parts: "X like Y and Z"
        merged_likes <- c(merged_likes, paste(x, "like", paste(y_parts[-length(y_parts)], collapse = ", "), "and", y_parts[length(y_parts)]))
      }
    }
    
    # Return non-like patterns plus merged like patterns
    non_like <- names_vec[-like_indices]
    return(c(non_like, merged_likes))
  }
  
  # Helper function to extract and merge suffix patterns
  process_suffix_patterns <- function(names_vec) {
    # Patterns to look for at the end - make them more specific to catch the suffix properly
    suffix_patterns <- list(
      other = ",?\\s*and other ([^,]+)$",
      relatives = ",?\\s*and relatives(?: in the ([^,]+))?$"
    )
    
    suffixes <- list()
    core_names <- character(0)
    
    for (name in names_vec) {
      found_suffix <- FALSE
      
      for (pattern_type in names(suffix_patterns)) {
        pattern <- suffix_patterns[[pattern_type]]
        if (grepl(pattern, name, ignore.case = TRUE)) {
          # Extract the suffix
          match <- regmatches(name, regexec(pattern, name, ignore.case = TRUE))[[1]]
          suffix_text <- match[1]  # Full match (e.g., ", and other stone fruits")
          
          # Clean up suffix (remove leading comma/space if present)
          suffix_text <- sub("^,?\\s*", "", suffix_text)
          
          # Store suffix
          if (pattern_type %in% names(suffixes)) {
            suffixes[[pattern_type]] <- c(suffixes[[pattern_type]], suffix_text)
          } else {
            suffixes[[pattern_type]] <- suffix_text
          }
          
          # Extract core part (everything before the suffix)
          core <- sub(pattern, "", name, ignore.case = TRUE)
          core <- sub(",?\\s*$", "", core)  # Remove trailing comma/space
          
          # Split core by delimiters
          core_parts <- unlist(strsplit(core, ";"))
          for (part in core_parts) {
            # Further split by comma
            comma_parts <- unlist(strsplit(part, ","))
            for (comma_part in comma_parts) {
              # Split by " and "
              and_parts <- unlist(strsplit(comma_part, "\\s+and\\s+"))
              and_parts <- trimws(and_parts)
              and_parts <- and_parts[and_parts != ""]
              core_names <- c(core_names, and_parts)
            }
          }
          
          found_suffix <- TRUE
          break
        }
      }
      
      if (!found_suffix) {
        # No special suffix, split normally
        parts <- unlist(strsplit(name, ",|;| and "))
        parts <- trimws(parts)
        parts <- parts[parts != ""]
        core_names <- c(core_names, parts)
      }
    }
    
    # Deduplicate core names
    core_names <- unique(core_names)
    
    # Return list with cores and suffixes
    return(list(
      cores = core_names,
      suffixes = suffixes
    ))
  }
  
  # Helper function to format list with "and"
  # Helper function to format list with "and"
  format_with_and <- function(items, suffix = NULL) {
    if (length(items) == 0) return("")
    
    # Check if we have a suffix
    has_suffix <- !is.null(suffix) && length(suffix) > 0
    
    # Format the core items
    if (length(items) == 1) {
      result <- items[1]
    } else if (length(items) == 2) {
      if (has_suffix) {
        # "X, Y, and suffix"
        result <- paste(items, collapse = ", ")
      } else {
        # "X and Y"
        result <- paste(items, collapse = " and ")
      }
    } else {
      # For 3 or more items
      if (has_suffix) {
        # "X, Y, Z, and suffix" (no "and" before last item)
        result <- paste(items, collapse = ", ")
      } else {
        # "X, Y, and Z" (with "and" before last item)
        result <- paste(paste(items[-length(items)], collapse = ", "), 
                        items[length(items)], 
                        sep = ", and ")
      }
    }
    
    # Add suffix if present
    if (has_suffix) {
      suffix_text <- suffix[1]
      # Suffix already starts with "and", just append with comma and space
      result <- paste0(result, ", ", suffix_text)
    }
    
    return(result)
  }
  
  # Helper function to intelligently merge names
  smart_merge_names <- function(names_vec) {
    if (length(names_vec) == 0) return("")
    
    # Step 1: Merge "X like Y" patterns
    names_vec <- merge_like_patterns(names_vec)
    
    # Step 2: Process suffix patterns and extract cores
    processed <- process_suffix_patterns(names_vec)
    cores <- processed$cores
    suffixes <- processed$suffixes
    
    # Step 3: Consolidate subtypes (e.g., "wild rice" + "rice" -> "rices")
    cores <- consolidate_subtypes(cores)
    
    # Step 4: Deduplicate cores considering plurals
    cores <- deduplicate_with_plurals(cores)
    
    # Step 5: Choose the most appropriate suffix
    final_suffix <- NULL
    if (length(suffixes) > 0) {
      # Prefer "and other X" over "and relatives"
      if ("other" %in% names(suffixes)) {
        final_suffix <- suffixes$other[1]
      } else if ("relatives" %in% names(suffixes)) {
        final_suffix <- suffixes$relatives[1]
      }
    }
    
    # Step 6: Format with "and"
    result <- format_with_and(cores, final_suffix)
    
    return(result)
  }
  
  # For each ASV in phyloseq, find matching reference sequence
  for (i in seq_along(asv_seqs)) {
    query_seq <- asv_seqs[i]
    
    # Find which reference sequences contain this query as substring
    matches <- grepl(query_seq, common_names$asv, fixed = TRUE)
    
    if (sum(matches) == 0) {
      next  # No match, stays as NA
    } else if (sum(matches) == 1) {
      # Unique match found
      tax_tab$common_name[i] <- common_names$conventional_name[matches]
      tax_tab$taxa[i] <- common_names$taxon[matches]
    } else {
      # Multiple matches - try to resolve
      matched_indices <- which(matches)
      matched_taxa <- common_names$taxon[matched_indices]
      matched_conv_names <- common_names$conventional_name[matched_indices]
      
      resolution_method <- "unresolved"
      assigned_name <- NA
      resolved <- FALSE
      
      # Merge taxa for this ASV
      tax_tab$taxa[i] <- merge_taxa(matched_taxa)
      
      # Check if one is a superset of all others (contains all species from other matches)
      for (j in seq_along(matched_taxa)) {
        species_j <- strsplit(matched_taxa[j], "; ")[[1]]
        
        is_superset_of_all <- TRUE
        for (k in seq_along(matched_taxa)) {
          if (j == k) next
          species_k <- strsplit(matched_taxa[k], "; ")[[1]]
          
          # Check if all species in species_k are also in species_j
          if (!all(species_k %in% species_j)) {
            is_superset_of_all <- FALSE
            break
          }
        }
        
        if (is_superset_of_all) {
          # Use the superset (the most comprehensive conventional name)
          tax_tab$common_name[i] <- matched_conv_names[j]
          assigned_name <- matched_conv_names[j]
          resolution_method <- "superset"
          resolved <- TRUE
          break
        }
      }
      
      # If not resolved, try genus-level matching using the full genus_key
      if (!resolved && !is.null(genus_key)) {
        # Extract all genera from matched taxa
        all_genera <- unique(unlist(lapply(matched_taxa, extract_genera)))
        
        # Get genus-level common names for all genera
        genus_common_names <- genus_key[all_genera]
        genus_common_names <- genus_common_names[!is.na(genus_common_names)]
        
        # Only resolve if we have genus mappings for ALL genera involved
        if (length(genus_common_names) == length(all_genera) && length(all_genera) > 0) {
          if (length(unique(genus_common_names)) == 1) {
            # All genera map to the same common name
            tax_tab$common_name[i] <- unique(genus_common_names)[1]
            assigned_name <- unique(genus_common_names)[1]
            resolution_method <- "genus_single"
            resolved <- TRUE
          } else {
            # Multiple genus-level common names - use smart merge
            formatted_name <- smart_merge_names(genus_common_names)
            tax_tab$common_name[i] <- formatted_name
            assigned_name <- formatted_name
            resolution_method <- "genus_multiple"
            resolved <- TRUE
          }
        } else if (length(genus_common_names) > 0) {
          # PARTIAL genus resolution: some genera have mappings, others don't
          # Combine genus-level names with conventional names for unresolved taxa
          
          # Get conventional names for taxa whose genera are NOT in genus_key
          genera_without_mapping <- all_genera[!all_genera %in% names(genus_key)]
          
          # Collect conventional names from rows where genus doesn't have mapping
          conv_names_for_unmapped <- character(0)
          for (idx in matched_indices) {
            row_genera <- extract_genera(common_names$taxon[idx])
            # If this row has genera without mappings, include its conventional name
            if (any(row_genera %in% genera_without_mapping)) {
              conv_name <- common_names$conventional_name[idx]
              if (!is.na(conv_name) && conv_name != "") {
                conv_names_for_unmapped <- c(conv_names_for_unmapped, conv_name)
              }
            }
          }
          
          # Combine genus-level names with conventional names using smart merge
          all_names <- c(genus_common_names, conv_names_for_unmapped)
          all_names <- all_names[all_names != ""]
          
          if (length(all_names) > 0) {
            formatted_name <- smart_merge_names(all_names)
            tax_tab$common_name[i] <- formatted_name
            assigned_name <- formatted_name
            resolution_method <- "genus_partial"
            resolved <- TRUE
          }
        }
      }
      
      # If still not resolved, decide whether to concatenate or use first match
      if (!resolved) {
        if (concatenate_conflicts) {
          # Concatenate unique conventional names using smart merge
          unique_names <- unique(matched_conv_names[matched_conv_names != "" & !is.na(matched_conv_names)])
          if (length(unique_names) > 0) {
            formatted_name <- smart_merge_names(unique_names)
            tax_tab$common_name[i] <- formatted_name
            assigned_name <- formatted_name
            resolution_method <- "concatenated"
          } else {
            tax_tab$common_name[i] <- matched_conv_names[1]
            assigned_name <- matched_conv_names[1]
            resolution_method <- "first_match_default"
          }
        } else {
          # Use first match as default
          tax_tab$common_name[i] <- matched_conv_names[1]
          assigned_name <- matched_conv_names[1]
          resolution_method <- "first_match_default"
        }
      }
      
      # Record this conflict (all of them, regardless of resolution)
      all_conflicts[[length(all_conflicts) + 1]] <- data.frame(
        asv_index = i,
        asv_seq = substr(query_seq, 1, 50),  # Truncate for readability
        num_matches = length(matched_indices),
        resolution_method = resolution_method,
        assigned_common_name = assigned_name,
        assigned_taxa = tax_tab$taxa[i],
        all_conventional_names = paste(matched_conv_names, collapse = " | "),
        all_taxa = paste(matched_taxa, collapse = " || "),
        genera = paste(unique(unlist(lapply(matched_taxa, extract_genera))), collapse = ", "),
        stringsAsFactors = FALSE
      )
    }
  }
  
  # Update the tax_table in phyloseq
  tax_table(physeq) <- as.matrix(tax_tab)
  
  # Report conflicts if requested
  if (report_conflicts && length(all_conflicts) > 0) {
    conflicts_df <- do.call(rbind, all_conflicts)
    
    if (report_all_conflicts) {
      # Report all conflicts
      message(paste("\nFound", nrow(conflicts_df), "total conflicts (multiple matches):"))
      message("\nBreakdown by resolution method:")
      print(table(conflicts_df$resolution_method))
      message("\n")
      print(conflicts_df)
    } else {
      # Only report unresolved conflicts
      unresolved <- conflicts_df[conflicts_df$resolution_method %in% 
                                   c("unresolved", "first_match_default", "concatenated"), ]
      if (nrow(unresolved) > 0) {
        message(paste("\nFound", nrow(unresolved), "unresolved conflicts:"))
        print(unresolved)
      }
    }
    
    # Store all conflicts as attribute
    attr(physeq, "common_name_conflicts") <- conflicts_df
  }
  
  return(physeq)
}

# Usage examples:
# Basic usage with default settings:
# physeq_updated <- assign_common_names(physeq, "path/to/your/common_names.csv")

# With concatenation enabled:
# physeq_updated <- assign_common_names(physeq, "path/to/your/common_names.csv", 
#                                       concatenate_conflicts = TRUE)

# View the updated tax_table with taxa column:
# View(as.data.frame(tax_table(physeq_updated)))

# View conflicts:
# View(attr(physeq_updated, "common_name_conflicts"))
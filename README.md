# lad-lab.github.io

Source for the David Lab FoodSeq Handbook ([lad-lab.github.io](https://lad-lab.github.io)). Built with [MkDocs](https://www.mkdocs.org/) + Material theme.

## Branches

- `source` — markdown source of truth. Edit here.
- `main` — built static site (CI output). Don't edit; GitHub Pages serves this.

## Local preview

```bash
pip install mkdocs-material mkdocs-git-authors-plugin mkdocs-git-revision-date-localized-plugin
mkdocs serve
```

Open http://127.0.0.1:8000.

## PR preview deploys

Pushes to any branch other than `source` / `main` build the site and publish it to a per-branch subfolder of `main`:

```
https://lad-lab.github.io/previews/<branch-name>/
```

Branch names with `/` are flattened with `-` (e.g. `feature/foo` becomes `previews/feature-foo/`). When a PR is opened against `source`, the workflow comments the preview URL on the PR and updates it on every push. Closing or merging the PR deletes the subfolder.

Workflow: `.github/workflows/preview.yml`.

## Production deploy

Push to `source` triggers `.github/workflows/ci.yml`, which runs `mkdocs build` and publishes `./site` to the root of `main`. Previews under `main/previews/` are kept across deploys.

If you add an mkdocs plugin, update the `pip install` line in **both** `ci.yml` and `preview.yml`.

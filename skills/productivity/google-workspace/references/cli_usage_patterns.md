# Google API CLI (`google_api.py`) Usage Patterns

This document contains verified, working command-line patterns for the `google_api.py` script. These have been discovered through trial and error and should be preferred over ad-hoc command construction.

## `drive create-folder`

**Correct:**
- `name` is a positional argument.
- The parent folder ID is specified with `--parent`.

```bash
python /path/to/google_api.py drive create-folder --parent <PARENT_ID> <FOLDER_NAME>
```

**Incorrect (and will fail):**
- Using `--name` for the folder name.
- Using `--parent_id` for the parent ID.

## `drive upload`

**Correct:**
- `file_path` is a positional argument.
- The parent folder ID is specified with `--parent`.

```bash
python /path/to/google_api.py drive upload --parent <PARENT_ID> /path/to/local/file.ext
```

**Incorrect (and will fail):**
- Using `--file_path` for the file path.
- Using `--parent_id` for the parent ID.

## `drive search`

**Correct:**
- `query` is a positional argument.
- For complex queries containing spaces or special characters, use the `--raw-query` flag to prevent the script's default text search behavior.

```bash
# Searching for files within a specific folder
python /path/to/google_api.py drive search --raw-query "'<FOLDER_ID>' in parents"
```

**Incorrect (and will fail):**
- Using `--query` as an argument name.
- Not using `--raw-query` for parent folder searches, which will result in an `HttpError 400: Invalid Value`.

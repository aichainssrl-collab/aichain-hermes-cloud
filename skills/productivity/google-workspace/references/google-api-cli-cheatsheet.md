# Google Workspace API Script (`google_api.py`) Cheatsheet

This script, found in the `google-workspace` skill, uses a non-standard CLI syntax. Refer to this guide to avoid common errors.

## Key Principles
- Most commands use **positional arguments**, not flags like `--name` or `--file_path`.
- The order of arguments is crucial.
- Use `--help` on any subcommand if you are unsure (e.g., `... drive create-folder --help`).

## Drive Commands

### `drive create-folder`
Creates a new folder.

- **Syntax**: `python .../google_api.py drive create-folder [--parent PARENT_ID] FOLDER_NAME`
- **`PARENT_ID`**: The ID of the parent folder. Uses `--parent` flag.
- **`FOLDER_NAME`**: The name of the new folder. **Positional argument**.

**Correct Usage:**
```bash
# Creates '2026-05-15' inside the folder with ID '123xyz'
python .../google_api.py drive create-folder --parent 123xyz 2026-05-15
```
**Incorrect Usage (will fail):**
```bash
# Fails because --name and --parent_id are not valid flags
python .../google_api.py drive create-folder --name 2026-05-15 --parent_id 123xyz
```

---

### `drive upload`
Uploads a local file.

- **Syntax**: `python .../google_api.py drive upload [--parent PARENT_ID] LOCAL_FILE_PATH`
- **`PARENT_ID`**: The ID of the destination folder. Uses `--parent` flag.
- **`LOCAL_FILE_PATH`**: The path to the local file to upload. **Positional argument**.

**Correct Usage:**
```bash
# Uploads /tmp/report.md to the folder with ID 'abc789'
python .../google_api.py drive upload --parent abc789 /tmp/report.md
```
**Incorrect Usage (will fail):**
```bash
# Fails because --file_path is not a valid flag
python .../google_api.py drive upload --parent abc789 --file_path /tmp/report.md
```

---

### `drive search`
Searches for files and folders.

- **Syntax**: `python .../google_api.py drive search [--raw-query] QUERY_STRING`
- **`QUERY_STRING`**: The search query. **Positional argument**. Must be enclosed in quotes if it contains spaces.
- **`--raw-query`**: **Crucial flag**. Use this to pass a standard Google Drive API query (e.g., `'<folder_id>' in parents`). Without it, the script defaults to a full-text search which often fails for specific queries.

**Correct Usage:**
```bash
# Finds all files directly inside the folder with ID '1rJ...bG3F'
python .../google_api.py drive search --raw-query "'1rJkFVq5y5E2RwH8GejIpNG4bpq0VbG3F' in parents"
```
**Incorrect Usage (will fail):**
```bash
# Fails because --query is not a valid flag
python .../google_api.py drive search --query "'1rJ...' in parents"

# Fails because the query is interpreted as a full-text search and is invalid
python .../google_api.py drive search "'1rJ...' in parents"
```

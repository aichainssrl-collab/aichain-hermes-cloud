# Google Workspace CLI (`google_api.py`) Syntax Examples

This document provides correct, copy-pastable command examples for the `google_api.py` script, focusing on common pitfalls with argument parsing.

### Drive: Create a Folder

**Mistake**: Using `create_folder` or `--parent_id`.
**Correct Syntax**: The action is `create-folder`, the folder name is a positional argument, and the parent is specified with `--parent`.

```bash
# Correct
python /path/to/google_api.py drive create-folder --parent <PARENT_FOLDER_ID> "My New Folder Name"
```

### Drive: Upload a File

**Mistake**: Using `--file_path` or `--parent_id`.
**Correct Syntax**: The local file path is a positional argument, and the parent is specified with `--parent`.

```bash
# Correct
python /path/to/google_api.py drive upload --parent <PARENT_FOLDER_ID> /path/to/local/file.txt
```

### Drive: Search for a File/Folder

**Mistake**: Using `--query` for a simple search, or failing to use `--raw-query` for complex API queries.
**Correct Syntax**: For simple text searches, `query` is a positional argument. For Drive API syntax (e.g., searching in a specific parent), you MUST use the `--raw-query` flag.

```bash
# Correct - Simple text search
python /path/to/google_api.py drive search "report Q1"

# Correct - Advanced search for a folder by name within a specific parent
python /path/to/google_api.py drive search --raw-query "name='My Folder' and '<PARENT_FOLDER_ID>' in parents and mimeType='application/vnd.google-apps.folder'"
```

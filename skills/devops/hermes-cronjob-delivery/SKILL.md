---
name: hermes-cronjob-delivery
description: Configure Hermes Agent cron jobs to deliver reports to external storage services like Google Drive.
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [cronjob, delivery, google-drive, automation, reporting, external-storage]
    category: devops
    related_skills: [google-workspace, cronjob-troubleshooting]
---

# Hermes Cron Job External Delivery

This skill provides a workflow for configuring Hermes Agent cron jobs to deliver their generated reports to external storage services (e.g., Google Drive, S3, custom endpoints) rather than relying solely on the default `deliver` parameter (which typically targets messaging platforms).

## When This Skill Activates

Use this skill when the user requests:
- Cron job reports to be saved to Google Drive, AWS S3, or any other external storage.
- A custom delivery mechanism for cron job output.
- To bypass direct messaging delivery for cron job results.

## Problem Statement

The `cronjob` tool's `deliver` parameter is designed primarily for sending the agent's final output to the origin platform (e.g., Telegram chat). For external file storage, a more elaborate workflow is required.

## Solution Workflow: Agent-driven External Upload

This workflow leverages the cron job agent's `terminal` and `file` toolset capabilities to handle local file generation and subsequent upload.

1.  **Create a Helper Script:** Develop a Python (or shell) script that handles the actual upload to the target external service. This script should take the local file path and any necessary credentials/destination IDs as arguments.
    -   **Example:** For Google Drive, create `scripts/upload_to_drive.py` (see references below).

2.  **Modify Cron Job Prompt:** Update the `prompt` of the cron job to instruct the agent running the job to:
    a.  Perform its primary task and generate the report content.
    b.  **Write the generated report content to a local file.** Ensure the filename is unique (e.g., includes a timestamp/date) and that the target directory exists (the agent can create it if needed).
    c.  **Execute the helper script** (created in step 1) using the `terminal` tool, passing the path to the locally saved report file and the destination ID/parameters as arguments.
    d.  **Print the output/confirmation of the helper script** as its final response. This ensures the delivery status is visible.

3.  **Adjust Cron Job Parameters:**
    a.  Ensure the `enabled_toolsets` for the cron job include `terminal` and `file` so the agent can write files and execute scripts.
    b.  The `deliver` parameter can remain `origin` (to show the confirmation from the upload script) or be set to `local` if no output is desired in the chat.
    c.  Ensure the `model` used by the cron job is capable of understanding and executing multi-step instructions, including dynamic file naming and tool execution (e.g., `gemini-2.5-flash-lite`).

## Example Prompt Snippet (for an agent using `upload_to_drive.py`)

```markdown
**Istruzioni Finali:**
1.  Determina la data corrente nel formato `YYYY-MM-DD` (es. `2026-05-14`).
2.  Crea un nome file unico per il report usando la data: `/tmp/my_reports/report_YYYY-MM-DD.md`.
3.  Scrivi l'intero report dettagliato in questo file.
4.  Una volta scritto il report, utilizza lo script Python `/home/fred/.hermes/scripts/upload_to_drive.py` per caricare questo file nella cartella Google Drive con ID `<YOUR_GOOGLE_DRIVE_FOLDER_ID>`. Devi passare il percorso completo del file appena creato come primo argomento e l'ID della cartella come secondo argomento allo script. La riga di comando sarà `python /home/fred/.hermes/scripts/upload_to_drive.py <percorso_file_report> <YOUR_GOOGLE_DRIVE_FOLDER_ID>`.
5.  Infine, stampa l'intero output dello script `upload_to_drive.py` per confermare l'avvenuto caricamento. Non stampare altro dopo il risultato dello script.
```

## Pitfalls

-   **Agent Capabilities:** Ensure the chosen model (`model` parameter of the cron job) is capable of advanced reasoning, dynamic string formatting (for filenames), and tool execution (`terminal`, `file`) as instructed by the prompt.
-   **Toolset Access:** The cron job must have `terminal` and `file` in its `enabled_toolsets` to execute the upload script and write local files.
-   **Script Permissions & Dependencies:** The helper script (`upload_to_drive.py`) must have execute permissions and all its Python dependencies (e.g., `google-api-python-client`, `google-auth-oauthlib`) must be installed in the environment where Hermes Agent runs.
-   **Authentication:** For services like Google Drive, ensure the `google-workspace` skill is properly authenticated and its token is accessible by the helper script (e.g., `~/.hermes/google_token.json`).
-   **Error Handling:** The helper script should include robust error handling and informative print statements to help debug issues during cron job execution.
-   **Dynamic File Paths:** The prompt must clearly guide the agent on how to generate unique, temporary file paths for the reports to avoid overwriting previous reports.

## References

-   `scripts/upload_to_drive.py`: A Python script example for uploading a file to Google Drive using `google-api-python-client`.

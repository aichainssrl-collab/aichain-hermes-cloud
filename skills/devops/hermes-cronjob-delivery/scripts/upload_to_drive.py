
import sys
import os
import json
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from google.oauth2.credentials import Credentials

# Path to the token file (same as google-workspace skill)
TOKEN_PATH = os.path.expanduser("~/.hermes/google_token.json")

def upload_file_to_drive(file_path, folder_id):
    try:
        # Load credentials from the token file
        creds = Credentials.from_authorized_user_file(TOKEN_PATH, scopes=None)

        # Build the Drive service
        service = build('drive', 'v3', credentials=creds)

        file_name = os.path.basename(file_path)
        mime_type = 'text/plain' # Default, can be refined based on file extension if needed

        file_metadata = {'name': file_name, 'parents': [folder_id]}
        media = MediaFileUpload(file_path, mimetype=mime_type, resumable=True)

        file = service.files().create(body=file_metadata, media_body=media, fields='id, name, webViewLink').execute()

        print(f"File '{file.get('name')}' (ID: {file.get('id')}) uploaded to Google Drive.")
        print(f"View link: {file.get('webViewLink')}")
        return file.get('id')

    except Exception as e:
        print(f"Error uploading file to Google Drive: {e}")
        return None

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python upload_to_drive.py <file_path> <folder_id>")
        sys.exit(1)

    report_file_path = sys.argv[1]
    destination_folder_id = sys.argv[2]

    if not os.path.exists(report_file_path):
        print(f"Error: File not found at '{report_file_path}'")
        sys.exit(1)

    upload_file_to_drive(report_file_path, destination_folder_id)

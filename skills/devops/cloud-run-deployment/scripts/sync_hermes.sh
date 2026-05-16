#!/bin/bash
BUCKET_NAME="aichain-hermes-data"
WIKI_PATH="/home/fred/wiki"
HERMES_STATE="/home/fred/.hermes"

echo "Starting hybrid sync..."

if command -v gcloud &> /dev/null; then
  echo "Syncing files from GCS..."
  mkdir -p $WIKI_PATH
  mkdir -p $HERMES_STATE
  gcloud storage sync gs://$BUCKET_NAME/wiki $WIKI_PATH --delete-unmatched-destination-objects
  gcloud storage sync gs://$BUCKET_NAME/hermes-state $HERMES_STATE --delete-unmatched-destination-objects
else
  echo "Warning: gcloud not found. Skipping GCS sync."
fi

if [ -n "$FIRESTORE_PROJECT_ID" ]; then
    echo "Firestore detected, ensuring memory provider is set..."
    hermes config set memory.provider firestore
fi

echo "Hybrid sync complete."

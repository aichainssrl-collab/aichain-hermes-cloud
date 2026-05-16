---
name: cloud-run-deployment
description: "Workflows for deploying Hermes Agent to Google Cloud Run with persistent hybrid storage."
version: 1.0.0
author: Hermes Agent
---

# Cloud Run Deployment for Hermes Agent

This skill manages the deployment of Hermes Agent on Google Cloud Run, specifically handling the "stateless-to-stateful" transition using a hybrid storage approach.

## Hybrid Storage Architecture
- **GCS (Google Cloud Storage)**: Primary storage for the Wiki, session logs, and skill definitions.
- **Firestore**: Memory backend for operational data, providing atomic concurrency for multi-instance agent setups.

## Deployment Workflow

### 1. Persistent Sync Script
Use a specialized entrypoint script (`sync_hermes.sh`) to synchronize GCS state at boot time.

```bash
#!/bin/bash
# Sync GCS wiki and state before booting Hermes
gcloud storage sync gs://$BUCKET_NAME/wiki /home/fred/wiki --delete-unmatched-destination-objects
gcloud storage sync gs://$BUCKET_NAME/hermes-state /home/fred/.hermes --delete-unmatched-destination-objects
```

### 2. Dockerfile Integration
Ensure the container installs necessary gcloud SDKs and runs the sync script before the gateway:

```dockerfile
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/sync_hermes.sh && hermes gateway run"]
```

## Support Files
- `scripts/sync_hermes.sh` — Entrypoint script for hybrid GCS/Firestore sync.

- **State Concurrency**: Avoid GCS file locking issues by using Firestore for agent "memory" and GCS only for documents (Wiki/Sessions).
- **Cold Starts**: If using Cron jobs, trigger them via Cloud Scheduler Webhooks rather than relying on the internal Hermes cron daemon in an idle Cloud Run instance.
- **Service Identity**: The Cloud Run service account must have `Storage Object Admin` and `Cloud Datastore User` roles.

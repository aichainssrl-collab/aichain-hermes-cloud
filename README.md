# Aichain Hermes Cloud

Questa è l'infrastruttura core per la **Cyber Azienda** di Aichain Solutions, basata su Hermes Agent e pronta per il deployment su Google Cloud Run.

## Componenti
- **Hermes Agent**: Motore AI autonomo con skill e memoria persistente.
- **Docker**: Containerizzazione per Cloud Run (supporta sincronizzazione ibrida).
- **Infrastruttura**:
    - **GCS**: Sincronizzazione dinamica di Wiki e Skills per utente.
    - **Firestore**: Backend per la memoria cross-session (persistenza atomica).
- **Dashboard**: Integrazione con Open WebUI per interfaccia grafica e voce.

## Struttura
- `Dockerfile`: Definizione ambiente Cloud.
- `scripts/sync_hermes.sh`: Script di sincronizzazione ibrida (User-aware).
- `skills/`: Libreria di competenze aziendali.
- `env.template`: Template per le variabili d'ambiente.

## Setup Cloud
1. Configurare il bucket GCS: `aichain-hermes-data`.
2. Configurare Firestore nel progetto GCP.
3. Deployare su Cloud Run con le variabili `USER_ID` e `FIRESTORE_PROJECT_ID`.

## Sviluppo
Il sistema supporta un'architettura multi-agente. Aggiungi i dipartimenti nell'org-chart della Wiki per iniziare la delegazione.

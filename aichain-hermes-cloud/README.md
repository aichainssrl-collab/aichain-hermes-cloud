# Aichain Hermes Cloud

Questa è l'infrastruttura core per la **Cyber Azienda** di Aichain Solutions.

## Test Locale (Passo-a-Passo)

Segui questi passaggi per testare l'infrastruttura completa nel tuo ambiente locale.

### 1. Preparazione
Assicurati di avere `docker`, `docker-compose` e `gcloud` installati.

```bash
# Entra nella cartella del progetto
cd aichain-hermes-cloud

# Crea il file .env partendo dal template
cp env.template .env

# Compila il .env con le tue credenziali (GITHUB_TOKEN, GOOGLE_API_KEY, ecc.)
nano .env
```

### 2. Autenticazione Cloud
Per permettere al container di sincronizzare i dati dal bucket GCS durante il test locale:
```bash
gcloud auth application-default login
```

### 3. Avvio dell'Infrastruttura
Lancia i container (Hermes Agent + Dashboard WebUI):
```bash
docker-compose -f dashboard/docker-compose.yaml up --build -d
```

### 4. Verifica
- **Dashboard WebUI**: Apri il browser su `http://localhost:3006`.
- **Logs Hermes**: Verifica che il container sia partito correttamente:
  ```bash
  docker-compose -f dashboard/docker-compose.yaml logs -f hermes
  ```

### 5. Utilizzo
- Accedi alla dashboard su `http://localhost:3006`.
- Crea l'account admin.
- L'agente è connesso via API e pronto a rispondere. Puoi attivare la modalità vocale (microfono) direttamente dalla UI.

---

## Architettura Cloud-Native
- **Sincronizzazione**: Al boot, lo script `scripts/sync_hermes.sh` scarica Wiki e Skills dal bucket GCS configurato.
- **Memoria**: Hermes usa Firestore per la persistenza delle sessioni.
- **Privacy**: La cartella `wiki/` è esclusa da Git per mantenere i dati aziendali riservati.
EOF

---
title: Cron Jobs Management
created: 2026-05-14
updated: 2026-05-14
type: concept
tags: [jobs, operazioni, automazione, monitoraggio, troubleshooting]
sources: []
---

# Gestione dei Cron Job in Aichain Solutions

Questa pagina documenta la gestione e il monitoraggio dei cron job essenziali per le operazioni di [[aichain-solutions-overview]]. I cron job sono utilizzati per automatizzare attività ricorrenti di marketing, analisi e intelligence di mercato.

## Obiettivo
Assicurare l'esecuzione affidabile e l'efficienza delle attività automatizzate, garantendo che i report e le analisi siano prodotti regolarmente e con la configurazione corretta.

## Strumenti Utilizzati
I cron job sono gestiti tramite il tool `cronjob` dell'assistente AI [[buddy]].

## Cron Job Attuali

### 1. [[analisi-mercato-aichain-solutions-job]]
- **ID:** `a5dbf27f08f5`
- **Nome:** Analisi Mercato Aichain Solutions
- **Scopo:** Eseguire analisi di mercato periodiche per identificare opportunità e minacce.
- **Schedule:** Ogni giorno alle 09:00.
- **Modello Attuale:** `gemini-2.5-flash-lite` (Google).
- **Stato:** Attualmente schedulato, ma ha riscontrato errori in esecuzioni recenti.
- **Note:** Necessita di indagine per risolvere gli errori di esecuzione e garantire l'output.

### 2. [[aichain-marketing-lead-job]]
- **ID:** `a1ee309334ce`
- **Nome:** Aichain Marketing Lead
- **Scopo:** Fornire analisi SEO e proposte di azioni concrete per migliorare il posizionamento e il traffico organico.
- **Schedule:** Dal lunedì al venerdì alle 09:30.
- **Modello Attuale:** `gemini-2.5-flash-lite` (Google).
- **Stato:** Schedulato, ma l'ultima esecuzione ha dato errore.

### 3. [[marketing-kpi-job]]
- **ID:** `1a3788a4ddb2`
- **Nome:** Marketing KpI
- **Scopo:** Duplicato del job 'Aichain Marketing Lead', utilizzato per testare configurazioni e modelli.
- **Schedule:** Dal lunedì al venerdì alle 09:30.
- **Modello Attuale:** `gemini-2.5-flash-lite` (Google).
- **Stato:** Ultima esecuzione completata con successo.

## Troubleshooting e Debugging
- In caso di errori di esecuzione, è fondamentale controllare i log del `hermes-agent` sul server. L'assistente AI può indicare lo stato generale del job ma non ha accesso diretto ai log dettagliati delle singole esecuzioni per la risoluzione dei problemi.
- Quando un job non produce output o restituisce errori, verificare il prompt, le skill caricate e la disponibilità degli strumenti (`toolsets`).

## Politiche di Aggiornamento
- Ogni modifica alla configurazione di un cron job deve essere documentata in questa pagina e nel `log.md` del wiki.
- La creazione o eliminazione di job deve essere registrata.

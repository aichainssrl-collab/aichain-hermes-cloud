---
title: Marketing KpI Job
created: 2026-05-14
updated: 2026-05-14
type: entity
tags: [job, marketing, kpi, testing, automazione]
sources: []
---

# Marketing KpI Job

Questo cron job (`1a3788a4ddb2`) è un duplicato del job [[aichain-marketing-lead-job]], creato specificamente per testare e validare le configurazioni dei job, inclusi i modelli AI e le skill. È stato eseguito con successo oggi, confermando la sua operatività con il modello `gemini-2.5-flash-lite`.

## Dettagli del Job
- **ID:** `1a3788a4ddb2`
- **Nome:** Marketing KpI
- **Scopo:** Testare e convalidare la funzionalità dei job di marketing, fungendo da sandbox per nuove configurazioni senza impattare i job di produzione.
- **Schedule:** Dal lunedì al venerdì alle 09:30 (`30 9 * * 1-5`).
- **Modello Attuale:** `gemini-2.5-flash-lite` (Google).
- **Provider:** Google.
- **Skill Caricate:** `seo-audit`.
- **Toolset Abilitati:** `web`, `browser`, `file`, `terminal`, `cronjob`.
- **Workdir:** `/home/fred/Documents`.
- **Stato:** Ultima esecuzione completata con successo, a differenza del job originale.

## Risultati dei Test
L'esecuzione odierna ha dimostrato che il job, con la configurazione attuale (incluso `gemini-2.5-flash-lite` e la skill `seo-audit`), è in grado di completare l'esecuzione e produrre un output. Questo suggerisce che l'errore nel job originale potrebbe non essere direttamente legato alla combinazione modello/skill, ma forse a un problema transitorio o a un altro fattore non ancora identificato.

## Relazioni
- Fa parte della [[cron-jobs-management]] per le operazioni di Aichain Solutions.
- Duplicato e strettamente correlato al job [[aichain-marketing-lead-job]].


This document shows an example of the `execute_code` block used to initialize the Aichain Solutions wiki.

```python
import os
import datetime
from hermes_tools import write_file

# --- Configuration ---
WIKI_PATH = os.path.expanduser("~/Documents/Aichain-Knowledge-Vault")
TODAY = datetime.datetime.now().strftime("%Y-%m-%d")

# --- Directory Structure ---
DIRS = [
    "raw/articles", "raw/papers", "raw/transcripts", "raw/assets",
    "entities", "concepts", "comparisons", "queries", "procedures"
]

print(f"--- Inizializzazione del Wiki in: {WIKI_PATH} ---")

try:
    for d in DIRS:
        os.makedirs(os.path.join(WIKI_PATH, d), exist_ok=True)
    print("✅ Struttura delle cartelle creata.")

    # --- Create SCHEMA.md ---
    SCHEMA_CONTENT = """
# Wiki Schema - Aichain Solutions

## Domain
Questa è la base di conoscenza centralizzata per Aichain Solutions. Copre: strategie di business, analisi di mercato, profili dei competitor, specifiche dei prodotti (Zentratto, SignSisure), procedure operative, e scoperte di ricerca.

## Conventions
- Nomi dei file: `lowercase-con-trattini.md`
- Ogni pagina inizia con frontmatter YAML.
- Link interni con `[[wikilinks]]`.
- Ogni azione registrata su `log.md`.

## Frontmatter
`yaml
---
title: Titolo Pagina
created: YYYY-MM-DD
updated: YYYY-MM-DD
type: entity | concept | comparison | query | summary | procedure
tags: [dalla tassonomia]
sources: [raw/articles/nome-fonte.md]
---
`

## Tag Taxonomy
- **Azienda**: business-plan, roadmap, kpi, legale
- **Mercato**: competitor, analisi-mercato, trend, lead-gen
- **Prodotti**: zentratto, signsisure, feature, eidas-2.0
- **Marketing**: seo, content-strategy, social-media, campagne
- **Tecnologia**: AI, blockchain, RAG, open-source
"""
    write_file(os.path.join(WIKI_PATH, "SCHEMA.md"), SCHEMA_CONTENT)
    print("✅ Creato SCHEMA.md.")

    # --- Create index.md ---
    INDEX_CONTENT = f"""
# Wiki Index

> Catalogo dei contenuti. Ogni pagina è listata qui.
> Ultimo aggiornamento: {TODAY} | Pagine totali: 1

## Procedure
- [[000-benvenuto-nel-wiki.md|Benvenuto nel Wiki di Aichain Solutions]]
"""
    write_file(os.path.join(WIKI_PATH, "index.md"), INDEX_CONTENT)
    print("✅ Creato index.md.")

    # --- Create log.md ---
    LOG_CONTENT = f"""
# Wiki Log

> Log cronologico di tutte le azioni sul wiki.
> Formato: `## [YYYY-MM-DD] azione | soggetto`

## [{TODAY}] create | Wiki initializzato
- Dominio: Aichain Solutions
- Struttura creata con SCHEMA.md, index.md, log.md.
"""
    write_file(os.path.join(WIKI_PATH, "log.md"), LOG_CONTENT)
    print("✅ Creato log.md.")

    # --- Create Welcome Note ---
    WELCOME_NOTE_CONTENT = f"""
---
title: Benvenuto nel Wiki di Aichain Solutions
created: {TODAY}
updated: {TODAY}
type: procedure
tags: [wiki, onboarding]
sources: []
---

# Benvenuto nel Cervello Condiviso di Aichain Solutions

Questo è il nostro **Knowledge Vault**, un posto dove tutte le informazioni strategiche, le analisi, e le procedure vengono salvate e collegate.

**Come Funziona:**
- **Io (Buddy)**: Popolo e mantengo questo wiki usando i miei tool (`llm-wiki`). Aggiungo note dalle mie ricerche, collego concetti e mantengo tutto organizzato.
- **Tu (Il Boss)**: Usi **Obsidian** per visualizzare, modificare e navigare questa conoscenza. Puoi vedere le connessioni, aggiungere le tue intuizioni e usare questo spazio come il tuo "secondo cervello" strategico.
"""
    write_file(os.path.join(WIKI_PATH, "000-benvenuto-nel-wiki.md"), WELCOME_NOTE_CONTENT)
    print("✅ Creata nota di benvenuto.")
    print("\\n--- Inizializzazione Completata con Successo! ---")

except Exception as e:
    print(f"❌ Si è verificato un errore durante l'inizializzazione: {e}")
```

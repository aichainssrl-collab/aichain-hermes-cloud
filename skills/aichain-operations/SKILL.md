---
name: aichain-operations
description: Daily ops for Aichain Solutions — competitor gap tracking, social analytics, market intelligence, marketing workflow structure, Drive/Sheet organization, and the 2-job pipeline (Intelligence → Marketing).
version: 1.0.0
---

# Aichain Operations

Daily operational workflows for Aichain Solutions (Milano) — intelligence gathering, competitor analysis, social analytics, and marketing execution.

## Company Context
- **Name**: Aichain Solutions
- **Site**: aichainsolutions.net
- **Products**: Zentratto (RAG per documenti) + SignSisure (Blockchain conformità legale)
- **Target**: Avvocati, Commercialisti, Consulenti del Lavoro
- **Differentiator**: Compliance eIDAS 2.0 solver, RAG + Blockchain combo USP
- **Language**: Italiano puro, ZERO inglesismi

## Two-Job Pipeline (MANDATORY ORDER)

The daily workflow runs in TWO sequential jobs. Job 2 depends on Job 1's output.

### Job 1: Intelligence (Daily at 09:00)
**Scope**: External world scan — news + competitor landscape.

1. Search Brave API for news on AI/Blockchain B2B, eIDAS 2.0, legal tech
2. Scan for competitors in: ECM, RAG AI, Firma Digitale, Blockchain B2B, AI+Blockchain automation
3. Update Google Sheet competitor gap (append, NEVER replace)
4. Save markdown report to Drive: `Marketing/AAAA-MM-GG/news-ai-blockchain-b2b.md`
5. If numeric data exists, create Sheet: `Marketing/AAAA-MM-GG/statistiche-mercato-ai-blockchain`

### Job 2: Marketing Strategist (Daily at 09:30)
**Scope**: Read Job 1 output → update memory → create marketing assets.

1. **READ**: Job 1 report (news + competitor data)
2. **READ**: Social analytics dashboard
3. **READ**: Knowledge Base (`~/Documents/Aichain-Knowledge/`)
4. **UPDATE**: Internal memory with today's findings
5. **CREATE**: Social posts, blog structure, articles, email templates
6. **UPDATE**: Social analytics Google Sheet (follower counts, engagement)
7. **DETERMINE**: If strategy needs adjusting (based on competitor moves or declining metrics), flag it

## Competitor Gap Tracking

### Search Queries (Brave API)
```python
queries = [
    '"Enterprise Content Management AI" RAG B2B',
    '"Firma digitale eIDAS 2.0" API enterprise',
    '"Blockchain document management" B2B automation',
    '"AI automation blockchain" enterprise compliance',
    '"Digital signature RAG" legal tech',
]
```

### Competitor Categories to Monitor
- **ECM/Document Management**: Namirial, Aruba, InfoCert, DocuSign, Yousign
- **Legal/Accounting**: TeamSystem, Zucchetti, LexDo.it
- **Innovation/AI**: Legal-tech startups, RAG document platforms, blockchain notarization

### Google Sheet Structure: Competitor Gap
```
| Data | Competitor | Categoria | Azione/Oggi | Canale Marketing | Feature Chiave | Gap vs Aichain | Azione Suggerita |
```

### How to Calculate Gap
1. List their features (from website/LinkedIn/news)
2. Compare against Aichain: Zentratto + SignSisure
3. Identify: "What they have that we don't" (threat)
4. Identify: "What we have that they don't" (our USP → marketing angle)
5. If they launch something new → suggest counter-content within 24h

## Social Analytics Tracking

### Google Sheet Structure: Social Dashboard
```
| Data | Piattaforma | Follower | Crescita | Post | Engagement Rate | Note |
|------|------------|----------|----------|------|----------------|------|
```
Platforms: LinkedIn, Instagram, X/Twitter, Meta/Facebook

### What to Track Daily
- Follower count per platform
- Engagement rate recent posts
- Competitor social activity
- Content that performed best

## Drive Folder Convention (NON-NEGOTIABLE)

ONE daily folder, NO subfolders. Files have descriptive names:
```
Marketing/
  2026-05-12/
    2026-05-12-news-ai-blockchain-b2b.md
    2026-05-12-statistiche-mercato.md  (only if metrics found)
    audit-seo.md
    struttura-articolo-blog.md
    articolo-bozza.md
    report-social.md
    campagne-giornaliere.md
    lista-lead.md
    email-template-lead.md
```

### Key IDs
- Marketing Drive folder: `14iDBnIiY2TXzbT_CO1TeAOHKTiJotC69`
- Lead Sheet: `1Yht2eN0N0RVSsYI7XEcB8HglEK9hQA_1SwtlgItiQsE` (Foglio1)
- News Drive folder: `1hI29Szz3xnVWqek8YYOYmek19Hp65p8w`

## Knowledge Base Structure
```
~/Documents/Aichain-Knowledge/
├── 01-Strategia/    (Business plan, roadmap, copy rules)
├── 02-Mercato/      (Competitors, trends, analysis)
├── 03-Clienti/      (Client types, feedback, converted leads)
├── 04-Prodotti/     (Zentratto, SignSisure, features, bugs)
└── 05-Report/       (Daily reports and learnings)
```
Every agent MUST read this before working and write learnings back to it after.

## Tools
- **GAPI**: `python /home/fred/.hermes/skills/productivity/google-workspace/scripts/google_api.py`
- **Brave Search**: `BSAaT9y8bgpxo2pGTvL-hkDnMZXLFi6`
- **Ollama**: `localhost:11434` (Gemma 3 4B) — use for simple tasks to save API costs

## Pitfalls
- **`google_api.py` Syntax**: Lo script ha una sintassi CLI specifica e non standard.
  - **Creare cartelle**: `python ... drive create-folder --parent PARENT_ID NOME_CARTELLA` (nome è posizionale, flag è `--parent`).
  - **Caricare file**: `python ... drive upload --parent PARENT_ID PERCORSO_FILE` (percorso è posizionale).
  - **Ricerca query**: `python ... drive search --raw-query "'PARENT_ID' in parents"` (la query è posizionale e richiede il flag `--raw-query` per funzionare con gli ID, altrimenti cerca nel testo completo).
## Pitfalls
- Brave Search API has an aggressive rate limit. Sequential queries should have a short delay (e.g., `time.sleep(1)`) to avoid `429 Too Many Requests` errors.
- Never invent leads or competitor data — search results only
- Never clear/replace historical data — always APPEND
- Sheet columns have changed over time — always verify current structure before writing
- Drive: do NOT create subfolder-per-task. ONE folder per day, all files inside.
- **Brave API Rate Limiting**: The Brave Search API has aggressive rate limits. When making multiple consecutive search queries programmatically, introduce a small delay (e.g., `time.sleep(1)`) between each call to avoid `429 Too Many Requests` errors.
- Google Search, DuckDuckGo, Bing will block headless scraping. Use Brave API.
- **Brave API Rate Limiting**: The Brave Search API is sensitive to rapid requests. To avoid `429 Too Many Requests` errors when running multiple queries in a script, insert a pause between calls (e.g., `time.sleep(1)`).
- Many Italian studio websites are unreachable — verify with HTTP 200 before adding leads.
- Many Italian studio websites are unreachable — verify with HTTP 200 before adding leads.

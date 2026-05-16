---
name: aichain-lead-generation
description: Daily lead generation for Aichain Solutions — 10 verified Italian professionals (lawyers, accountants, labor consultants) with real data, LinkedIn profiles, and Google Drive/Sheets integration.
version: 1.0.0
---

# Aichain Lead Generation

Generate 10 REAL, verified leads daily for Aichain Solutions marketing campaigns.

## Target Profile
- **Categories**: Avvocati, Commercialisti, Consulenti del Lavoro
- **Geography**: Milano, Roma, Torino, Napoli, Bologna, Firenze
- **Firm size**: Small-to-medium studios (10-50 employees)
- **Focus**: Firms with high document volume

## Prerequisites
- Brave Search API Key: `BSAaT9y8bgpxo2pGTvL-hkDnMZXLFi6`
- Google Workspace auth configured (`~/.hermes/google_token.json`)
- Google Drive folder: `14iDBnIiY2TXzbT_CO1TeAOHKTiJotC69`
- Google Sheet: `1Yht2eN0N0RVSsYI7XEcB8HglEK9hQA_1SwtlgItiQsE` (Foglio1)

## Step 1: Search with Brave API

```python
import requests, json, gzip, urllib.parse, time, re

API_KEY = "BSAaT9y8bgpxo2pGTvL-hkDnMZXLFi6"

def brave_search(query):
    headers = {"Accept": "application/json", "Accept-Encoding": "gzip", "X-Subscription-Token": API_KEY}
    url = f"https://api.search.brave.com/res/v1/web/search?q={urllib.parse.quote(query)}&count=10"
    resp = requests.get(url, headers=headers, timeout=10)
    data = resp.content
    if data[:2] == b'\x1f\x8b':
        data = gzip.decompress(data)
    return json.loads(data).get('web', {}).get('results', [])
```

**Queries to use** (rotate cities):
- `"studio legale {citta} email contatti"`
- `"commercialista {citta} email contatti pec"`
- `"consulente del lavoro {citta} email contatti"`

Cities: Milano, Roma, Torino, Napoli, Bologna, Firenze

## Step 2: Extract Real Emails

Extract emails from Brave snippets (description + title):
```python
emails = re.findall(r'[\w.+-]+@[\w-]+\.[\w.-]+', desc + ' ' + title)
valid = [e for e in emails if not 'example' in e.lower()]
```

**Do NOT invent emails.** Only use those found in Brave results.

## Step 3: Verify Each Site

```python
resp = requests.get(f'https://{domain}', headers={'User-Agent': 'Mozilla/5.0'}, timeout=10, allow_redirects=True)
# Must be 200 OK or 301 redirect to exist
```

Discard sites that don't respond (404, timeout, SSL error, connection error).

## Step 4: Find LinkedIn Profiles

```python
li_results = brave_search(f'{nome_studio} {citta} site:linkedin.com')
linkedin_urls = [r['url'] for r in li_results if 'linkedin.com' in r['url'].lower()]
linkedin = linkedin_urls[0] if linkedin_urls else ''
```

## Step 5: Collect Verified Leads

Each lead must have:
- Nome (company/studio name)
- Citta
- Sito Web (verified domain)
- Email (from Brave, not invented)
- Tipologia: "Legale", "Commercialista", or "Consulente"
- LinkedIn URL (empty string if not found)
- Note (1-line summary)

## Step 6: Update Google Sheet

Append rows to the sheet (do NOT clear existing data):

```python
sheets_service = build('sheets', 'v4', credentials=creds)
sheets_service.spreadsheets().values().append(
    spreadsheetId="1Yht2eN0N0RVSsYI7XEcB8HglEK9hQA_1SwtlgItiQsE",
    range="Foglio1!A:Z",
    valueInputOption="USER_ENTERED",
    body={"values": leads_rows}  # Each row: [date, name, city, site, email, type, notes, linkedin]
).execute()
```

Sheet columns: `Data, Nome, Citta, Sito Web, Email, Tipologia, Note, LinkedIn`

## Step 7: Create lista-lead.md in Drive

```markdown
# Lista Lead Aichain Solutions

**Ultimo aggiornamento**: AAAA-MM-GG

> ✅ Tutti i lead sono verificati: sito attivo + email reale + LinkedIn

| Data | Nome | Città | Sito Web | Email | Tipologia | Note | LinkedIn |
|------|------|-------|----------|-------|-----------|------|----------|
| ...  | ...  | ...   | ...      | ...   | ...       | ...  | ...      |

**Totale**: 10 lead verificati oggi
```

Upload to: `Marketing/YYYY-MM-DD/lista-lead`
Use `drive upload` with `--parent` set to the day's folder ID.

## Rules

1. **NEVER invent data** — only real contacts from Brave Search results
2. **VERIFY each site** — HTTP 200/301 required
3. **APPEND only** — never delete previous day's leads
4. **Emails must be real** — from snippets or contact pages
5. **Target 10 leads minimum** — mix of lawyers, accountants, consultants
6. **Italian language only** in notes/descriptions

## Drive Folder Structure

**ONE daily folder**, no subfolders. Files have descriptive names:
```
Marketing/
  2026-05-12/
    audit-seo.md
    struttura-articolo-blog.md
    articolo-bozza.md
    report-social.md
    campagne-giornaliere.md
    lista-lead.md
    email-template-lead.md
```

Create with: `$GAPI drive create-folder "2026-05-12" --parent "14iDBnIiY2TXzbT_CO1TeAOHKTiJotC69"`

## Pitfalls

- DuckDuckGo blocks scraping (captcha/consent pages). Use Brave API.
- Google Search blocks headless browsers (captcha). Use Brave API.
- Bing has Cloudflare Turnstile CAPTCHA. Use Brave API.
- Many Italian studio websites are outdated or unreachable — verify before adding.
- Brave API has rate limits — add 1 second delay between calls.
- **NEVER invent leads.** The user will detect fake data and reject it. Every field must come from search results.
- Verify sites respond with 200 OK before adding to the list.

---
name: flight-search
category: travel
description: Search for flights using browser-based aggregators when direct airline sites fail. Uses Kiwi.com as primary source with fallback strategies.
---

## Flight Search Workflow

### Primary Approach: Kiwi.com
1. Navigate to: `https://www.kiwi.com/it/search/results/[origin]-italia/[destination]-italia/[YYYY-MM-DD]/[RETURN_YYYY-MM-DD]`
   - **CRITICAL**: Use SLASH-separated dates, NOT underscore. The underscore format (`2026-05-02_2026-05-04`) loads but may show wrong dates.
   - Example: `https://www.kiwi.com/it/search/results/milano-italia/catania-italia/2026-05-02/2026-05-04`
   - Use city codes (e.g., milano, catania, roma)
2. If fields are empty, fill them using `browser_type` on the "Da"/"A" textboxes
3. Look for date range buttons showing prices (e.g., "2 mag - 4 mag 156€") — this bar lets you compare prices across adjacent date combinations
4. Click the specific date range to get detailed results

### Extracting Results from Kiwi.com
Kiwi.com's DOM is complex and text snapshots often truncate flight details. Use `browser_console` to extract results reliably:
```javascript
const main = document.querySelector('main');
if (main) { main.innerText.split('\n').filter(l => l.trim()).join('\n'); }
```
This reveals departure/arrival times, airlines, prices, and direct/connection status for each flight card.

### Pitfalls (Kiwi.com specific):
- **Price discrepancy**: Per-leg prices shown in individual flight cards (e.g., "34€" for A+R segments) do NOT equal the date-range combined price (e.g., "156€" for "2 mag - 4 mag"). Kiwi.com adds Guarantee fees, booking fees, and markup at checkout. Always quote the date-range bar price for accurate A/R totals.
- If the results page shows wrong dates despite correct URL, navigate back to `https://www.kiwi.com/it/` and fill the search form fresh — this is more reliable than trying to fix the results page.
- The URL format is the most common point of failure — always use slash-separated dates.

### Fallback Sites (updated April 2026 — ALL hard-block automated browsers):
1. **Google Flights**: Consents to cookies but NEVER navigates past the consent page — hard block.
2. **Skyscanner**: Redirects to `captcha-v2/index.html` — hard block.
3. **Momondo**: Shows "Cos'è un bot?" page — hard block.
4. **ITA Airways**: Shows "BLOCKED / Security check" screen — hard block.
5. **Bing search**: Returns generic aggregator links, no flight data.

**Reality: Kiwi.com is the ONLY reliable automated source.** Use it exclusively. Do NOT waste turns on fallback sites — they all block headless browsers.

### Direct Airlines (for user manual lookup):
- **Ryanair**: Operates from Bergamo (BGY) and Malpensa (MXP). Can be searched programmatic (search form is reactive but doesn't auto-navigate to results).
- **EasyJet**: Malpensa (MXP). Site blocks bots too — user must check manually.
- **ITA Airways**: Linate (LIN). Site blocks bots too — user must check manually.
- **Wizz Air**: Bergamo (BGY) or Malpensa (MXP). Check manually.

### General Pitfalls:
- Kiwi.com prices include commissions and Guarantee fees — official airline sites may be cheaper for the same flights
- Italian city names: milano, catania, roma, napoli, venezia, bologna, firenze
- `vision_analyze` on Kiwi screenshots often fails (screenshot too large or format errors) — always use `browser_console` text extraction instead
- Ryanair's site search form is reactive but won't auto-submit on URL params alone — needs manual `browser_type` + click
### Best Practice:
- **Kiwi.com is the ONLY reliable automated flight search tool** — all fallbacks (Google Flights, Skyscanner, Momondo, airline sites) block headless browsers
- Use Kiwi's date-range bar for price comparison across adjacent dates
- Extract Kiwi results via `browser_console` — text snapshots are unreliable for flight cards
- For Milano↔Catania route: Ryanair from MXP is typically the cheapest option (from ~34€ A/R combined on Kiwi), but has limited morning schedules
- Per-leg prices in Kiwi flight cards (e.g., "34€") are misleading — always reference the date-range combined price for accurate A/R totals
- If you need specific morning/evening flights and Kiwi doesn't show them, tell the user to check EasyJet, ITA Airways, Wizz Air manually — all of these block bots
- `vision_analyze` on Kiwi screenshots often fails (screenshot too large or format errors) — always use `browser_console` for data extraction
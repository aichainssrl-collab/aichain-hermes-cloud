---
name: daily-marketing-autopilot
description: When the user wants to set up a recurring daily marketing agent (cron job) that handles SEO, content strategy, social media, competitor tracking, and lead generation every morning.
---

# Daily Marketing Autopilot Agent

Sets up a cron job that acts as a daily Marketing Lead, running every morning to produce an operational report. This agent combines SEO, content, social, competitor intelligence, and outbound sales into a single automated workflow.

## Configuration
- **Toolsets:** `["web", "browser", "file"]`
- **Skills to load:** `seo-audit`, `content-strategy`, `social-content`, `copywriting`, `cold-email`, `competitor-profiling`, `analytics-tracking`

## Setup Workflow

1. **Define Context:**
   Ask or extract from memory: Company Name, Website URL, Target Audience, Product/Service details, and specific Language/Copy rules (e.g., "Italiano puro, zero inglesismi").

2. **Create Cron Job:**
   ```bash
   cronjob action=create schedule="30 9 * * 1-5" name="Daily Marketing Lead"
   ```

3. **Prompt Template:**
   Use this structured prompt to ensure the agent delivers comprehensive, actionable output:

   ```text
   Sei il Marketing Lead di [COMPANY NAME] ([WEBSITE]). La tua missione quotidiana è produrre un report operativo completo.

   [INSERT COMPANY CONTEXT & COPY RULES HERE]

   TASK 1: ANALISI SEO SITO WEB
   - Naviga sul sito usando il browser.
   - Verifica crawlability e indicizzazione.
   - Produci un audit: problemi principali, priorità di fix, suggerimenti keyword.

   TASK 2: TEMA BLOG PER POSIZIONAMENTO #1
   - Identifica un tema con potenziale e bassa competizione.

   TASK 3: ANALISI SOCIAL & PERFORMANCE
   - Cerca le ultime performance del profilo e menzioni del brand.
   - Misura visibilità e trend. Suggerisci 2 azioni per aumentare la visibilità.

   TASK 4: ANALISI COMPETITOR + CAMPAGNE SOCIAL GIORNALIERE
   - Cerca le ultime attività di [COMPETITOR LIST].
   - Crea 2 campagne social giornaliere (LinkedIn, X).
   - Includi: copy pronto, immagine suggerita, hashtag, orario migliore.

   TASK 5: LEAD GENERATION + EMAIL DI CONVERSIONE
   - Cerca 5 potenziali clienti reali specifici (nome, città, sito web).
   - Per ciascuno, crea un'email di outreach personalizzata (Oggetto, Corpo max 150 parole, CTA chiara).
   ```

4. **Schedule:**
   Default to `30 9 * * 1-5` (Mon-Fri at 09:30). Adjust if requested.

## Key Considerations
- Ensure `web` and `browser` toolsets are enabled so the agent can navigate live sites and search for leads/competitors.
- If the target audience is non-English (e.g., Italian), explicitly enforce language rules in the prompt to prevent Anglisms.
- If the user wants to test immediately, run the job manually via `action: run` before relying on the schedule.

## Troubleshooting: Resource Exhaustion in Cron Jobs

**Problem: `RESOURCE_EXHAUSTED` errors in recurring cron jobs, even with concise prompts.**

When a cron job that utilizes complex AI reasoning (like Gemini) or multiple tools fails with a `RESOURCE_EXHAUSTED` error, it often indicates that the internal computational complexity or the execution time exceeds the allocated limits for the cron job environment. This is not necessarily a Gemini API rate limit, but rather a system-level timeout or resource ceiling for the agent's processing.

**Solutions:**

1.  **Drastic Simplification:** Reduce the number of tasks, the depth of analysis, and the required output for *each* task within the cron job. Focus on extremely concise summaries or single key insights per task. If this still fails, the problem is likely in the agent's internal reasoning steps, not just the final output length.
2.  **Modularization into Separate Cron Jobs:** Break down complex workflows (e.g., a daily marketing lead with 5+ tasks) into multiple, smaller cron jobs, each focusing on a single task. This reduces the computational load of any single job.
3.  **Intermediate Output to Files:** Configure the agent to write detailed reports to local files. The cron job's final step would then be to summarize these files and send a very short message (e.g., "Report available at /path/to/report.md") to Telegram or another delivery target. This offloads the heavy output to the filesystem.
4.  **Increase Cron Job Timeout (if possible):** If the Hermes environment allows, increasing the execution timeout for cron jobs can give the agent more time to complete its processing. (Note: This might not be directly configurable via agent tools).

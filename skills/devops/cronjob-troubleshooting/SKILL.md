---
name: cronjob-troubleshooting
category: devops
description: Troubleshoot issues with Hermes Agent cron jobs (failures, no output, errors).
---

# Cronjob Troubleshooting Guide

## Trigger Conditions
Use this skill when:
- A cron job fails to execute.
- A cron job executes but produces no output.
- The `cronjob` list shows `last_status: "error"` for a job.
- The user reports an issue with a scheduled task not completing or delivering results.

## Workflow

1.  **Inspect Cronjob Status:**
    - Use `default_api.cronjob(action="list")` to get an overview of all scheduled jobs.
    - Pay close attention to `last_status`, `last_delivery_error`, and `state` for the problematic job.

2.  **Identify Known Limitations:**
    - Inform the user that direct access to detailed execution logs for cron jobs is not available via the agent's current tools.
    - Explain that the `last_status` and `last_delivery_error` fields provide the primary diagnostic information available through the API.

3.  **Suggest Manual Server-Side Inspection:**
    - Advise the user to check the `hermes-agent` logs directly on the server where it's running for more detailed error messages. This is the most effective way to debug deeper issues.

4.  **Propose Job Modification/Disabling:**
    - If the issue persists and manual inspection isn't immediately feasible for the user, propose options such as:
        - Temporarily disabling the job (`default_api.cronjob(action="pause", job_id="<job_id>")`).
        - Modifying the job's prompt or skill to simplify it and isolate the problem (`default_api.cronjob(action="update", job_id="<job_id>", prompt="<new_prompt>")`).
        - If it's a skill-based job, suggesting a review or patch of the associated skill.

## Pitfalls & Considerations

- **Limited Visibility:** The agent's tools provide high-level status but lack deep diagnostic capabilities for cron job execution.
- **Dependency Issues:** Ensure all tools and dependencies required by the cron job's prompt/skill are correctly installed and configured on the server.
- **Environment Variables:** If the cron job relies on environment variables, verify they are correctly set in the environment where `hermes-agent` runs.
- **Skill-Specific Errors:** If the cron job uses a specific skill, the error might originate within that skill's logic. Review the skill's content if possible.

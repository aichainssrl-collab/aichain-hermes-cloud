---
name: adversarial-code-review
description: Adversarial review for critical decisions — CLAIM → EXTRACT → DOUBT → RECONCILE. Use when stakes are high (production, security, irreversible changes) or working in unfamiliar codebases.
version: 1.0.0
author: Hermes Agent (inspired by addyosmani/agent-skills/doubt-driven-development)
license: MIT
metadata:
  hermes:
    tags: [code-review, adversarial, verification, security, quality]
    related_skills: [github-code-review, requesting-code-review, systematic-debugging]
---

# Adversarial Code Review

## Overview

When the stakes are high, a fresh skeptical eye prevents costly mistakes. This skill forces an adversarial review of every non-trivial decision — treating confidence as a liability, not an asset.

**Core principle:** Fresh context + zero bias = better catch rate than author review.

## When to Use

Use when **any** of these apply:
- Changes touch production systems, auth, payments, or security
- Working in an unfamiliar codebase
- A confident output needs verification before shipping
- The change is irreversible or hard to rollback
- User says "double check this" or "are you sure?"
- After completing a complex refactor or migration

**vs. github-code-review:** That skill reviews PRs with standard checklist. This skill is adversarial — it actively tries to prove the code wrong.

**vs. requesting-code-review:** That pipeline verifies before commit. This skill is for in-flight major decisions that need escalation-grade scrutiny.

## The Process: CLAIM → EXTRACT → DOUBT → RECONCILE

### Phase 1: CLAIM

List every non-trivial decision in the code:
- API contracts and data formats
- Assumptions about external dependencies
- Error handling decisions
- Performance assumptions
- Security assumptions

Write them down explicitly. No implicit knowledge.

### Phase 2: EXTRACT

For each claim, extract the supporting evidence:
- Is there documentation confirming this?
- Is there a test proving this behavior?
- Is this based on the author's assumption or verified fact?

Flag as: **VERIFIED** (has test/doc) or **ASSUMED** (author belief).

### Phase 3: DOUBT

Take the ASSUMED claims and try to prove them wrong:
- What if the assumption is incorrect?
- What edge cases does this not cover?
- What happens under load/concurrency/bad input?
- Would someone with zero context understand this?

**This is where a fresh subagent excels** — it has no sunk-cost bias.

### Phase 4: RECONCILE

For each doubt:
- If the doubt is valid → fix the code or add verification
- If the doubt is unfounded → document why (for future reviewers)
- If uncertain → STOP and ask the user

**If 2+ doubts are valid: consider escalating to the user before proceeding.**

## Anti-Rationalization Table

| Excuse | Reality |
|--------|---------|
| "I already verified this" | Author verification ≠ independent verification. |
| "It's just a small change" | Small changes to critical paths have outsized risk. |
| "We'll catch it in QA" | Prevention is 10× cheaper than detection. |
| "The user doesn't care" | The user doesn't know what they don't know. Protect them. |
| "This is blocking, rush it" | Rushing critical code causes incidents. Better slow than sorry. |
| "I wrote it, I can review it" | Self-review misses 60% of issues. Fresh context catches what you miss. |

## Subagent Workflow

For adversarial review, spawn a dedicated subagent with zero implementer context:

```python
delegate_task(
    goal="""You are a skeptical reviewer with zero context about how this code 
was written. Your job is to find flaws the author missed.

PHASE 1 — CLAIM: List every non-trivial assumption in this code.
PHASE 2 — CLASSIFY: Each claim is VERIFIED (has test/doc) or ASSUMED (author belief).
PHASE 3 — DOUBT: Attack every ASSUMED claim. What if it's wrong?
PHASE 4 — ESCALATE: Flag anything that could cause data loss, security breach, 
or production outage.

Be adversarial. If something seems too good to be true, investigate.

<code_changes>
[INSERT DIFF OR FILE CONTENT]
</code_changes>

Return findings as:
- VERIFIED claims: [list]
- ASSUMED claims with doubts: [claim + doubt + risk level]
- RECOMMENDATION: Proceed / Needs fixes / Stop and escalate
""",
    context="Adversarial review — assume nothing is correct.",
    toolsets=['file']
)
```

## Red Flags — STOP Immediately

- Reviewer finds a security vulnerability → fix before ANY other work
- Reviewer identifies data loss risk → rollback or freeze
- 3+ valid doubts found → escalate to user, don't proceed alone
- Reviewer can't understand the code → it's too complex, simplify first

## Output Format

```markdown
## Adversarial Review Verdict

### VERIFIED Claims (N)
- Uses parameterized queries ✅ (line 45, backed by test line 23)

### ASSUMED Claims with Doubts (N)
- Assumes API always returns 200 ❌ — what if 429/503?
- Assumes user input is sanitized ❌ — no validation on line 12

### RECOMMENDATION
[Proceed / Needs fixes / STOP — X issues must be resolved first]
```

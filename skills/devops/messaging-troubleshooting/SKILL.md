---
name: messaging-troubleshooting
description: Troubleshooting issues related to sending messages via different platforms (e.g., Telegram).
---

# Messaging Troubleshooting

This skill provides a structured protocol for diagnosing and resolving issues when sending messages.

## Core Principle: Verify, Don't Assume

As per the Boss's core directive: Always verify configurations before acting, especially when a command has failed. Do not trust memory over live system data.

## Universal Troubleshooting Step

**1. VERIFY THE TARGET (MANDATORY FIRST STEP)**
Before any other step, verify the correct destination address. Do **NOT** rely on memory or hardcoded IDs, which can be stale or incorrect.

-   **Action**: Use the `send_message(action='list')` tool call.
-   **Expected Output**: A definitive list of currently configured and valid targets.
-   **Execution**: Use the exact string provided by the tool (e.g., `telegram:Aichain Solutions (dm)`). This is the most common point of failure.

---

## Scenario: Telegram "Forbidden" Error

**Problem:** `send_message` fails with `Forbidden: the bot can't send messages to the bot`.

**Root Cause:** This error occurs when the `target` ID is the agent's own bot ID. It is a definitive sign of a misconfiguration or using a bad ID from memory.

**Resolution:**
1.  Execute the **Universal Troubleshooting Step** above (`send_message(action='list')`).
2.  Use the correct named target from the output.
3.  Remove the incorrect numeric ID from memory or the Wiki to prevent recurrence.

---

## Scenario: Network Errors

**Problem:** `send_message` fails with a network-related error like "Temporary failure in name resolution".

**Root Cause:** This indicates a DNS resolution failure, preventing communication with external APIs.

**Resolution:**
1.  **Check basic internet connectivity**: `ping -c 3 8.8.8.8`
2.  **Verify DNS resolution**: `dig api.telegram.org`. If this fails, there is a system-level network problem.

---

## Pitfalls & Key Lessons

-   **False Positives**: The `send_message` tool can report `success: true` even if the message or file was not delivered. This is a critical point of failure.
    -   **Mitigation**: After sending a critical file, **always** ask the user for explicit confirmation: *"I've sent the file. Can you please confirm you've received it?"*. Do not consider the task complete until confirmed.

-   **Stale IDs in Memory**: Storing numeric chat IDs in long-term memory is an anti-pattern. They are unreliable.
    -   **Mitigation**: The correct "memory" is to store the *procedure* for finding the right ID. That procedure is always to use `send_message(action='list')`.

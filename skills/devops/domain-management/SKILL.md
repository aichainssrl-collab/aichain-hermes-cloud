---
name: domain-management
displayName: "Domain Management & WHOIS Lookup"
description: >
  Check domain name availability, retrieve registration details, and
  troubleshoot `whois` command issues. Use when asked to check, buy, or
  investigate a domain name.
tags: [domain, whois, dns, registration]
---

# Domain Management & WHOIS Lookup

This skill provides a workflow for investigating the registration status of a domain name using the `whois` command-line tool.

## When to use

Use this skill when the user asks to check if a domain is available, wants to buy a domain, or needs information about an existing domain's registration details.

## Workflow

1.  **Check Availability with `whois`**: The primary tool for checking a domain's status is `whois`.

    ```bash
    whois example.com
    ```

2.  **Analyze the Output**:
    *   **Domain is taken**: If the output contains fields like `Creation Date`, `Registrar`, and `Name Server`, the domain is registered. Relay this information to the user, including the creation and expiration dates.
    *   **Domain is available**: If the output indicates "No match for domain" or a similar message, the domain is likely available for registration.

3.  **Propose Next Steps (if taken)**:
    *   **Follow the Acquisition Workflow**: If the domain is taken, the next step is a strategic attempt at acquisition. Do not simply suggest brainstorming alternatives unless the user wants to give up on the primary domain.

## Acquisition Workflow for Taken Domains

If a domain is already registered, waiting for it to expire is **not** a viable strategy. Due to automated "drop-catching" services that snipe expiring domains, the only reliable method is to contact the owner and make a purchase offer.

1.  **Initial Website Recon**: Visit the domain in a browser. Is it a developed site, a parked page, a "for sale" page, or a blank/default page? This gives clues about the owner's intent. A "for sale" page is the best-case scenario.

2.  **Find a Contact Point**:
    *   WHOIS data is almost always private, so direct owner contact information is rare.
    *   **Primary Strategy**: Go through the registrar identified in the `whois` lookup.
    *   **Last-Resort Strategy**: If the registrar's website has no clear channel for purchase inquiries, use the "Registrar Abuse Contact Email" from the `whois` record. This is a reliable way to reach a human at the registrar who can forward your request.

3.  **Draft and Send a Formal Inquiry**:
    *   Write a professional email in English to the registrar.
    *   Clearly state your intent is a commercial inquiry, not an abuse report.
    *   Politely ask for them to forward your interest to the domain owner.

### Email Template for Contacting a Registrar

Use this template when writing to the abuse contact or a general support address.

```
Subject: Inquiry regarding the domain [Domain Name]

Dear [Registrar Name] Team,

I am writing to you today not to report abuse, but to make a formal inquiry regarding a domain registered through your service. I was unable to find a more appropriate contact channel for this type of request.

Our company, [Your Company Name], is very interested in acquiring the domain name **[Domain Name]**.

We would be very grateful if you could forward this message to the current owner of the domain so that we can open a channel of communication and discuss a possible purchase.

Thank you for your time and assistance in this matter.

Best regards,

[Your Name/Company Name]
[Your Website]
```

## Pitfalls & Solutions

### The Expiration Myth (A Critical Pitfall)

Never advise a user to simply wait for a domain to expire.

*   **Grace/Redemption Period**: The original owner has roughly **65-80 days** after expiration to reclaim the domain. It does not become available immediately.
*   **Drop-Catching Services**: High-value domains are monitored by automated services that register them the millisecond they become publicly available. Manual registration is guaranteed to fail. The only winning strategy is proactive contact and negotiation.

## Pitfalls & Solutions

### `whois: command not found`

This is a common error on fresh systems where the `whois` client is not installed by default.

*   **Symptom**: The terminal returns an error like `/bin/bash: line 1: whois: command not found` with exit code 127.
*   **Solution**: On Debian-based systems (like Ubuntu), you can install it using `apt-get`. Always run an update first.

    ```bash
    sudo apt-get update && sudo apt-get install -y whois
    ```
*   **Verification**: After installation, re-run the `whois` command on the domain. It should now succeed.

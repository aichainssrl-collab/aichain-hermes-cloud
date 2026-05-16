---
name: gcp-instance-management
description: "Create, manage, and analyze costs for Google Cloud Platform (GCP) Compute Engine virtual machines. Covers IaC with Terraform, cost estimation, and instance lifecycle."
version: 1.0.0
---

# GCP Compute Engine Instance Management

This skill provides the knowledge and tools to manage Google Cloud Platform (GCP) virtual machines (VMs), with a focus on Infrastructure as Code (IaC) using Terraform.

## When to Use This Skill
- When the user asks to create a new server or virtual machine on Google Cloud.
- When analyzing the cost of hosting an application on GCP.
- When deploying a project to a new or existing GCP VM.
- When asked to "migrate to GCP" or "deploy on Google Cloud".

## Core Workflow: Deploying a New VM

The standard procedure for deploying a new VM is to use Terraform. This ensures the infrastructure is documented, version-controlled, and repeatable.

1.  **Analyze Requirements**: Determine the necessary resources (CPU, RAM, Disk, OS, GPU if needed).
2.  **Estimate Costs**: Use the GCP Pricing Calculator or internal knowledge to provide a clear cost estimate. Always include a recommendation for cost optimization (e.g., Spot VMs for non-critical workloads, Committed Use Discounts for 24/7 services).
3.  **Write Terraform Code**: Create a `.tf` file defining the instance, disk, network, and any startup scripts.
4.  **Plan and Apply**: Use `terraform plan` to validate the changes and `terraform apply` to provision the infrastructure.

## Key Knowledge Assets (in LLM Wiki)

This skill relies on and contributes to our shared knowledge base. Key documents to consult/update:
- `[[queries/costi-gpu-su-gcp.md]]`: Our reference for GPU pricing.
- `[[queries/costi-migrazione-buddy-su-gcp.md]]`: The cost-benefit analysis for hosting the main agent.
- `[[comparisons/vm-vs-cloud-run-per-buddy.md]]`: Strategic decision record for choosing VMs over serverless for stateful agents.

## Starter Template for a Standard VM

A robust starter template for a general-purpose VM is available in this skill's `templates/` directory.

**Path**: `templates/standard-vm-main.tf`

This template defines an `e2-standard-2` machine with a 100GB SSD and a startup script, which is the standard configuration for our agents.

## Pitfalls
- **Stateful vs. Stateless**: Do not propose Cloud Run for stateful applications like the main Hermes Agent. A VM is the correct choice. This is documented in `[[comparisons/vm-vs-cloud-run-per-buddy.md]]`.
- **Cost Optimization**: Never propose "on-demand" pricing as the final solution for a long-running instance. Always analyze and recommend **Committed Use Discounts** or **Spot VMs** as appropriate.
- **Authentication**: Terraform requires GCP authentication. Ensure this is configured (via `gcloud auth application-default login` for local testing, or service account keys for CI/CD) before running `plan` or `apply`.

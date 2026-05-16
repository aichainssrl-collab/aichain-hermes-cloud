---
name: llm-api-pricing
description: LLM API pricing landscape and model recommendations for May 2026 — best value models for different use cases (cost optimization, quality maximization).
version: 1.0.0
---

# LLM API Pricing — May 2026 Reference

Based on CostGoat (322+ models, updated May 12, 2026). Quality scores 0-100 per Theozard benchmarks. Value = quality per dollar of output cost.

## Quick Pick: Best Models by Use Case

| Use Case | Model | Quality | $/1M in | $/1M out | Value Score | Context |
|----------|-------|:------:|--------:|---------:|:-----------:|---------|
| **Budget / High Volume** | Xiaomi MiMo-V2-Flash | 77 | $0.10 | $0.30 | **257** | 262K |
| **Budget / High Volume** | DeepSeek V3.2 | 79 | $0.25 | $0.38 | **209** | 131K |
| **Balanced** | Z.ai GLM 5 | 94 | $0.60 | $1.92 | **49** | 203K |
| **Balanced** | Moonshot Kimi K2.5 | 89 | $0.40 | $1.98 | **45** | 262K |
| **Long Context** | xAI Grok 4.1 Fast | 74 | $0.20 | $0.50 | **148** | 2.0M |
| **Premium** | Claude Opus 4.6 | 100 | $5.00 | $25.00 | **4** | 1.0M |
| **Premium** | GPT-5.2 / Chat | 96 | $1.75 | $14.00 | **7** | 400K |

## Full Comparison (Top Models by Value)

| Rank | Model | Quality | In/1M | Out/1M | Value | Context |
|------|-------|--------:|------:|-------:|------:|---------|
| 1 | **Xiaomi MiMo-V2-Flash** | 77 | $0.10 | $0.30 | 257 | 262K |
| 2 | **DeepSeek V3.2** | 79 | $0.25 | $0.38 | 209 | 131K |
| 3 | **xAI Grok 4.1 Fast** | 74 | $0.20 | $0.50 | 148 | 2.0M |
| 4 | **MiniMax M2.1** | 75 | $0.29 | $0.95 | 79 | 197K |
| 5 | **MiniMax M2.5** | 79 | $0.15 | $1.15 | 69 | 197K |
| 6 | **Z.ai GLM 5** | 94 | $0.60 | $1.92 | 49 | 203K |
| 7 | **Moonshot Kimi K2.5** | 89 | $0.40 | $1.98 | 45 | 262K |
| 8 | **Z.ai GLM 4.7** | 79 | $0.40 | $1.75 | 45 | 203K |
| 9 | **GPT-5 Mini** | 77 | $0.25 | $2.00 | 39 | 400K |
| 10 | **Kimi K2 Thinking** | 77 | $0.60 | $2.50 | 31 | 262K |
| 11 | **Gemini 3 Flash** | 87 | $0.50 | $3.00 | 29 | 1.0M |

### Premium Tier (Quality ≥ 90)

| Model | Quality | In/1M | Out/1M | Value | Context |
|-------|--------:|------:|-------:|------:|---------|
| Claude Opus 4.6 | 100 | $5.00 | $25.00 | 4 | 1.0M |
| GPT-5.2 / GPT-5.2 Chat | 96 | $1.75 | $14.00 | 7 | 128K/400K |
| Claude Opus 4.5 | 94 | $5.00 | $25.00 | 4 | 200K |
| GPT-5.2-Codex | 92 | $1.75 | $14.00 | 7 | 400K |
| GPT-5.1 | 91 | $1.25 | $10.00 | 9 | 400K |
| GLM 5 | 94 | $0.60 | $1.92 | 49 | 203K |

### Cheapest Models

| Model | Quality | In/1M | Out/1M |
|-------|--------:|------:|-------:|
| Gemini 1.5 Flash | ~80 | $0.075 | $0.30 |
| GPT-4.1 Nano | ~70 | $0.10 | $0.40 |
| Xiaomi MiMo V2 Flash | 77 | $0.10 | $0.30 |
| DeepSeek V3.2 | 79 | $0.25 | $0.38 |

## Recommendations for Agent Use

- **Agent main model (reasoning/tools)**: GLM 5 (Quality 94, $0.60/$1.92) or Kimi K2.5 (Quality 89, $0.40/$1.98)
- **Agent cheap model (simple tasks)**: DeepSeek V3.2 (Quality 79, $0.25/$0.38)
- **High-stakes analysis**: Claude Opus 4.6 or GPT-5.2
- **Bulk content generation**: Xiaomi MiMo-V2-Flash or DeepSeek V3.2
- **Coding**: GPT-5.2-Codex (Quality 92, $1.75/$14.00)
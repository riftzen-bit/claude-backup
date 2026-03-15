---
name: routing-stats
description: Show model routing statistics and cost savings for the current session. Analyzes which models were used and estimates savings vs all-Opus baseline.
---

# Routing Statistics Report

Analyze the current conversation and generate a routing efficiency report.

## Step 1: Scan Conversation

Look through the conversation for:
- All Agent tool calls with `model` parameter
- All `[Route]` log entries
- Direct tool usage (Read, Grep, Glob, Edit, Write, Bash) by main Opus session

## Step 2: Categorize Usage

Count and categorize:
- Total subagent dispatches by model (haiku / sonnet / opus / gemini)
- Tasks handled directly by Opus (main session)
- Escalations (haiku→sonnet, sonnet→opus, gemini→opus)
- Failed dispatches

## Step 3: Estimate Costs

Calculate using these rates (per million tokens):

| Model | Input | Output | Avg subtask cost |
|-------|-------|--------|------------------|
| Haiku | $0.25 | $1.25 | ~$0.002 |
| Sonnet | $3.00 | $15.00 | ~$0.021 |
| Opus | $15.00 | $75.00 | ~$0.105 |
| Gemini | Google AI billing | — | see Google AI pricing |

For each dispatch:
- Estimate tokens based on prompt length and response length
- Calculate actual cost with routed model
- Calculate hypothetical cost if Opus handled everything

## Step 4: Output Report

```
╔══════════════════════════════════════════════╗
║         MODEL ROUTING STATS                  ║
╠══════════════════════════════════════════════╣
║ Session dispatches:                          ║
║   Haiku:  NN tasks  ($X.XX)                  ║
║   Sonnet: NN tasks  ($X.XX)                  ║
║   Opus:   NN tasks  ($X.XX)                  ║
║   Gemini: NN tasks  (Google AI billing)      ║
║   Direct: NN tasks  (main session)           ║
║                                              ║
║ Escalations: NN                              ║
║ Failed:      NN                              ║
║                                              ║
║ Cost with routing:    $X.XX                  ║
║ Cost all-Opus:        $Y.YY                  ║
║ Savings:              $Z.ZZ (NN%)            ║
╚══════════════════════════════════════════════╝
```

## Step 5: Recommendations

Based on the data, suggest:
- Tasks that were over-routed (sent to expensive model unnecessarily)
- Tasks that were under-routed (failed and needed escalation)
- Patterns for future routing optimization

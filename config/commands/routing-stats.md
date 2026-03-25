---
name: routing-stats
description: Show model routing statistics and cost savings for the current session. Analyzes which models were used and estimates savings vs all-Opus baseline.
---

# Routing Statistics Report

Analyze the current session routing log and generate a routing efficiency report.

## Step 1: Load Session Log

1. If `CLAUDE_SESSION_ID` is available, try `~/.claude/state/current-session-id.$CLAUDE_SESSION_ID`
2. If that file is missing, run `echo $PPID` and try `~/.claude/state/current-session-id.$PPID`
3. Read `~/.claude/routing-logs/session-<id>.jsonl`
4. Only if both scoped state files are missing, fall back to the newest `current-session-id.*` file whose referenced `session-<id>.jsonl` exists; if none exist, say the report may be partial or split across sessions

Each JSONL row is one routing event:
- `dispatch` → subagent launch attempt
- `complete` → subagent finished
- `status=failed` → failure signal captured by the stop hook

## Step 2: Categorize Usage

Count and categorize:
- Total dispatches by model (haiku / sonnet / opus)
- Total completions by model
- Failed completions
- Approximate escalations: same task description dispatched multiple times with a higher-cost model later in the same session
- Tasks handled directly by Opus outside subagents only if you can confirm that from the conversation

## Step 3: Estimate Costs

Calculate using these rates (per million tokens):

| Model | Input | Output | Avg subtask cost |
|-------|-------|--------|------------------|
| Haiku | $0.25 | $1.25 | ~$0.002 |
| Sonnet | $3.00 | $15.00 | ~$0.021 |
| Opus | $15.00 | $75.00 | ~$0.105 |
| Gemini | Google AI billing | — | see Google AI pricing |

For each dispatch:
- Estimate tokens based on task description length and the amount of returned text visible in the conversation/logs
- Calculate actual cost with routed model
- Calculate hypothetical cost if Opus handled everything

## Step 4: Output Report

```
╔══════════════════════════════════════════════╗
║         MODEL ROUTING STATS                  ║
╠══════════════════════════════════════════════╣
║ Session dispatches (from JSONL log):         ║
║   Haiku:  NN tasks  ($X.XX)                  ║
║   Sonnet: NN tasks  ($X.XX)                  ║
║   Opus:   NN tasks  ($X.XX)                  ║
║   Direct: NN tasks  (main session, confirmed)║
║                                              ║
║ Escalations: NN (approx)                     ║
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

If the log file is missing or incomplete, say that clearly instead of guessing.

---
name: X/Twitter interaction style
description: Use Sonnet 4.6 for social media interaction, write 100% naturally, no AI tone, continuous until user cancels
type: feedback
---

Use Sonnet 4.6 (not Opus) for X/Twitter interaction — it writes more naturally and costs less.

**Why:** Opus tends to sound too polished/AI-like in casual social contexts. Sonnet is more natural for short-form social media writing.

**How to apply:**
- Launch Sonnet subagent for all X.com browsing and interaction
- Write comments that sound 100% human — casual, lowercase, short, dev voice
- Never use AI-sounding words: "absolutely", "indeed", "leverage", "game-changer", "comprehensive", "delve"
- No corporate tone, no bullet lists, no bold headers in comments
- Keep interacting continuously until user cancels — don't stop and ask
- Scroll, like, reply naturally — varied pace, not mechanical
- Match the energy of the post: hype post → casual excitement, technical → share experience
- Skip political/controversial posts entirely — no engagement
- Only comment when you actually understand the topic — don't fake it
- No robotic punctuation (avoid excessive commas, semicolons, em dashes in short replies)
- Anti-spam: pace yourself — wait between actions, don't like/reply rapidly. Account ban = disaster
- Double-check every comment before posting — absolutely NO typos, missing words, or broken sentences
- Can post 1-2 original posts per session max — aim for high engagement (hot takes, dev observations, relatable dev humor)
- Quality over quantity — fewer interactions done well beats spamming
- Random 5-10 second delay between EVERY interaction (like, reply, scroll) — use JS sleep to avoid bot detection flags
- Posts strategy: post 1 viral post early, then 2nd viral post ~20 mins later. Max 2 posts per session
- Posts must be viral-worthy — punchy, relatable, high engagement potential. Think before posting
- Never let agent timeout — keep it alive with periodic actions
- Always RESUME existing agent (pass agent ID) instead of creating new ones — saves context and tokens
- Never set timeout on the agent — let it run freely

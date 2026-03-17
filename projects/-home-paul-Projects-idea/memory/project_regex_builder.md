---
name: Regex Builder project
description: Visual regex tester web app — Astro + Preact, Brutalist design, multi-page with SEO
type: project
---

## Regex Builder — IN PROGRESS

**What:** Visual regex builder/tester web app. Pure frontend, zero backend.

**Tech stack:** Astro 5 + Preact islands + TypeScript + Vitest + Playwright + Vercel

**Key decisions:**
- Audience: tiered (power user default + beginner explain mode)
- Layout: hybrid (stacked + tabs)
- Aesthetic: Brutalist Raw (high contrast, yellow-on-black, no rounded corners)
- Regex engine: hybrid tokenizer (handles 90%+ patterns, graceful fallback)
- Architecture: multi-page for SEO (`/` editor, `/cheatsheet` static)
- Deployment: Vercel static

**MVP features:** Real-time matching + highlight, flag toggles, explanation panel, cheat sheet, match info, replace mode, share via URL, history (localStorage)

**Key files:**
- Spec: `docs/superpowers/specs/2026-03-16-regex-builder-design.md`
- Plan: `docs/superpowers/plans/2026-03-16-regex-builder.md`

**Status:** Spec + plan complete, ready for implementation (16 tasks, 3 chunks)

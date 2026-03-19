---
name: glow-dot-is-ai
description: Glowing dot effects (pulsing circles with radial glow/bloom) look AI-generated — avoid this pattern in frontend design
type: feedback
created: 2026-03-15
---

Glow dots — small circles with radial gradient glow, bloom, or pulse effects — are an AI design tell. These appear as decorative elements, status indicators with excessive glow, or floating orbs with blur/bloom.

**Why:** User flagged glow dot effects as a recognizable AI pattern. AI tools frequently add glowing circles as decorative elements.

**How to apply:** Avoid any decorative dot/circle with `box-shadow` glow, radial gradient bloom, or pulse animations. Plain dots without glow are fine. Status indicators without excessive glow are fine. Custom cursors (dot + ring) are fine. The issue is specifically the "magical glowing orb" aesthetic.

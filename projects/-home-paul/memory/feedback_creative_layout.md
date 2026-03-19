---
name: creative-layout-not-template
description: AI always uses template layouts (centered, grid, bento) instead of creating unique custom layouts like human designers do
type: feedback
created: 2026-03-17
---

AI always falls back to pre-defined layout patterns (centered content, bento grids, sidebar + main, newspaper columns) instead of inventing custom layouts unique to each project. Human designers create layouts that don't fit into any named pattern.

**Why:** User observed that even with the anti-ai-design skill, Claude picks from a list of named layout patterns. This is itself an AI tell — real designers don't think "I'll use Bento Intentional layout #3". They design a layout that serves the specific content, which may not match any template.

**How to apply:**
1. Stop picking from a menu of named layouts. Instead, analyze the SPECIFIC CONTENT and design a layout that serves it uniquely.
2. Human designers use: overlapping elements, content that bleeds across "sections", asymmetric spacing that responds to content weight, elements placed where they NEED to be rather than on a grid.
3. Grid alignment issues (cells stretching to match row height) are a CSS Grid tell — use explicit row heights, or mix grid with absolute positioning, or avoid grid entirely for some sections.
4. The layout should look like someone sat down and arranged elements by hand, not like they selected a template.

---
name: left-alignment-and-verify-before-done
description: Claude always left-aligns content leaving right side empty, and doesn't verify visual output before claiming done
type: feedback
created: 2026-03-16
---

Claude consistently left-aligns main content without using the full available width, leaving the right side of the screen empty/abandoned. This looks unfinished and AI-generated.

Also: Claude claims "done" and runs verification checklists without actually verifying the visual output. The checklist passes on paper but fails visually.

**Why:** User noticed across multiple iterations that content hugs the left side, right side is void. Combined with the fact that Claude marks verification items as [x] without actually seeing the rendered result.

**How to apply:**
1. When building layouts, ensure content fills available width meaningfully. If using max-width, center the content or use the remaining space purposefully (side notes, decorative elements, secondary info).
2. Never claim done without opening/viewing the actual rendered output if possible. If you can't view it, be honest that visual verification is pending.
3. Specifically watch for: sidebar layouts where main content is narrow + left-aligned = right void. Full-width layouts where max-width creates dead space on one side.

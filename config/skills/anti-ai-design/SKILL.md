---
name: anti-ai-design
description: >
  Enforce distinctive, non-AI-looking design for any UI task across ALL stacks.
  Auto-triggers on: build UI, page, component, layout, web app, design, style, CSS,
  animation, theme, landing page, dashboard, form, navigation, frontend, website,
  interface, responsive, mobile, header, footer, sidebar, hero, card, button, modal,
  Tauri, Electron, React Native, Flutter, SwiftUI, desktop app, mobile app, native app.
---

# Anti-AI Design System

Build UI that does NOT look AI-generated. Read `reference.md` in this skill's directory for full font pools, color palettes, platform details, and CSS techniques.

## Process

1. Check blacklist — if instinct matches, STOP
2. Pick font + color from pools in `reference.md` (layout must be INVENTED per content, not from a template)
3. Design layout from CONTENT NEEDS — place elements where they need to be, not on a named grid
4. Verify with checklist before output

## BLACKLIST — Never Do These

**Typography**: Inter, Roboto, Arial, Helvetica, system-ui, Space Grotesk, Open Sans, Lato, Montserrat, Poppins, Raleway, Nunito Sans, any top-10 Google Font. (Native body text exempt)

**Color**: indigo/violet/purple as primary. Blue→purple or purple→pink gradients. slate-950 bg + purple accent. Raw Tailwind defaults. Teal/cyan secondary on dark bg.

**Layout**: Hero→3-card grid→testimonials→pricing→footer flow. Symmetric 50/50 splits. Equal-weight grids.

**Components**: shadcn card defaults. Ghost+filled CTA pair. Pill badges neutral gray. Logo-left/links-center/CTA-right navbar.

**Effects**: Glow dots/orbs/bloom. Floating blurred circles. Gradient orb backgrounds. Neon glow text. Pulsing glow animations.

**Icons**: Lucide defaults (Sparkles, Zap, Shield, Rocket, CheckCircle, Star, ArrowRight) used generically.

**Animation**: Solo fade-in on scroll. Solo slide-up on scroll. `hover:scale-105 transition-all duration-300`. Any animation without deliberate timing.

**Spacing**: Uniform padding/gap everywhere. Symmetric section padding. No negative space variation.

**Structure** (critical — AI's biggest tells):
- Empty hero voids (60%+ empty space)
- Numbered features (01, 02, 03)
- Eyebrow text on every section (max 1 per page)
- Centered "Ready to X?" CTA section
- "Short. Punchy. Period." headlines
- Single italic serif testimonial + uppercase cite
- Floating decorative SVG in voids
- Left-hugging content with right void
- Repeating identical structure 5+ times
- Template layouts (naming a pattern = AI)
- CSS Grid stretch artifacts

## LAYOUT — Invent, Don't Select

Do NOT pick from named layouts. Design from content:
1. List all content → prioritize → place where it NEEDS to be
2. Mix CSS Grid + flexbox + block + position:absolute — different technique per section
3. Create tension: one thing unexpectedly large, one small, one breaking alignment, one overlapping
4. Break the grid: negative margins, overlapping sections, bleeds, tilts, float wrapping
5. Fix stretch: `align-self: start`, explicit heights, avoid grid where inappropriate
6. Every project = unique spatial logic

## VERIFICATION

```
[ ] Font not blacklisted? Display + body contrasting?
[ ] Color not purple/indigo? Palette applied?
[ ] No glow/orbs/bloom?
[ ] No hero void, numbered features, eyebrow spam, centered CTA, punchy headlines?
[ ] Layout invented from content — not a named template?
[ ] At least 1 grid-breaking element (overlap, offset, bleed)?
[ ] No grid stretch artifacts?
[ ] Content fills width — no dead void on either side?
[ ] Feature presentation varied — not same format repeated?
[ ] Spacing varied across sections?
[ ] At least 1 unforgettable element?
[ ] Accessibility: contrast, semantic HTML, keyboard, focus, motion preference?
[ ] Responsive + dark mode?
[ ] VISUAL VERIFY: I cannot see the output — be honest about pending visual check
```

## RULES

- Brand guidelines override pools but blacklist still applies to non-branded elements
- Vary font+color+layout across projects — never repeat same combo
- Cross-pollinate: Authority font + Playful color = unexpected memorability

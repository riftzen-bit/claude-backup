# Anti-AI Design Reference

Read this file when you need font pools, color palettes, platform details, animation recipes, or CSS techniques. Not loaded by default — read on demand.

## Font Pools

Pick display font from mood. Pair with contrasting body font. Never same font for both.

**Authority** (fintech, enterprise, legal): Fraunces, Playfair Display, Cormorant Garamond, DM Serif Display, Libre Baskerville, Instrument Serif, Young Serif
**Playful** (consumer, social, games): Bricolage Grotesque, Outfit, Sora, Lexend, Quicksand, Fredoka, Baloo 2
**Editorial** (blogs, magazines, news): Source Serif 4, Lora, Merriweather, Newsreader, Literata, Spectral, Crimson Pro
**Technical** (dev tools, dashboards, CLI): JetBrains Mono, IBM Plex Mono, Fira Code, Space Mono, Red Hat Mono, Geist Mono, Victor Mono
**Organic** (wellness, food, nature): Nunito, Atkinson Hyperlegible, Cabin, Karla, Albert Sans, General Sans, Wotfard
**Luxury** (fashion, real estate, premium): Italiana, Tenor Sans, Cormorant, Bodoni Moda, Gilda Display, Marcellus, Poiret One

## Color Seed Palettes

Pick ONE. Derive full theme. Dark mode: invert dominant/neutral, keep accent.

| # | Name | Dominant | Accent | Neutral |
|---|------|----------|--------|---------|
| 1 | Warm Ember | `#D4451A` orange | `#1A1A2E` navy | warm gray |
| 2 | Forest Protocol | `#2D5016` green | `#F5A623` amber | stone |
| 3 | Arctic Mint | `#0D9488` teal | `#F43F5E` rose | cool gray |
| 4 | Desert Sand | `#C2956B` sand | `#2563EB` blue | warm neutral |
| 5 | Midnight Gold | `#0F172A` black | `#EAB308` gold | slate |
| 6 | Coral Reef | `#FB7185` coral | `#0EA5E9` sky | zinc |
| 7 | Rust Industrial | `#B45309` rust | `#18181B` charcoal | neutral |
| 8 | Ocean Deep | `#0C4A6E` blue | `#84CC16` lime | blue-gray |
| 9 | Blush Editorial | `#FCA5A5` pink | `#1E3A5F` navy | rose-gray |
| 10 | Neon Terminal | `#22C55E` green | `#000000` black | green-gray |
| 11 | Clay Earth | `#92400E` brown | `#059669` emerald | amber-gray |
| 12 | Lavender Fog | `#A78BFA` lavender | `#F97316` orange | purple-gray |
| 13 | Charcoal Cream | `#27272A` charcoal | `#FBBF24` amber | cream |
| 14 | Pacific Blue | `#0369A1` pacific | `#F59E0B` yellow | sky |
| 15 | Sage Minimal | `#6B7280` sage | `#DC2626` red | neutral |
| 16 | Copper Tech | `#C27B3A` copper | `#1D4ED8` blue | warm gray |
| 17 | Crimson Bold | `#BE123C` crimson | `#FDE68A` gold | neutral |
| 18 | Storm Cloud | `#475569` gray | `#10B981` emerald | cool |
| 19 | Ivory Minimal | `#FFFBEB` ivory | `#1C1917` black | stone |
| 20 | Electric Citrus | `#FACC15` yellow | `#7C3AED` violet | zinc |

## Animation Recipes (pick 1-2 max)

**Cross-platform:** Orchestrated Stagger, Spring Physics (`cubic-bezier(0.34,1.56,0.64,1)`), Micro-Choreography (multi-prop hover)
**Web:** Scroll-Linked Parallax (`animation-timeline:scroll()`), Kinetic Typography, Cursor-Reactive tilt, Reveal Masks (clip-path), Morphing Shapes
**Native:** Shared Element Transition, Gesture-Driven, Haptic Punctuation, Rubber Band

## CSS Techniques AI Underuses

clip-path, background-blend-mode, font-feature-settings, CSS Grid subgrid, variable fonts (font-variation-settings), mix-blend-mode, @property, scroll-driven animations, noise/grain SVG overlays, shape-outside, float for magazine flow, negative margins for overlap

## Platform Adaptation

**Web**: Detect CSS approach (Tailwind/Modules/CSS-in-JS) — never mix. CSS custom properties for theme.
**Desktop (Tauri/Electron)**: Respect OS chrome, platform window controls, keyboard shortcuts, min-width/height.
**Mobile (RN/Flutter)**: Follow HIG/Material3, native components, safe areas, 44pt/48dp touch targets, dynamic type.
**Native (SwiftUI/Compose)**: Platform design tokens, semantic colors, platform animation conventions.
**CLI/TUI**: Box-drawing, ANSI 256/truecolor, no-color fallback, respect terminal width.

## Quality Standards

**Accessibility**: WCAG 2.1 AA (web), VoiceOver/TalkBack (mobile), keyboard nav (desktop), prefers-reduced-motion, no color-only info.
**Responsive**: Mobile-first (web), adaptive (mobile), window resize (desktop).
**Dark mode**: Semantic color tokens, both modes tested, system preference respected.
**Performance**: LCP<2.5s, 60fps scrolling, font preload strategy.

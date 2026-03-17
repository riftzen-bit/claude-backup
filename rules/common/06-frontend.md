# Frontend Quality

## Design — Anti-Slop

Before any frontend code, commit to a BOLD aesthetic direction:
- **Purpose**: What problem? Who uses it? **Tone**: Pick one — brutally minimal, retro-futuristic, organic, luxury, editorial, brutalist, art deco, industrial. Never "generic modern". **Differentiation**: What makes it UNFORGETTABLE?

### Always Do
- Distinctive, characterful fonts — pair display + body, never Inter/Roboto/Arial/system fonts
- CSS variables for color themes — dominant colors with sharp accents
- Atmosphere: gradient meshes, noise textures, geometric patterns, grain overlays
- Purposeful animations — orchestrated page load with staggered reveals
- Vary aesthetics across projects — no convergence on same fonts/colors

### Never Do (AI Slop)
- Purple/indigo gradients on white, generic 3-card grids, cookie-cutter heroes
- Unstyled Tailwind defaults (blue-500, gray-100), predictable layouts
- Anything that looks "AI generated"

### Implementation
- CSS custom properties for all visual values
- Unexpected layouts: asymmetry, overlap, diagonal flow, grid-breaking, generous negative space

## CSS — One Approach Per Project

Detect first: Tailwind? CSS Modules? CSS-in-JS? Sass? Don't mix.
- Next.js: global CSS in layout.tsx only, component styles via CSS Modules
- Tailwind: v3 (tailwind.config.js) vs v4 (CSS @theme) — syntax differs

## Accessibility (WCAG 2.1 AA)

- Contrast: 4.5:1 normal, 3:1 large text
- Semantic HTML: `<button>` not `<div onClick>`, `<nav>` not `<div class="nav">`
- Keyboard navigable, ARIA labels on non-text elements, descriptive alt text
- Focus indicators visible, no color-only information

## Responsive — Mobile First

- Base styles mobile, min-width queries for larger. No fixed widths. Touch: min 44x44px

## Components

- Single responsibility, max 150 lines. Container (logic) / presentational (UI) split
- No prop drilling >2 levels — use context. Minimize useEffect — derive state instead
- No inline function definitions in JSX

## Visual Verification

Layout issues are silent. After generating UI code, verify rendered output for overflow, alignment, spacing, stacking.

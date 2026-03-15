# Frontend Quality

## Design — Anti-Slop, Always Active

Before writing any frontend code, commit to a BOLD aesthetic direction:
- **Purpose**: What problem does this interface solve? Who uses it?
- **Tone**: Pick a clear direction: brutally minimal, retro-futuristic, organic/natural, luxury/refined, editorial/magazine, brutalist/raw, art deco/geometric, industrial/utilitarian — never "generic modern"
- **Differentiation**: What makes this UNFORGETTABLE?

### Always Do
- Choose distinctive, characterful fonts — pair a display font with a refined body font
- Use CSS variables for cohesive color themes — dominant colors with sharp accents
- Add atmosphere: gradient meshes, noise textures, geometric patterns, layered transparencies, grain overlays
- Use animations purposefully — one orchestrated page load with staggered reveals > scattered micro-interactions
- Vary between light/dark themes, different fonts, different aesthetics across projects
- Use project design tokens if they exist; if not, create a design direction before coding

### Never Do (AI Slop Blacklist)
- Inter, Roboto, Arial, system fonts as primary font
- Purple/indigo gradients on white backgrounds
- Generic 3-card icon grids, cookie-cutter hero sections
- Predictable layouts, evenly-distributed timid palettes
- Unstyled Tailwind default colors (blue-500, gray-100)
- Converging on the same fonts across projects (e.g. always Space Grotesk)
- Any pattern that looks "AI generated"

### Implementation
- Match complexity to aesthetic vision: maximalist = elaborate animations, minimalist = precision spacing and typography
- CSS custom properties for all visual values
- Unexpected layouts: asymmetry, overlap, diagonal flow, grid-breaking elements, generous negative space

## CSS — One Approach Per Project

Detect before writing: Tailwind? CSS Modules? CSS-in-JS? Plain CSS/BEM? Sass?

Do not mix approaches. Framework-specific:
- Next.js: global CSS only in _app.js or layout.tsx, component styles via CSS Modules
- Tailwind: check v3 (tailwind.config.js) vs v4 (CSS @theme directives) — syntax differs

## Accessibility (WCAG 2.1 AA)

- Color contrast: 4.5:1 normal text, 3:1 large text
- Semantic HTML: `<button>` not `<div onClick>`, `<nav>` not `<div class="nav">`
- Keyboard navigable: all interactive elements reachable via Tab
- ARIA labels on interactive elements without visible text
- Alt text on images (descriptive, not "image" or "photo")
- Focus indicators visible on all interactive elements
- No information conveyed by color alone

## Responsive — Mobile First

- Base styles for mobile, min-width queries for larger screens
- No fixed widths on containers (use %, rem, max-width)
- Touch targets: minimum 44x44px
- No horizontal scrolling at any viewport width

## Components

- Single responsibility, max 150 lines per component
- Separate container (logic) from presentational (UI)
- No prop drilling beyond 2 levels — use context or state management
- Minimize useEffect — most can be replaced by derived state or event handlers
- No inline function definitions in JSX

## Visual Verification

Layout issues are silent — they don't throw errors. After generating UI code, verify rendered output for overflow, alignment, spacing, and stacking.

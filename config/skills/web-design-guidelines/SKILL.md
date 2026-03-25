---
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
argument-hint: file-or-pattern
---

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Fetch the latest guidelines from the source URL below
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the fetched guidelines
4. Output findings in the terse `file:line` format

## Guidelines Source

Fetch fresh guidelines before each review:

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

Use WebFetch to retrieve the latest rules. The fetched content contains all rules and output format.

## Quick Checklist (when fetch unavailable)

### Accessibility (WCAG 2.1 AA)
- [ ] Color contrast: 4.5:1 normal text, 3:1 large text
- [ ] Semantic HTML: `<nav>`, `<main>`, `<article>`, `<section>`, `<aside>`
- [ ] All interactive elements keyboard-accessible (Tab, Enter, Escape)
- [ ] Focus indicators visible — never `outline: none` without replacement
- [ ] ARIA labels on icon-only buttons and non-text content
- [ ] Form inputs have associated `<label>` elements
- [ ] Skip-to-content link for keyboard users
- [ ] `prefers-reduced-motion` respected for animations

### Responsiveness
- [ ] Mobile-first: base styles for small screens, `min-width` media queries
- [ ] No horizontal scroll at any viewport width
- [ ] Touch targets minimum 44x44px
- [ ] Text readable without zooming (16px+ body)
- [ ] Images use `max-width: 100%` or responsive srcset

### Performance
- [ ] Images: lazy loading, proper format (WebP/AVIF), width/height set
- [ ] Fonts: `font-display: swap`, preload critical fonts
- [ ] No layout shift (CLS): dimensions on media, skeleton loaders
- [ ] CSS/JS: critical path inlined or preloaded

### Interaction
- [ ] Loading states for async operations (not blank screens)
- [ ] Error states are helpful, not just "Something went wrong"
- [ ] Destructive actions require confirmation
- [ ] Form validation inline, not just on submit
- [ ] Optimistic UI where appropriate (toggle, like, bookmark)

## Usage

When a user provides a file or pattern argument:
1. Fetch guidelines from the source URL above
2. Read the specified files
3. Apply all rules from the fetched guidelines + quick checklist above
4. Output findings using `file:line — [severity] description` format

If no files specified, ask the user which files to review.

## Output Format

```
src/components/Button.tsx:15 — [error] Button missing focus indicator
src/components/Card.tsx:42 — [warn] Image missing width/height attributes
src/pages/index.tsx:8 — [info] Consider adding skip-to-content link
```

Severity: `error` (must fix), `warn` (should fix), `info` (nice to have).

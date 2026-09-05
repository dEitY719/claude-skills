# visualize: Critical Requirements

These requirements must be followed for every visualization.

[WARN] **EVALUATION FAILURE GUARANTEED WITHOUT THESE ELEMENTS.** Always start from [skeleton.md](skeleton.md).

1. **CSS Custom Properties:** Exact names required: `--bg, --surface, --surface-hover, --border, --text, --text-secondary, --accent, --accent-secondary, --positive, --negative, --warning`
2. **Utility Menu (MANDATORY):** `.viz-menu` with `.viz-menu-toggle`, `.viz-menu-dropdown`, download PNG (`downloadImage()`), print (`window.print()`), and html-to-image CDN script. See [menu.md](menu.md) for full implementation.
3. **Theme Classes (EVALUATION CRITICAL):** Define BOTH `.theme-light` and `.theme-dark` in stylesheet — class-based only, **never** `@media prefers-color-scheme`. See [design-system.md](design-system.md).
4. **Semantic HTML:** `<main id="main-content">`, multiple `<section>` elements, skip-to-content link.
5. **Chart.js (EVALUATION CRITICAL, charts only):** CDN before `</head>`, `Chart.defaults.animation = false;` immediately after, ChartManager pattern (preferred). See [chartjs-patterns.md](chartjs-patterns.md).
6. **Responsive Design:** No horizontal overflow at 375px. Font hierarchy: `h1 ≥ 3rem, h2 ≥ 2rem, h3 ≥ 1.5rem, body = 1rem`. See [sizing-rules.md](sizing-rules.md).
7. **Print & Accessibility:** `@media print`, `@media (prefers-reduced-motion: reduce)`, aria-labels on all interactive elements and charts.
8. **Entrance Animations (MANDATORY):** `.animate` classes or `data-reveal` — evaluation detects and requires animation presence. See [animations.md](animations.md) for patterns.
9. **JavaScript:** `cycleTheme()`, `toggleMenu()`, all top-level variables in the **generated HTML** use `var` (never `let`/`const` — avoids TDZ errors with CDN-loaded libraries).
10. **Bedrock-Safe Output (NON-NEGOTIABLE):** [bedrock-safe-write.md](bedrock-safe-write.md) owns this rule in full — one `Write`, never a second to the same path, zero HTML echoed into chat, `xdg-open` never `wslview`. Read it before delivering.

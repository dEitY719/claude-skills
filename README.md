# visuals-skills

Three skills for turning content into something you can show — a self-contained
HTML deck or dashboard, a vertical scroll deck built from a Markdown report, or
an Excalidraw architecture diagram. Packaged as a single plugin named `visuals`,
installable on six coding-agent harnesses.

## Skills

| Skill | Invoke | What it does |
|-------|--------|--------------|
| `visualize` | `/visuals:visualize [<file-or-content>]` | Writes one self-contained HTML file — deck, dashboard, infographic, poster, flowchart, timeline, carousel. Starts from a fixed skeleton and a design system, never from a blank page. The general-purpose default. |
| `md-to-scrolldeck` | `/visuals:md-to-scrolldeck <input.md> [--slides n] [--outline-only]` | Compresses one Markdown document into a vertical scroll-snap deck (scrollytelling) for leadership review: progress bar, phase header, dot rail, arrow-key nav, print-ready. Prints its slide outline before writing anything. |
| `excalidraw-diagram` | `/visuals:excalidraw-diagram <topic-or-spec>` | Generates `.excalidraw` JSON that argues visually rather than labelling boxes, renders it to PNG, looks at the render, and fixes it against a 27-item checklist before delivering. |

Pick by deliverable, not by topic: `.excalidraw` file -> `excalidraw-diagram`;
Markdown in and a vertical scroll deck out -> `md-to-scrolldeck`; everything
else visual -> `visualize`.

### Visual guides and worked examples (GitHub Pages)

- `visualize` — [visual guide](https://deity719.github.io/visuals-skills/skill-guides/visualize.html) · [usage example](https://deity719.github.io/visuals-skills/skill-output/visualize-usage.html) (Markdown to HTML output)
- `excalidraw-diagram` — [visual guide](https://deity719.github.io/visuals-skills/skill-guides/excalidraw-diagram.html) · [usage example](https://deity719.github.io/visuals-skills/skill-output/excalidraw-diagram-usage.html) (prompt to diagram)

`excalidraw-diagram` also has its own
[README](skills/excalidraw-diagram/README.md) covering VSCode setup and the
render pipeline.

## Install

### Claude Code

```
/plugin marketplace add dEitY719/visuals-skills
/plugin install visuals@visuals-skills
```

### Codex

```
codex plugin install dEitY719/visuals-skills
```

### Kimi CLI

```
kimi plugin install dEitY719/visuals-skills
```

### Hermes Agent

```
hermes plugins install dEitY719/visuals-skills
```

### OpenCode

See [`.opencode/INSTALL.md`](.opencode/INSTALL.md).

### Gemini CLI / Antigravity

```
gemini extensions install https://github.com/dEitY719/visuals-skills
```

Antigravity (`agy`) shares `~/.gemini`, so it inherits the install.

### From the shell (npx)

```
npx skills add https://github.com/dEitY719/visuals-skills
```

## Harness support

These skills are written in Claude Code's vocabulary, but they lean on very
little that is Claude-Code-specific: they read files, write one output file, and
run a shell command. The per-harness tool mappings live in the sibling repo
[`dEitY719/harness-skills`](https://github.com/dEitY719/harness-skills/tree/main/references);
read the one file for the harness you are on.

| Skill | Claude Code | Codex | Kimi | Gemini / Antigravity | Hermes | OpenCode |
|-------|:-----------:|:-----:|:----:|:--------------------:|:------:|:--------:|
| `visualize` | full | full | full | full | full | full |
| `md-to-scrolldeck` | full | full | full | full | full | full |
| `excalidraw-diagram` | full | needs image read-back | needs image read-back | needs image read-back | needs image read-back | needs image read-back |

*needs image read-back* — Step 5 renders the diagram to PNG and then *looks at
it* to catch overlapping text and misaligned arrows. A harness that cannot read
an image back still produces the `.excalidraw` and the PNG, but must report the
visual audit as skipped rather than claiming 27/27 quality items passed. That
step also needs `uv` and a Playwright Chromium on the machine.

Auto-open (`xdg-open` / `open`) is a no-op in a headless session; the skills
report the `file://` path instead.

## Layout

Manifests live at the repo root and all point at one flat `skills/` directory:

```
.
├── skills/{visualize,md-to-scrolldeck,excalidraw-diagram}/
│   ├── SKILL.md
│   ├── references/
│   └── examples/ · evals/
├── docs/                                        GitHub Pages guides + samples
├── .claude-plugin/{marketplace,plugin}.json     Claude Code
├── .codex-plugin/plugin.json                    Codex
├── .kimi-plugin/plugin.json                     Kimi CLI
├── .hermes-plugin/{plugin.yaml,__init__.py}     Hermes Agent
├── .opencode/plugins/visuals.js + INSTALL.md    OpenCode
├── .agents/plugins/marketplace.json             Antigravity
├── gemini-extension.json + GEMINI.md            Gemini CLI
├── package.json
├── CLAUDE.md · AGENTS.md -> CLAUDE.md
└── LICENSE
```

Only Claude Code understands a nested `plugins/<name>/skills/` layout. The other
five harnesses resolve manifests at the repo root and a skills tree at
`./skills/`, so this repo keeps everything flat — the nested layout it shipped
with through v0.4.0 is gone. See [`CLAUDE.md`](CLAUDE.md) for the full rationale
and contribution rules.

The `.kimi-plugin/` manifest is pre-provisioned: Kimi CLI is not installed on the
maintainer's machines yet, and shipping the manifest now costs nothing and saves
a migration later.

## CI

[`.github/workflows/validate.yml`](.github/workflows/validate.yml) validates
manifests, skill frontmatter, progressive-disclosure line limits, the Codex
description budget, version agreement across all seven version-bearing
manifests, plugin-name consistency, the `AGENTS.md` symlink, the flat layout,
and shell scripts.

**It is self-contained rather than a call to the shared reusable workflow, on
purpose.** Every other `dEitY719/*-skills` repo validates through
[`harness-skills/.github/workflows/skill-check.yml`](https://github.com/dEitY719/harness-skills/blob/main/.github/workflows/skill-check.yml).
That workflow includes a "No emojis in tracked text" check, and this repo's
`visualize` skill ships example HTML — posters, decks, infographics — that uses
emoji as intentional design glyphs in the rendered artwork. Fifteen tracked
files carry them. The shared check is structurally incompatible here, not merely
inconvenient, so `validate.yml` inlines every other check and omits that one.

Converting to the shared workflow (dotfiles #1410 D-10) is gated on one concrete
change there: `skill-check.yml` must grow a `check-emojis` boolean input
(`required: false`, `default: true`) guarding its emoji step. Once that ships on
`@main`, this file becomes a `uses:` call passing `plugin-name: visuals` and
`check-emojis: false`. Until then, a check added to the shared workflow must be
mirrored here by hand.

## Provenance

These skills were extracted from
[`dEitY719/dotfiles`](https://github.com/dEitY719/dotfiles)
(`claude/skills/devx-{visualize,md-to-scrolldeck,excalidraw-diagram}`) as a
content snapshot — no history rewriting. The source commit SHA is recorded in
this repo's conversion commit message. The `devx-` prefix is dropped here
because the plugin namespace (`visuals:`) now supplies it. The dotfiles copies
stay in place until Phase 4 of that repo's migration plan.

`visualize` and `excalidraw-diagram` originate upstream — `visualize` by
careerhackeralex, `excalidraw-diagram` by
[coleam00](https://github.com/coleam00/excalidraw-diagram-skill);
`md-to-scrolldeck` was written by [@dEitY719](https://github.com/dEitY719).
`.claude-plugin/plugin.json` keeps that authorship split from the maintainer
field.

This is Phase 1 of the dotfiles #1410 migration; `packaging-skills` was Phase 0
and `harness-skills` is its sibling in this phase.

## License

MIT. See [LICENSE](LICENSE).

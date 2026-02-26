# Godot Shadcn UI Kit

[中文说明](README.zh-CN.md)

A dark, shadcn-inspired Godot UI demo with two synchronized implementations:
- Runtime-generated UI (`GDScript`)
- Static editable UI (`.tscn`)

## Highlights
- Shadcn-like dark theme tokens (`demo/shadcn_dark_theme.tres`)
- Runtime and static parity workflow
- Responsive card grid by viewport width
- Input/edit controls verified for in-game usage
- Avoids editor-only API calls in runtime

## Project Layout
```text
.
├─ demo/
│  ├─ project.godot
│  ├─ main.tscn
│  ├─ gallery.gd
│  ├─ main_static.tscn
│  ├─ gallery_static.gd
│  ├─ shadcn_dark_theme.tres
│  └─ bake_static_from_code.gd
├─ .agent/skill/SKILL.md
└─ agent.md
```

## Quick Start
1. Open `demo/project.godot` with Godot 4.6 (or compatible 4.x).
2. Run the project to preview runtime-generated UI (`main.tscn`).
3. Open `demo/main_static.tscn` to edit the static version in the editor.
4. Open `demo/chat_ui.tscn` for the AI chat UX scene.

## Runtime vs Static
- Runtime source of truth: `demo/gallery.gd`
- Editable mirror: `demo/main_static.tscn`
- Static behavior/responsiveness: `demo/gallery_static.gd`

When adding or changing components, update both versions to keep node and behavior parity.

## AI Workflow
- Agent manual: `agent.md`
- Skill instructions: `.agent/skill/SKILL.md`

These files define how an AI agent should maintain the project safely and consistently.

## License
MIT

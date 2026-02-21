# Agent Manual

## Purpose
Use this workspace to build and maintain a shadcn-style Godot UI demo with:
- Runtime-generated UI (`gallery.gd` + `main.tscn`)
- Editable static scene UI (`main_static.tscn` + `gallery_static.gd`)

## Paths
- Skill root: `.agent/skill/`
- Demo project: `demo/`

## Demo Files
- Runtime entry: `demo/main.tscn`
- Runtime builder: `demo/gallery.gd`
- Static entry: `demo/main_static.tscn`
- Static behavior: `demo/gallery_static.gd`
- Theme: `demo/shadcn_dark_theme.tres`
- Optional bake script: `demo/bake_static_from_code.gd`

## Required Rules For AI
1. Keep runtime and static versions in parity.
2. Do not delete either version unless explicitly requested.
3. Keep default palette dark unless explicitly requested.
4. Keep responsive behavior:
   - Update column count by width breakpoints.
   - Keep root controls anchored to full viewport.
5. Keep input controls editable (LineEdit/TextEdit must accept typing).
6. Avoid editor-only APIs in runtime scenes (for example, avoid calling `EditorInterface.get_editor_settings()` in game runtime).
7. When adding components, update both:
   - `gallery.gd` (runtime build)
   - `main_static.tscn` (static editable mirror)

## Suggested Change Workflow
1. Edit theme tokens in `shadcn_dark_theme.tres`.
2. Implement runtime structure in `gallery.gd`.
3. Mirror node structure and key properties in `main_static.tscn`.
4. Keep responsive logic in `gallery_static.gd`.
5. If needed, use `bake_static_from_code.gd` to regenerate a baseline static scene, then fine-tune it manually.

## Definition Of Done
- Runtime scene loads.
- Static scene loads.
- Node hierarchy is aligned between runtime and static versions for each card/section.
- Inputs are editable.
- Fullscreen and resize keep layout stable.

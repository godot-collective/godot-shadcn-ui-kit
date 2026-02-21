---
name: shadcn-godot-program
description: Build and maintain a shadcn-style dark-theme Godot UI project with both runtime-generated UI and static editable TSCN versions. Use when creating, adjusting, reviewing, or debugging files under demo/, including theme updates, component parity, input behavior, and responsive layout.
---

# Shadcn Godot Program Skill

Use this skill to keep a Godot shadcn-style UI project consistent across runtime and static scene implementations.

## Project Location
- `demo/`

## Core Files
- Runtime scene: `main.tscn`
- Runtime UI builder: `gallery.gd`
- Static scene: `main_static.tscn`
- Static runtime sync and responsiveness: `gallery_static.gd`
- Theme: `shadcn_dark_theme.tres`
- Optional static bake script: `bake_static_from_code.gd`

## Required Workflow
1. Update style tokens and defaults in `shadcn_dark_theme.tres`.
2. Implement structural and behavior changes in `gallery.gd`.
3. Mirror the same structure and key properties in `main_static.tscn`.
4. Keep resize/fullscreen behavior in `gallery_static.gd`.
5. Add defaults for OptionButton controls from script if static scene cannot persist item data safely.

## Parity Checklist
1. Runtime and static versions contain matching section/card structure.
2. Inputs are editable and have the expected placeholders/text.
3. Responsive columns update for small/medium/large widths.
4. Dark shadcn-like style remains default.
5. No editor-only APIs are called during game runtime.

## Editing Rules
1. Keep both runtime and static versions; do not replace one with the other.
2. Keep naming stable for node paths used by scripts.
3. Prefer incremental changes over broad rewrites.
4. Preserve existing user changes outside the requested scope.

# Freezing Point — Project Context

## Game Concept
Top-down 2D puzzle-action game. Player presses **Q** to swap between two timelines (Present / Past). The environment changes between timelines — walls appear/disappear, paths open/close — while the player's world position stays the same. Inspired by the *Effect and Cause* mission from Titanfall 2.

**Engine:** Godot 4.6.2 (Compatibility renderer)

---

## Scene Structure

```
main.tscn
├── Main (Node)          ← main.gd
│   ├── Present (Node2D) ← active on start, visible + collision enabled
│   │   ├── Layer0 (TileMapLayer)  walls
│   │   └── Layer1 (TileMapLayer)  vases / objects
│   ├── Past (Node2D)    ← inactive on start, hidden + collision disabled
│   │   └── Layer0 (TileMapLayer)  walls (different layout)
│   └── Player (CharacterBody2D)  ← player.tscn instance

player.tscn
└── Player (CharacterBody2D)  ← player.gd
    ├── AnimatedSprite2D  (idle 6f@8fps, walk 8f@12fps)
    ├── CollisionShape2D  (CapsuleShape2D)
    └── Camera2D          (zoom 5x, smooth tracking)
```

---

## Key Files

| File | Purpose |
|---|---|
| `main.gd` | Timeline swap logic |
| `player.gd` | Movement + animation |
| `main-tile.tres` | Shared TileSet (wall, texture, touches, vase sources) |

---

## Input Map

| Action | Key |
|---|---|
| `ui_left/right/up/down` | Arrow keys / WASD |
| `timeline_swap` | Q |

---

## Implemented Features

### Timeline Swap (`main.gd`)
- `in_present: bool` tracks active timeline
- `_apply_timeline_state()` toggles `visible` and `collision_enabled` on all TileMapLayer children of each group
- **Crush prevention:** `_has_collision_at_player()` checks `TileData.get_collision_polygons_count(0)` at the player's center tile before allowing swap. Logs `"can't jump"` if blocked.

### Player (`player.gd`)
- `CharacterBody2D` + `move_and_slide()`
- Speed: 200 px/s
- No timeline awareness — intentional

---

## Known Limitations / Deferred

- Crush check only tests player **center point** — misses partial overlaps at tile edges
- No visual/audio feedback when jump is blocked (placeholder: `print("can't jump")`)
- Fog of war / limited vision in Past — deferred (conflicts with a planned core feature)
- No enemies, combat, or sound yet

---

## Conventions
- Claude writes scripts and input map entries
- User paints tiles and sets up TileSet resources in the Godot editor
- TileMapLayers are always grouped one level deep under `Present` or `Past` — `_set_timeline_active()` relies on this

## Godot Editor Workflow — IMPORTANT
The primary workspace is the **Godot Editor**. Claude must never create `.tscn` files from scratch.

Instead, when scene changes are needed:
1. Write or edit the `.gd` script only
2. Provide step-by-step Godot Editor instructions for any node/scene setup the user must do manually (e.g. "In the Godot Editor: add a Marker2D child to LaserRoom, name it `RespawnPoint`, set position to X/Y")

This applies to all scene work: adding nodes, setting properties, wiring signals, creating new scenes. **Scripts = Claude. Scenes = user in editor.**

<!-- GSD:project-start source:PROJECT.md -->
## Project

**Freezing Point**

A top-down 2D puzzle game built for a game jam (deadline: April 30, 2026). The player presses Q to swap between two timelines — Present and Past — while keeping their world position. Walls appear and disappear, paths open and close, and hazards exist only in one timeline. The goal is to navigate 4 chained puzzle rooms by leveraging the timeline difference. Inspired by *Effect and Cause* from Titanfall 2.

**Core Value:** The timeline swap must feel responsive and surprising — every room should have at least one "aha" moment where swapping solves something the player couldn't do otherwise.

### Constraints

- **Timeline:** April 30, 2026 deadline — 10 days, no slip
- **Scope lock:** No new mechanics or features; finish and polish what exists
- **Engine:** Godot 4.6.2 — all code must target this version
- **Team size:** 3 people, part-time jam cadence
<!-- GSD:project-end -->

<!-- GSD:stack-start source:STACK.md -->
## Technology Stack

Technology stack not yet documented. Will populate after codebase mapping or first phase.
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd:quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd:debug` for investigation and bug fixing
- `/gsd:execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->

<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd:profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->

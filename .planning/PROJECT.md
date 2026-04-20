# Freezing Point

## What This Is

A top-down 2D puzzle game built for a game jam (deadline: April 30, 2026). The player presses Q to swap between two timelines — Present and Past — while keeping their world position. Walls appear and disappear, paths open and close, and hazards exist only in one timeline. The goal is to navigate 4 chained puzzle rooms by leveraging the timeline difference. Inspired by *Effect and Cause* from Titanfall 2.

## Core Value

The timeline swap must feel responsive and surprising — every room should have at least one "aha" moment where swapping solves something the player couldn't do otherwise.

## Team

| Role | Responsibility |
|------|---------------|
| Programmer | Technical implementation, art integration, logic |
| 3D Artist | Asset creation |
| Game Designer | Room layout, puzzle design, uses programmer's assets |

## Requirements

### Validated (Already Built)

- ✓ Timeline swap mechanic (Q key, Present ↔ Past)
- ✓ Crush prevention on swap
- ✓ TileMapLayer collision toggling per timeline
- ✓ Player movement with directional walk animations
- ✓ Swap effect animation
- ✓ Pushable Vase (CharacterBody2D, push mechanic)
- ✓ Pressure Plate (signals: pressed / released)
- ✓ Lever (toggle, `toggled` signal, timeline-aware)
- ✓ Door (open/close, StaticBody2D)
- ✓ Laser (raycast beam, kills/respawns player)
- ✓ Laser Room (puzzle_room with Present/Past sides)
- ✓ Box/Vase Room (vase + pressure plate puzzle)
- ✓ base_room.gd (timeline state management for puzzle rooms)
- ✓ SpawnPoint (Marker2D for player start)

### Active (Must Ship)

- [ ] **ANIM-01**: Player shows correct directional idle frame (side/front/back) when stopped
- [ ] **GAME-01**: Fall & respawn — when player swaps into void, play fall animation then teleport to nearest Marker2D
- [ ] **GAME-02**: Reset mechanic — player presses a key to reset the current puzzle room to its initial state
- [ ] **ROOM-01**: Puzzle Room 3 — designed and implemented
- [ ] **ROOM-02**: Puzzle Room 4 — designed and implemented
- [ ] **POLISH-01**: All 4 rooms chain linearly and the game is completable end-to-end

### Out of Scope (Could-Have, Post-Jam)

- Title / start screen — nice to have, not required for jam play
- Win / ending screen — could-have
- Sound effects and music — could-have
- Credits screen — could-have
- New laser texture — visual improvement, not blocking
- Fog-of-war effect — deferred
- Improved lighting and shadows — deferred

## Context

**Engine:** Godot 4.6.2, Compatibility renderer
**Jam deadline:** April 30, 2026 (10 days from project init on April 20)
**Progress:** ~60% complete
**First game jam** for the full team

### Scene Architecture

Puzzle rooms are self-contained `Node2D` scenes with `puzzle_room` group and `base_room.gd` script. Each has a `Present/` and `Past/` child node. `main.gd` calls `room.set_timeline(in_present)` on all `puzzle_room` group members during every swap.

Interactive objects inside a room side use the `timeline_object` group and implement `set_timeline_active(active: bool)` to handle their own enable/disable logic.

### File Map

| File | Purpose |
|------|---------|
| `game_object/script/main.gd` | Timeline swap, crush check, room coordination |
| `game_object/script/base_room.gd` | Shared puzzle room timeline state logic |
| `game_object/script/player.gd` | Movement, animation, push |
| `game_object/script/lever.gd` | Toggle interactable, `timeline_object` |
| `game_object/script/laser.gd` | Raycast beam, collision, respawn |
| `game_object/script/door.gd` | open/close StaticBody2D |
| `game_object/script/pressure_plate.gd` | Area2D, pressed/released signals |
| `game_object/script/vase.gd` | Pushable CharacterBody2D |
| `game_object/scene/tile_map.tscn` | Main level scene |
| `game_object/scene/laser_room.tscn` | Laser Room puzzle room |

## Constraints

- **Timeline:** April 30, 2026 deadline — 10 days, no slip
- **Scope lock:** No new mechanics or features; finish and polish what exists
- **Engine:** Godot 4.6.2 — all code must target this version
- **Team size:** 3 people, part-time jam cadence
- **Editor workflow:** Claude writes `.gd` scripts only — never generates `.tscn` files from scratch. Any scene setup is given as step-by-step Godot Editor instructions for the programmer to apply manually.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| puzzle_room group pattern | Rooms are self-contained; main.gd broadcasts timeline to all | ✓ Good |
| base_room.gd shared script | Avoids duplicating Present/Past toggle logic in every room | ✓ Good |
| Crush check center-only | Simpler implementation; edge cases rare in practice | — Pending revisit if edge bugs appear |
| Scope lock for jam | 10 days is not enough to add new mechanics safely | ✓ Good |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition:**
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After milestone (submission):**
1. Full review of all sections
2. Mark all Active requirements as Validated or dropped
3. Capture post-jam retrospective notes

---
*Last updated: 2026-04-20 after project initialization*

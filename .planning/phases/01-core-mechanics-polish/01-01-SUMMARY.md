---
phase: 01-core-mechanics-polish
plan: 01
subsystem: gameplay
tags: [godot, gdscript, animation, respawn, timeline-swap]

# Dependency graph
requires: []
provides:
  - Directional idle animation (idle_front / idle_back / idle_side) based on last movement direction
  - Fall animation method on player with callback pattern
  - Void tile detection after timeline swap
  - Fall + respawn mechanic using respawn_point group
affects: [02-rooms, 03-polish]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "play_fall_animation(callback: Callable) mirrors play_swap_effect() — animation finished fires callback via CONNECT_ONE_SHOT"
    - "_is_void_at_player() is inverse of _has_collision_at_player() — checks active timeline instead of destination"
    - "RespawnPoint Marker2D nodes added to respawn_point group — nearest-by-distance selection, push_warning fallback"

key-files:
  created: []
  modified:
    - game_object/script/player.gd
    - game_object/script/main.gd

key-decisions:
  - "Directional idle uses idle_ + _last_dir string concat — animation names must match exactly in AnimatedSprite2D"
  - "Fall respawn uses group-based nearest-point search rather than name lookup — consistent with puzzle_room pattern"
  - "Void check returns true on empty space (no collision polygon found) — same tile iteration logic as crush check"

patterns-established:
  - "Animation + callback: play animation, connect animation_finished CONNECT_ONE_SHOT, call callback inside signal"
  - "Group-based respawn: get_nodes_in_group('respawn_point'), nearest-distance loop, push_warning if none found"

requirements-completed:
  - ANIM-01
  - GAME-01

# Metrics
duration: 1min
completed: 2026-04-20
---

# Phase 01 Plan 01: Directional Idle and Fall/Respawn Mechanic Summary

**Directional idle animation tracking via _last_dir and void-tile respawn using fall animation callback + respawn_point group**

## Performance

- **Duration:** ~1 min
- **Started:** 2026-04-20T18:21:39Z
- **Completed:** 2026-04-20T18:22:38Z
- **Tasks:** 2 of 3 complete (Task 3 is a human-verify checkpoint — awaiting editor setup)
- **Files modified:** 2

## Accomplishments

- `player.gd` now tracks `_last_dir` each frame and plays `idle_front`, `idle_back`, or `idle_side` when velocity is zero
- `player.gd` exposes `play_fall_animation(callback: Callable)` using the same animation-finished/CONNECT_ONE_SHOT pattern as `play_swap_effect`
- `main.gd` detects void tiles after swap via `_is_void_at_player()` and triggers fall + warp to nearest `respawn_point` group member

## Task Commits

1. **Task 1: Directional idle animation (ANIM-01)** - `3bc3744` (feat)
2. **Task 2: Fall detection and void respawn (GAME-01)** - `7689512` (feat)

## Files Created/Modified

- `game_object/script/player.gd` — added `_last_dir`, updated animation block, added `play_fall_animation`
- `game_object/script/main.gd` — added `_is_void_at_player`, `_do_fall_and_respawn`, wired void check after `_apply_timeline_state`

## Decisions Made

- Directional idle uses string concat `"idle_" + _last_dir` — animation names in AnimatedSprite2D must be exactly `idle_front`, `idle_back`, `idle_side`
- Fall respawn uses group nearest-distance search rather than a fixed node reference — matches existing `puzzle_room` broadcast pattern
- `_is_void_at_player()` checks both main timeline TileMapLayers and puzzle_room group sides, mirroring `_has_collision_at_player` structure

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required (Task 3 — Checkpoint)

The following editor steps are required before the plan is fully verified:

**Step 1 — Verify input map:** Confirm `timeline_swap` action exists and is bound to Q (Project > Project Settings > Input Map).

**Step 2 — Verify animation names in AnimatedSprite2D (player.tscn):**
Open player.tscn, select AnimatedSprite2D, confirm these animations exist:
- `idle_front`, `idle_back`, `idle_side` (needed by ANIM-01)
- `fall` (needed by GAME-01)
- `walk_front`, `walk_back`, `walk_side` (should already exist)
If any are missing, create them (single-frame placeholders are fine for now).

**Step 3 — Add RespawnPoint to tile_map.tscn:**
1. Open `game_object/scene/tile_map.tscn`
2. Add Child Node > Marker2D, name it `RespawnPoint`
3. Set Position to a safe floor tile (solid ground in Present timeline, near start)
4. Node tab > Groups > type `respawn_point` > click Add

**Step 4 — Add RespawnPoint to laser_room.tscn:**
1. Open `game_object/scene/laser_room.tscn`
2. Same steps: Add Marker2D named `RespawnPoint`, position at safe tile, add to group `respawn_point`

**Verification (run the game F5):**
1. Walk in each direction then release keys — confirm directional idle facing matches last walk direction
2. Find a void tile in the opposite timeline, stand adjacent, press Q — confirm fall animation plays and player reappears at RespawnPoint

## Known Stubs

- `fall` animation does not yet exist in AnimatedSprite2D — `play_fall_animation` will call `_animated_sprite.play("fall")` which Godot will warn about at runtime until the animation is created in the editor (Task 3 editor setup resolves this)
- `idle_front`, `idle_back`, `idle_side` animations may not exist yet — will cause Godot runtime warnings until created in editor (Task 3 resolves)

## Next Phase Readiness

- Scripts are complete and committed
- Plan blocked at Task 3 (human-verify) — user must do editor setup and run a play test
- After Task 3 approval, plan 01-01 is fully complete and plan 01-02 (GAME-02 reset mechanic) can begin

---
*Phase: 01-core-mechanics-polish*
*Completed: 2026-04-20 (partial — awaiting Task 3 human-verify)*

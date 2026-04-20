# Phase 1: Core Mechanics Polish - Context

**Gathered:** 2026-04-20
**Status:** Ready for planning

<domain>
## Phase Boundary

Complete the three remaining player mechanics (ANIM-01, GAME-01, GAME-02) so all puzzle rooms are playable without animation or gameplay bugs. Scope is strictly mechanics — no new rooms, UI, or features.

</domain>

<decisions>
## Implementation Decisions

### Directional Idle Animation (ANIM-01)
- **D-01:** `_animated_sprite` already has directional idle animations painted. Claude can call `play()` directly with the appropriate animation name based on last movement direction.
- **D-02:** Track last movement direction in `player.gd` — when velocity reaches zero, play the matching idle (idle_front, idle_back, idle_side) instead of generic "idle".

### Fall & Void Detection (GAME-01)
- **D-03:** Void = no collision polygons at the player's tile position in the active timeline. This covers both null tile data AND the Shadow variant-2 tile (has tile data but zero physics layer collision). Detection is the inverse of the existing `_has_collision_at_player()` logic.
- **D-04:** Fall flow: after swap completes, check for void at player position. If void → play `"fall"` animation on `_animated_sprite`, wait for `animation_finished` signal, then warp player.
- **D-05:** Void check must also scan puzzle room TileMapLayers (same approach as `_has_collision_at_player` already does) — not just the top-level Present/Past layers.

### Respawn Points (GAME-01)
- **D-06:** After fall animation finishes, warp player to the nearest Marker2D named `"RespawnPoint"` found anywhere in the full scene tree.
- **D-07:** Named search ("RespawnPoint") avoids accidentally picking up laser `spawn_point` nodes.
- **D-08:** This works for both standalone puzzle room scenes and objects living directly in `tile_map.tscn` — no scene refactoring required. Programmer adds a Marker2D named `RespawnPoint` in the Godot editor wherever respawn makes sense.

### Reset Mechanic (GAME-02)
- **D-09:** R key triggers room reset. Add `reset_room` action to the input map bound to R.
- **D-10:** Each resettable object (vase, lever, door, laser) stores its initial state in `_ready()` and exposes a `reset()` method.
- **D-11:** Objects register themselves in a new `resettable` group. `main.gd` listens for R key press and calls `reset()` on all nodes in the `resettable` group — consistent with the existing `puzzle_room` and `timeline_object` group patterns.
- **D-12:** Reset restores: vase `global_position`, lever `is_on` state, door open/close state, laser active state — all back to their `_ready()` values.

### Claude's Discretion
- Exact animation name for directional idles (assumed idle_front / idle_back / idle_side — Claude should confirm by reading AnimatedSprite2D animation list if accessible, or use these names and note them in editor instructions)
- Whether player position resets on R press (not specified — default to no player teleport on reset)
- Handling edge case where no RespawnPoint exists in scene tree (log a warning, fall back to current position)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Core scripts
- `game_object/script/main.gd` — Timeline swap, crush check, room coordination; reset will be added here
- `game_object/script/player.gd` — Movement, animation, push; fall detection and idle direction added here
- `game_object/script/base_room.gd` — Shared puzzle room timeline logic (no reset logic yet)
- `game_object/script/lever.gd` — Toggle interactable; needs `reset()` method
- `game_object/script/door.gd` — Open/close StaticBody2D; needs `reset()` method
- `game_object/script/laser.gd` — Raycast beam; needs `reset()` method
- `game_object/script/vase.gd` — Pushable CharacterBody2D; needs `reset()` method

### Scene structure reference
- `game_object/scene/tile_map.tscn` — Main level scene; Present/Past both have Shadow + Layer1 + Layer2 children
- `game_object/scene/laser_room.tscn` — Standalone puzzle room scene example

No external specs — requirements fully captured in decisions above and REQUIREMENTS.md.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `_has_collision_at_player(timeline)` in `main.gd`: Void detection is the logical inverse — reuse the same tile iteration loop
- `play_swap_effect()` in `player.gd`: Pattern for animation sequencing with `animation_finished` signal — fall flow follows same structure
- `puzzle_room` group + `set_timeline()` broadcast pattern: Reset uses identical group-call pattern with `resettable` group + `reset()` method

### Established Patterns
- Group-based broadcast: `main.gd` calls methods on all group members (`puzzle_room`, `timeline_object`). Reset adds `resettable` as a third group following the same convention.
- `set_timeline_active(active: bool)` per-object method: `reset()` follows the same per-object method contract.
- `_ready()` exports as state source: `lever.gd` already uses `@export var is_on: bool = false` — initial state is naturally available at `_ready()`.

### Integration Points
- `main.gd` `_unhandled_input`: R key reset handler added here alongside existing `timeline_swap` handler
- `main.gd` `_apply_timeline_state()`: Fall check is called after swap completes, before returning control to player
- Void check in `main.gd` iterates Present/Past TileMapLayer children + puzzle_room group sides — fall detection uses same traversal
- Shadow layer in tile_map.tscn: Both Present and Past have a `Shadow` child TileMapLayer — variant-2 shadow tiles (no collision) are the primary void tiles

</code_context>

<specifics>
## Specific Ideas

- Void tile: Shadow layer variant 2 — has tile data but no physics layer collision polygon. Variant 1 (with collision) is the map edge border — not void.
- Fall animation: already painted in `_animated_sprite` as `"fall"` — play it and wait for `animation_finished` before warping.
- RespawnPoint markers: Programmer adds Marker2D nodes named exactly `"RespawnPoint"` in the Godot editor wherever respawn makes sense. No scene refactoring required.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 01-core-mechanics-polish*
*Context gathered: 2026-04-20*

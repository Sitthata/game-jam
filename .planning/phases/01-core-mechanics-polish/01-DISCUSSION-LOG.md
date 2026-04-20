# Phase 1: Core Mechanics Polish - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-04-20
**Phase:** 01-core-mechanics-polish
**Areas discussed:** Fall + void detection, Respawn point strategy, Reset key + scope

---

## Fall + Void Detection

| Option | Description | Selected |
|--------|-------------|----------|
| A — No tile data | Any tile with null tile_data counts as void | |
| B — No collision polygons | Tile data exists but zero physics layer polygons | ✓ |
| C — Specific void tile type | Mark void tiles explicitly in TileSet | |

**User's choice:** B (covers both null tile_data AND Shadow variant-2 tiles which have no collision polygon)
**Notes:** The tileset has two Shadow tile variants — variant 1 has collision (map edge border), variant 2 has no physics layer (the walkable void). Void detection must catch both null tile_data and variant 2. This is the logical inverse of the existing `_has_collision_at_player()` function.

Fall animation options:

| Option | Description | Selected |
|--------|-------------|----------|
| A — Dedicated "fall" animation | Already painted in AnimatedSprite2D | ✓ |
| B — Reuse swap jump effect | Use existing _effect_sprite "jump" | |
| C — Freeze + delay | No animation, just a brief pause | |

**User's choice:** A — "fall" animation is already done in the sprite sheet. Play it, wait for `animation_finished`, then warp.

---

## Respawn Point Strategy

| Option | Description | Selected |
|--------|-------------|----------|
| A — Room-local Marker2D | Each room scene gets its own RespawnPoint node | ✓ (adapted) |
| B — Nearest any Marker2D | Search all Marker2D nodes, pick closest | |
| C — Always main SpawnPoint | Single fallback to main scene spawn | |

**User's choice:** A (adapted) — search for nearest Marker2D named exactly `"RespawnPoint"` in the full scene tree. Named search avoids picking up laser `spawn_point` nodes. Compatible with tile_map.tscn content that lives directly in the main scene (no refactoring needed).
**Notes:** User explicitly said not to require all rooms to be standalone scenes — some puzzle content lives directly in tile_map.tscn and refactoring is not worth it.

---

## Reset Key + Scope

| Option | Description | Selected |
|--------|-------------|----------|
| R | Common puzzle game reset key | ✓ |
| E | Already used for interact | |
| Other | User-specified | |

**User's choice:** R key (`reset_room` input action)

Reset scope confirmed:
- ✓ Vase positions (global_position)
- ✓ Door states (open/close)
- ✓ Lever states (is_on)
- ✓ Laser states (active)
- Player position: NOT reset (not specified by user)

---

## Claude's Discretion

- Exact directional idle animation names (assumed idle_front / idle_back / idle_side)
- Whether player teleports on R press (defaulting to no)
- Fallback behavior when no RespawnPoint found in scene

## Deferred Ideas

None.

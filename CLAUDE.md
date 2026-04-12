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

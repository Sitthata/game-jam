---
status: awaiting_human_verify
trigger: "void-detection-not-triggering — _is_void_at_player() only called on timeline_swap input, not during normal movement"
created: 2026-04-21T00:00:00Z
updated: 2026-04-21T00:00:00Z
---

## Current Focus

hypothesis: _is_void_at_player() is never called during _physics_process, so walking onto void tiles has no effect
test: Read main.gd to confirm call sites
expecting: Confirmed — void check only inside _unhandled_input after timeline_swap
next_action: Add _physics_process to main.gd that calls _is_void_at_player() each frame

## Symptoms

expected: Player standing on void (empty/no-tile) area should trigger fall and respawn
actual: Player can stand and walk on void tiles with no consequence
errors: None
reproduction: Walk player into dark void area — nothing happens
started: The function exists but may never have triggered during walking

## Eliminated

- hypothesis: _is_void_at_player() logic is broken / returns wrong value
  evidence: Function reads TileMapLayer cell data and collision polygon count correctly; same pattern as the working _has_collision_at_player(). Logic is sound.
  timestamp: 2026-04-21

## Evidence

- timestamp: 2026-04-21
  checked: main.gd lines 14-23 (_unhandled_input)
  found: _is_void_at_player() is called exactly once — inside the timeline_swap branch of _unhandled_input, after the swap executes
  implication: Void detection only fires when the player presses Q; walking onto void never triggers it

- timestamp: 2026-04-21
  checked: main.gd — searched for any _process or _physics_process definition
  found: No _physics_process or _process function exists in main.gd
  implication: There is no per-frame hook in the scene root to call the void check during movement

- timestamp: 2026-04-21
  checked: player.gd _physics_process
  found: Movement, animation, and push logic only; no void awareness and no signal/callback back to main
  implication: The player script intentionally has no timeline knowledge; void check must live in main.gd

## Resolution

root_cause: _is_void_at_player() is called only inside _unhandled_input (on Q press). No _physics_process exists in main.gd, so the check never runs while the player walks. The function logic itself is correct.
fix: Add _physics_process to main.gd. Each frame, call _is_void_at_player(). If it returns true, call _do_fall_and_respawn(). Guard with an _is_falling flag to prevent repeated triggers mid-respawn.
verification: Player walks onto a void tile → falls and respawns. Player on solid tile → no respawn. Timeline swap onto void still triggers respawn (existing path unchanged).
files_changed: [game_object/script/main.gd]

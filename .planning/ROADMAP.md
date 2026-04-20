# Roadmap: Freezing Point

## Overview

Three phases to ship the jam submission by April 30. Phase 1 closes the mechanic gaps that block playable rooms. Phase 2 finishes the two unbuilt rooms. Phase 3 chains everything into a completable game and submits.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Core Mechanics Polish** - Finish the player mechanics required before rooms are playable
- [ ] **Phase 2: Rooms Completion** - Design and implement Puzzle Rooms 3 and 4
- [ ] **Phase 3: Final Polish & Submission** - Full game loop, bug fixes, jam upload

## Phase Details

### Phase 1: Core Mechanics Polish
**Goal**: Player mechanics are complete and correct so all rooms are playable without animation or gameplay bugs
**Depends on**: Nothing (first phase)
**Requirements**: ANIM-01, GAME-01, GAME-02
**Success Criteria** (what must be TRUE):
  1. Player standing still shows the correct directional idle frame matching their last movement direction (side/front/back)
  2. When a swap puts the player over a void tile, the fall animation plays and the player reappears at the nearest respawn marker
  3. Pressing the reset key restores the current puzzle room to its initial state and all interactive objects return to their starting positions
**Plans**: TBD

### Phase 2: Rooms Completion
**Goal**: Puzzle Rooms 3 and 4 are implemented, playable, and each contain at least one timeline-swap "aha" moment
**Depends on**: Phase 1
**Requirements**: ROOM-01, ROOM-02
**Success Criteria** (what must be TRUE):
  1. Puzzle Room 3 can be entered, solved, and exited without softlocking or crashing
  2. Puzzle Room 4 can be entered, solved, and exited without softlocking or crashing
  3. Both rooms use the timeline swap as the core solve mechanic — the puzzle cannot be completed without swapping
**Plans**: TBD

### Phase 3: Final Polish & Submission
**Goal**: All 4 rooms chain linearly and the game is completable from start to finish, ready to upload to the jam
**Depends on**: Phase 2
**Requirements**: POLISH-01
**Success Criteria** (what must be TRUE):
  1. A player can complete all 4 rooms in one continuous session with no crashes, freezes, or game-breaking bugs
  2. No softlocks exist — the reset mechanic resolves any stuck state in every room
  3. The build runs and the game is submitted to the jam platform before April 30
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Core Mechanics Polish | 0/TBD | Not started | - |
| 2. Rooms Completion | 0/TBD | Not started | - |
| 3. Final Polish & Submission | 0/TBD | Not started | - |

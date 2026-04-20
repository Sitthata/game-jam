# Requirements: Freezing Point

**Defined:** 2026-04-20
**Deadline:** 2026-04-30 (10 days)
**Core Value:** Timeline swap must feel responsive and deliver an "aha" moment in every room

## v1 Requirements (Must Ship)

### Animation

- [ ] **ANIM-01**: Player displays correct directional idle frame (side/front/back) when velocity is zero, based on last movement direction

### Gameplay

- [ ] **GAME-01**: When player swaps timeline and occupies a void/hazard tile, play "fall" animation, wait briefly, then teleport player to nearest Marker2D respawn point
- [ ] **GAME-02**: Player can press a key to reset the current puzzle room to its initial state when stuck

### Rooms

- [ ] **ROOM-01**: Puzzle Room 3 is implemented and playable (design owned by game designer)
- [ ] **ROOM-02**: Puzzle Room 4 is implemented and playable (design owned by game designer)

### Polish

- [ ] **POLISH-01**: All 4 rooms chain linearly — the full game loop is completable from start to finish without crashes or softlocks

## v2 Requirements (Could-Have, Post-Jam)

### Visual / Audio

- **VIS-01**: New laser texture for improved visual clarity
- **VIS-02**: Fog-of-war / limited vision effect
- **VIS-03**: Improved lighting system and dynamic shadows

### UX Screens

- **UX-01**: Title / start screen
- **UX-02**: Win / ending screen after Room 4 cleared
- **UX-03**: Credits screen
- **UX-04**: Sound effects
- **UX-05**: Background music

## Out of Scope

| Feature | Reason |
|---------|--------|
| New core mechanics | Scope lock — 10 days insufficient to add safely |
| Enemy / combat | Not part of game concept |
| Save system | Single-session jam game |
| Mobile / controller support | Not required for jam |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| ANIM-01 | Phase 1 | Pending |
| GAME-01 | Phase 1 | Pending |
| GAME-02 | Phase 1 | Pending |
| ROOM-01 | Phase 2 | Pending |
| ROOM-02 | Phase 2 | Pending |
| POLISH-01 | Phase 3 | Pending |

**Coverage:**
- v1 requirements: 6 total
- Mapped to phases: 6
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-20*
*Last updated: 2026-04-20 after roadmap creation — traceability confirmed*

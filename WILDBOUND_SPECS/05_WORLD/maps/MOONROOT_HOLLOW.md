---
spec_id: map.moonroot_hollow
version: 1.0.0
status: normative
depends_on:
  - world.alderwild
  - monster.crystal_beetle
  - monster.moonfang_cub
  - monster.moonfang_hunter
  - monster.root_wisp
  - monster.hollow_fawn
  - monster.the_hollow_stag
---

# Moonroot Hollow

## Contract

- ID `map.moonroot_hollow`; instanced dungeon; levels 8–20.
- Party 1–3; grids 9×9; expected duration 15–25 minutes.
- Checkpoints `hollow_entrance`, `stag_gate`.
- Three rooms + boss; daily bonus never required for core progression.

## Room sequence

### Crystal Vestibule

Teaches `Crystal` terrain with 2 `Crystal Beetle` and optional Cub. Puzzle rotates
crystal roots to open sight lines. Solo composition removes second Beetle.

### Pack Gallery

Teaches isolation using Cubs and `Moonfang Hunter`. Safe alcoves allow regrouping.
Memory panels summarize mechanics; no hidden trap deals immediate damage.

### Echo Garden

Introduces `Root Wisp` and `Hollow Fawn`. Decoys are explicitly labeled. Finishing
unlocks `stag_gate`, persistent for current dungeon session.

### Stag Chamber

Boss `The Hollow Stag`. Symmetrical 9×9 arena, four breakable crystal obstacles,
peripheral Thorns anchors and clear safe lanes.

## Matchmaking and scaling

Solo always offered. Queue prefers level, language and mentor preference. After
45 s, offer reduced-size start. Scaling is fixed at dungeon creation. A new
player cannot join after boss falls below 70 % Health.

## Rewards and lockouts

Normal loot on every completion. Daily bonus is additive and visible. Quest
rewards separate from boss drop. Checkpoints do not duplicate room rewards.

## Acceptance criteria

- Dungeon can be suspended at room boundary and resumed within 30 minutes.
- Replacing any non-boss encounter does not break door progression.
- Solo and trio expose the same core mechanic vocabulary.
- A failed boss attempt starts at `stag_gate` without replaying rooms.

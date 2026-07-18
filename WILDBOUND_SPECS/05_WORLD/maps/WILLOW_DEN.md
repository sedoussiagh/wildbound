---
spec_id: map.willow_den
version: 1.0.0
status: normative
depends_on:
  - system.dens
  - online.shared_world
---

# Willow Den

## Contract

- ID `map.willow_den`; private den; levels 1–20.
- Capacity owner + 7 visitors.
- Checkpoint `den_door`; no combat or resource spawn.
- Services decorate, visit, react and showcase.

## Base layout

12×10 placement grid, fixed 2×2 entrance safe zone, four wall surfaces and one
window. Initial theme `Willow Basic`. Expansions add rooms without moving existing
objects. The path validator guarantees a reachable free area from entrance.

## Instance lifecycle

Owner entry creates or wakes instance. Visitors join only under visibility rule.
When owner leaves, instance remains 5 minutes if visitors remain, then closes with
a polite notice. Unsaved editor changes remain local to owner and are not shown.

## Acceptance criteria

- 100 placed objects load within target performance budget.
- A visitor cannot inspect inventory, wallet or unpublished layout.
- Save conflict never overwrites a newer version silently.
- Owner can close visits instantly and all visitors return safely to hub.

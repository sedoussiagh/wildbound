---
spec_id: generation.prompts
version: 1.0.0
status: guidance
depends_on:
  - generation.brief
  - generation.implementation_roadmap
---

# Ready-to-use Prompts

## Generate the first vertical slice

> Read `WILDBOUND_SPECS/README.md`, the specification standard, Increment 1 of
> the implementation roadmap, Combat System, Wolf Guardian and Moss Slime.
> Generate only the offline battle proof. Preserve stable IDs and write one test
> per invariant/acceptance criterion. List every assumption instead of inventing
> missing production behavior. Return a traceability report.

## Generate an authoritative backend slice

> Read the DAT, Domain Model, API Contracts, Realtime Protocol, Security, Combat
> System and Increment 2. Implement guest bootstrap, one authoritative tutorial
> match, reconnect and idempotent reward claim. The client may send intents only.
> Add property/contract/integration tests and show how each maps to a spec ID.

## Implement one class/evolution

> Read the class file, selected evolution file, Class Catalog, Combat System and
> Evolution System. Generate data/domain/UI for this module only. Do not modify
> unrelated class values. Validate all skill formulas, targets, cooldowns,
> counters and acceptance criteria. Report balance assumptions separately.

## Add one monster

> Read Monster Catalog, the monster file, Combat System and the map that references
> it. Generate its content record, deterministic AI, telegraphs, loot contract and
> golden tests. Do not hard-code the monster into the map UI; bind through ID.

## Build a map

> Read the map file and every referenced monster/system dependency. Generate map
> data, transitions, spawn/encounter tables, checkpoints, accessibility metadata
> and validation tests. Missing art uses placeholders without changing collision.

## Review a generated implementation

> Compare the implementation against all declared `implements` spec records.
> Report missing acceptance criteria, invented behavior, authority violations,
> broken IDs, localization/accessibility gaps, unsafe economic mutations and
> absent reconnection states. Do not change code unless explicitly requested.

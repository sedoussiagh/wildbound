---
spec_id: technical.content_compilation
version: 1.0.0
status: normative
depends_on:
  - meta.specification_standard
  - meta.dependency_map
---

# Content Compilation

## Source and output

Markdown in this folder is editorial source. Production runtime SHOULD consume a
generated typed bundle, not parse prose at runtime. A compiler extracts front
matter, normative tables and explicitly structured fields, then validates links
and emits implementation-specific JSON/resources/code.

## Pipeline

1. Discover all `.md` files under this folder; root `README.md` and files under
   `99_TEMPLATES` are documentation/examples excluded from the runtime bundle.
2. Parse front matter and enforce unique `spec_id` for every non-template module.
3. Build dependency graph; reject missing IDs and cycles.
4. Extract content records with deterministic mapping rules.
5. Validate ranges, references, naming and invariants.
6. Run simulations and localization coverage.
7. Emit canonical ordered bundle.
8. Calculate SHA-256 manifest and sign release artifact.
9. Promote same artifact through environments.

## Canonical content records

### Class

ID, name, animal, role, difficulty, base stats, base skill IDs, evolution IDs,
identity action and balance boundaries.

### Skill

ID, owner class/evolution, AP, range, shape, targets, base power, scaling,
cooldown, Spirit cost, duration/effects, line of sight and tags.

### Monster

ID, family, role, level range, base stats, action definitions, AI policy, drops,
encounter budget and accessibility telegraphs.

### Map

ID, kind, level range, capacity, battle grid, checkpoints, monster IDs, features,
transitions and functional areas.

### Quest/item/recipe

IDs, prerequisites/references, ordered steps, rewards, binding, stack, inputs and
atomic behavior.

## Compiler diagnostics

Errors block release: duplicate ID, missing dependency, cycle, invalid reference,
unknown enum, impossible range, translated proper name, quest cycle, negative
reward, untradeable item in trade whitelist, boss without counterplay, `TBD` in
normative rule.

Warnings require review: orphan content, unused drop, low encounter coverage,
missing optional locale, balance outlier, deprecated reference.

## Determinism

Sort records by stable ID; normalize line endings and Unicode; exclude generated
timestamp from content hash. Same source and compiler version MUST produce same
bundle hash.

## Hot update rules

Text, non-functional visuals and safe server config may hot-update. Schema,
protocol, class ownership, quest topology or persisted item semantics require app
compatibility and migration. Active battle never switches balance bundle.

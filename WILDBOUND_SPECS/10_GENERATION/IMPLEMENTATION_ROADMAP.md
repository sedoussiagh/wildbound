---
spec_id: generation.implementation_roadmap
version: 1.0.0
status: normative
depends_on:
  - generation.brief
  - product.mvp_scope
---

# Implementation Roadmap

## Increment 0 — Specification compiler

Parse front matter, dependency DAG, links, IDs and normative diagnostics. Emit a
deterministic content bundle and manifest. Exit: same input produces same hash;
all current modules pass.

## Increment 1 — Offline combat proof

One `Wolf Guardian`, one `Moss Slime`, 7×7 grid, move, `Claw Strike`, enemy turn,
victory. Domain deterministic and UI accessible. No persistence/economy.

## Increment 2 — Authoritative vertical slice

Guest auth, bootstrap, create/join battle, authoritative action, reconnect, result,
single idempotent Moss Gel reward. Exit includes network fault matrix basics.

## Increment 3 — Hero and onboarding

Three class choices, appearance, `A Seed of Memory`, level/XP, charm, save/resume.
Class choice and names validated server-side.

## Increment 4 — Shared world

`Oakheart Village`, presence/interest, safe movement, friends/party/block, entrance
to `Whispering Woods`. Performance test at 50 avatars.

## Increment 5 — Core content

Six base kits, 10 non-boss monsters, woods encounters, progression to level 10,
quest flow and Brambleback. Balance/golden tests for all skills.

## Increment 6 — Evolution

Six evolution modules, preview sandbox, `The Wild Mirror`, atomic choice/respec,
Morphstone recipe. All branches complete solo reference encounter.

## Increment 7 — Den and safe social

`Willow Den`, editor/save/conflict, visits/reactions, guild basics, quick chat,
report/moderation console minimum. Free chat remains off until safety gates.

## Increment 8 — Dungeon and economy

`Moonroot Hollow`, Hollow Stag, loot/craft, direct trade escrow, ledger and full
main quest. Restore/reconciliation test.

## Increment 9 — Mobile beta hardening

Android/iOS device matrix, accessibility, localization, store sandbox, privacy
flows, load/soak, observability/runbooks and soft-launch readiness.

## Rule of advancement

Do not start a later increment to hide a failing exit criterion. A future system
may be represented by interface/feature flag but not by fake completed behavior.

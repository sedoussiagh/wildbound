---
spec_id: technical.qa_strategy
version: 1.0.0
status: normative
depends_on:
  - technical.nfr
  - technical.content_compilation
  - technical.security_privacy
---

# QA Strategy

## Test layers

- Static: Markdown/front matter, links, dependency DAG, content references.
- Unit: formulas, paths, skills, AI decisions, permissions.
- Property: combat determinism, legal grid, non-negative economy over many seeds.
- Contract: API/realtime schemas and N/N-1 compatibility.
- Integration: database, idempotency, races, escrow, reconnect.
- End-to-end: onboarding, quest, battle, evolution, den, trade, block/report.
- Load/soak: hubs, queues, matches, chat and 2-hour client session.
- Device/accessibility: minimum/mid/high Android and iOS matrix.

## P0 scenarios

Duplicate/lost asset, double action, changed trade after confirm, age/consent
bypass, ineffective block, duplicate reward, client-only purchase validation,
privacy deletion leak and unauthorized admin action.

## Combat golden tests

For each skill and monster action: initial state, command, expected ordered events,
state hash. Each boss tested solo with all six evolutions and with representative
duo/trio compositions. Target fair ranked branch win rate 47–53 % at comparable
skill, not used alone for balance decision.

## Network matrix

50/150/300/600 ms, jitter, 1–10 % loss, 5/20/40 s outage, Wi‑Fi/mobile switch,
background 5/30/120 s, duplicated and reordered messages.

## Content gates

Unique IDs, valid references, no dependency/quest/recipe cycle, proper names
unchanged, reachable rewards, boss counterplay, maps not orphaned, every state
localized and accessible.

## Definition of Done

Normative acceptance criteria pass; loading/empty/error/offline/reconnect covered;
telemetry documented; accessibility/localization reviewed; security and migration
impact addressed; rollback/kill switch documented where relevant.

---
spec_id: generation.brief
version: 1.0.0
status: normative
depends_on:
  - meta.specification_standard
  - technical.architecture
  - technical.qa_strategy
---

# Brief for Code-Generation Tools

## Mission

Generate an implementation increment of `Wildbound Realms` from this modular
specification while preserving domain boundaries and traceability.

## Mandatory behavior

1. Read `README.md` and `00_META/SPECIFICATION_STANDARD.md`.
2. Resolve the target module’s complete `depends_on` graph.
3. List assumptions and unresolved decisions before generation.
4. Never invent a production vendor, credential, legal conclusion or hidden
   gameplay rule.
5. Implement normative rules and acceptance criteria; mark examples as examples.
6. Keep IDs and English proper names exact.
7. Generate tests mapped to each acceptance criterion/invariant.
8. Produce traceability from generated component to `spec_id` and version.
9. Stop on dependency cycle, missing reference or normative `TBD`.

## Absolute constraints

- Server authoritative for combat, progression, economy, trade and safety.
- No pay-to-win, paid random loot, blocking energy or punitive streak.
- All economic mutations atomic, idempotent and auditable.
- Text localizable; proper names remain English.
- Loading, empty, error, offline and reconnection states are not optional.
- Block/report and age/consent are release gates for user-generated communication.

## Expected generated deliverables

- Architecture/module map.
- Data schemas and migrations.
- Domain logic isolated from framework.
- Client screens/read models/gateways.
- Server commands, validation, authoritative matches and audit.
- Unit/property/contract/integration/E2E tests.
- Seed content compiled from selected modules.
- Local environment and reproducible commands.
- Security/telemetry configuration without secrets.
- `TRACEABILITY.md` and unresolved decision report.

## Generation granularity

Generate one vertical slice at a time. A slice must cross UI → contract → domain →
persistence → test for a small outcome. Do not scaffold every future service before
the first playable loop.

## Completion response format

```text
Implemented specs and versions:
Generated components:
Acceptance criteria passed:
Tests executed:
Assumptions:
Unresolved/blocked decisions:
Migration and rollback:
Known non-normative placeholders:
```

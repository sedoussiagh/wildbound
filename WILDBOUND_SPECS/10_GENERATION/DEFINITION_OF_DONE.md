---
spec_id: generation.definition_of_done
version: 1.0.0
status: normative
depends_on:
  - technical.qa_strategy
  - generation.traceability
---

# Definition of Done

## Per module

- Correct `spec_id` and version traced.
- All dependencies resolved; no duplicated magic content IDs.
- Normative rules and acceptance criteria implemented.
- Unit/golden/contract tests appropriate to risk.
- Loading, empty, error, offline and reconnect where applicable.
- Text localizable; English proper names exact.
- Touch, keyboard/controller focus and accessibility reviewed.
- Telemetry allowlisted without personal data.
- Security/authority and abuse cases reviewed.
- Data migration and rollback documented if persisted state changes.
- Feature flag/kill switch where operational risk requires it.

## Per vertical slice

- Player outcome works end-to-end on target device.
- Server remains authority and repeated commands are safe.
- Content compiler and reference validation pass.
- Network interruption and background/resume tested.
- Performance budget measured, not assumed.
- Traceability report contains no unowned gap.

## Release-level gates

Zero open P0; moderated UGC gates complete; purchase validation and restore pass;
privacy export/delete tested; backups restored; dashboards/alerts/runbooks owned;
minimum device and accessibility matrices complete.

---
spec_id: generation.decisions_required
version: 1.0.0
status: normative
depends_on:
  - technical.architecture
  - online.safety_moderation
---

# Decisions Required Before Production

These do not block documentation or local prototype unless stated.

| Decision | Owner needed | Blocks |
|---|---|---|
| launch audience/category and age strategy | product + legal | free chat, stores |
| first countries and data regions | business + legal + ops | production infra |
| cloud/runtime provider and budget | engineering/finance | staging scale |
| account linking methods | product/security | cross-device release |
| moderation coverage/vendor | trust & safety | any free chat/UGC |
| analytics/crash vendor and consent | privacy/product | production telemetry |
| push provider and policy | product/privacy | notifications |
| art production/licensing policy | art/legal | final assets |
| store catalog, prices and refund support | monetization/legal | purchases |
| minimum Android/iOS device/OS | engineering/QA | release matrix |
| backup RPO/RTO production upgrade | ops/business | global launch |
| accessibility compliance target by region | product/legal/UX | store launch |

## Generator rule

For an undecided provider, generate an interface and local fake only. Do not
create a fake production integration, terms text or legal consent wording.

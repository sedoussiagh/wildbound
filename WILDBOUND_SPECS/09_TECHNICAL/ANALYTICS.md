---
spec_id: technical.analytics
version: 1.0.0
status: normative
depends_on:
  - technical.security_privacy
  - product.vision
---

# Analytics and Ethical Experimentation

## Principles

Collect only for documented question, whitelist fields, pseudonymous identity and
regional consent/opt-out. Never collect chat, email, free name, precise location
or child advertising identifier.

## Event envelope

Event name, schema version, server/client timestamp, pseudonymous account cohort,
platform, coarse region, client/protocol/content/balance versions and allowlisted
properties. Server emits authoritative completion and economy events.

## MVP event catalog

`session_started`, `onboarding_step_completed`, `hero_created`, `zone_entered`,
`combat_match_started`, `combat_action_submitted`, `combat_match_completed`,
`reward_claimed`, `loadout_changed`, `evolution_selected`, `den_saved`,
`party_joined`, `friendship_created`, `trade_completed`, `report_submitted`,
`purchase_completed`, `network_reconnected`.

## Product/health metrics

Activation, D1/D7/D30 return, chosen activity diversity, combat duration/win,
branch pick and win at comparable skill, social positive actions, blocks/reports,
faucets/sinks, crash-free, latency and reconnect.

## Experiments

Pre-register hypothesis, primary metric, duration and guardrails. Stable assignment
and kill switch. Forbidden: individualized pricing, hidden difficulty based on
spending, dark patterns, experiments increasing minors’ late-night play or making
safety controls harder to find.

## Acceptance criteria

- Every event has owner, purpose, retention and schema.
- Unknown properties are dropped server-side.
- Analytics failure never blocks gameplay transaction.
- Removal request covers analytics identity according to documented policy.

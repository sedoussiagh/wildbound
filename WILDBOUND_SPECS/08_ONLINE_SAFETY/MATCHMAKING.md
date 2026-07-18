---
spec_id: online.matchmaking
version: 1.0.0
status: normative
depends_on:
  - online.shared_world
  - system.combat
---

# Matchmaking

## PvE criteria

Region/latency, zone level, party size, preferred language and mentor preference.
Class composition is a soft diversity signal, never a hard tank/heal/damage rule.

## Queue stages

0–20 s exact preferences; 20–45 s widen level/ping safely; at 45 s offer start at
reduced party size with difficulty scaling; user may continue waiting. Bots/NPC
helpers are explicitly labeled.

## Friendly PvP

Direct consent only. Future ranked uses MMR uncertainty, region, latency and party
size. Rank is visible by tier; exact rating may remain private. New evolution
branches enter ranked only after observation and balance review.

## Ready and cancellation

Match found creates ready check. Timeout or decline returns others to front of
queue. Repeated declines may add a short cooldown, not a hidden penalty. Leaving
before match creation has no penalty.

## Invariants

- Age/privacy restrictions are evaluated before candidate pairing.
- Blocked accounts are not intentionally matched together.
- Difficulty scaling locks at match creation.
- Matchmaking never fabricates a human identity for a bot.

## Metrics

Queue p50/p95, widened searches, reduced-size acceptance, ready declines,
disconnects, rematches, skill spread and report rate by mode.

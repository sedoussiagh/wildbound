---
spec_id: technical.realtime_protocol
version: 1.0.0
status: normative
depends_on:
  - system.combat
  - online.shared_world
  - technical.api_contracts
---

# Realtime Protocol v1

## Transport

Authenticated WebSocket; JSON UTF-8 initially. Protobuf may replace encoding only
after measurement without changing semantic messages. Maximum normal action 1500
bytes; snapshot target ≤16 KB compressed.

## Opcodes

| Code | Direction | Name |
|---:|---|---|
| 1 | C→S | `ZONE_MOVE_INTENT` |
| 2 | S→C | `ZONE_PRESENCE_DELTA` |
| 3 | S→C | `ZONE_SNAPSHOT` |
| 10 | C→S | `BATTLE_READY` |
| 11 | S→C | `BATTLE_SNAPSHOT` |
| 12 | C→S | `BATTLE_ACTION` |
| 13 | S→C | `BATTLE_EVENTS` |
| 14 | C→S | `BATTLE_END_TURN` |
| 15 | S→C | `BATTLE_TURN_STARTED` |
| 16 | S→C | `BATTLE_FINISHED` |
| 17 | C→S | `BATTLE_RESUME` |
| 20 | S→C | `PARTY_UPDATE` |
| 21 | S→C | `SYSTEM_NOTICE` |

Codes are append-only. Published meaning never changes.

## Zone movement intent

Contains protocol, request ID, sequence, destination and client time. Maximum 10
Hz. Server validates speed, path and zone; delta returns authoritative position
and `last_processed_seq`. Client interpolates and corrects smoothly.

## Battle action

```json
{
  "protocol_version": 1,
  "match_id": "uuid",
  "client_action_id": "uuid",
  "expected_state_version": 17,
  "action": {
    "type": "use_skill",
    "actor_unit_id": "uuid",
    "skill_id": "skill.claw_strike",
    "target": {"x": 3, "y": 4}
  }
}
```

Action types: `move`, `use_skill`, `revive`, `end_turn`, `surrender`. Server
recalculates path, costs, target and result.

## Battle events

Ordered events: `unit_moved`, `resource_spent`, `damage_applied`, `heal_applied`,
`shield_changed`, `status_added`, `status_removed`, `tile_changed`, `unit_downed`,
`unit_revived`, `turn_ended`, `turn_started`, `phase_changed`. Response includes
strictly increasing state version and state hash.

## Snapshot

Match/map/content/balance versions, seed, round, turn/deadline, grid, units,
statuses, cooldowns, AP/MP/Spirit, telegraphs and 20 recent actions. It excludes
hidden information not authorized for recipient.

## Delivery rules

Messages may duplicate. Action ID makes commands idempotent. Client applies only
contiguous state versions; a gap requests snapshot. `BATTLE_FINISHED` is not proof
of economic claim. Unknown mandatory opcode causes version error; only explicitly
optional messages may be ignored.

## Rejection codes

`ACTION_OUT_OF_TURN`, `STALE_STATE`, `ILLEGAL_ACTOR`, `ILLEGAL_TARGET`,
`INSUFFICIENT_AP`, `INSUFFICIENT_MP`, `SKILL_ON_COOLDOWN`, `MATCH_FINISHED`,
`RATE_LIMITED`. Rejection changes no battle resource.

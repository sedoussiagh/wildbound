---
spec_id: technical.api_contracts
version: 1.0.0
status: normative
depends_on:
  - technical.domain_model
  - technical.security_privacy
---

# API Contracts

## Transport envelope

Authenticated HTTPS/RPC. Request metadata: `request_id`, `protocol_version`,
`client_version`, `content_version`. Response carries same request ID and server
time. Business text is represented by localization key, not trusted free text.

## Error envelope

```json
{
  "request_id": "uuid",
  "error": {
    "code": "VERSION_CONFLICT",
    "message_key": "error.version_conflict",
    "retryable": false,
    "details": {}
  }
}
```

Allowed common codes: `UNAUTHENTICATED`, `FORBIDDEN`, `VALIDATION_FAILED`,
`VERSION_CONFLICT`, `IDEMPOTENCY_CONFLICT`, `RATE_LIMITED`,
`CONTENT_VERSION_MISMATCH`, `PROTOCOL_VERSION_MISMATCH`, `MATCH_NOT_FOUND`,
`MATCH_ALREADY_REWARDED`, `INSUFFICIENT_ASSET`, `ITEM_BOUND`, `TRADE_CHANGED`,
`SOCIAL_RESTRICTED`, `MAINTENANCE`.

## Idempotency

Required for hero creation/evolution, craft, claims, trade confirmation, purchase,
den publish with item transfer and match reward. Client-generated UUID persists
until terminal response. Same key+same payload returns original result; same key+
different canonical payload returns `IDEMPOTENCY_CONFLICT`.

## Optimistic concurrency

`expected_version` required for hero/loadout, den, trade, guild settings and
profile. Conflict returns current safe snapshot and does not partially apply.

## Operations

| Operation | Mutation | Idempotent | Critical input |
|---|---|---|---|
| `bootstrap` | no | n/a | versions |
| `hero.create` | yes | yes | name, class, appearance |
| `hero.set_loadout` | yes | versioned | 4 skill IDs |
| `hero.evolve` | yes | yes | evolution, expected version |
| `hero.respec` | yes | yes | target, cost preview hash |
| `world.enter` | yes | retry-safe | map/checkpoint |
| `combat.create_pve` | yes | yes | encounter, party |
| `combat.claim_result` | yes | yes | match ID |
| `economy.craft` | yes | yes | recipe, quantity |
| `trade.propose` | yes | yes | target |
| `trade.offer` | yes | versioned | stacks |
| `trade.confirm` | yes | yes | offer hash/version |
| `den.save` | yes | versioned | placements/visibility |
| `moderation.block` | yes | retry-safe | subject |
| `moderation.report` | yes | yes | subject/category/context |
| `account.export` | yes | yes | authenticated account |
| `account.delete_request` | yes | yes | re-auth/confirmation |

## Pagination and rate limits

Opaque cursor; default 20, maximum 100; documented stable order. Expired cursor
returns `CURSOR_EXPIRED`. Rate-limit response includes retry-after, never reveals
security scoring. Mutation payloads have strict field allowlists and size limits.

## API acceptance criteria

- Unknown fields are rejected for sensitive mutations.
- No endpoint accepts account ID as proof of ownership.
- Sensitive responses use least data required.
- Logs use request ID but redact token, secrets and private message content.

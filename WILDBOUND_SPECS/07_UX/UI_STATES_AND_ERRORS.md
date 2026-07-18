---
spec_id: ux.states_errors
version: 1.0.0
status: normative
depends_on:
  - ux.accessibility
  - technical.api_contracts
---

# UI States and Errors

## Required states for network screens

`initial`, `loading`, `content`, `empty`, `offline`, `reconnecting`, `error`,
`conflict`, `success`. Loading longer than 8 seconds offers cancel or safe back.
Retry preserves user input unless security requires clearing it.

## Error presentation

Show localized message, stable short reference code and primary next action.
Never show stack trace, token, database text or raw server payload. Do not blame
the player for network or validation errors.

## Error categories

| Category | UX action |
|---|---|
| validation | highlight field, preserve others |
| unauthenticated | attempt refresh, then login |
| forbidden/social restricted | explain available alternatives |
| conflict | show current state and compare if possible |
| retryable network | exponential retry + manual retry |
| maintenance | status, expected update if known, exit |
| incompatible version | update action; no mutation attempt |

## Optimistic UI

Allowed for local selection, emote animation and unsaved den draft. Not allowed
for wallet, inventory, evolution, trade completion, quest claim or battle result.

## Acceptance criteria

- A request timeout does not imply failure if final result is unknown; client
  reconciles using idempotency key.
- Conflict never silently overwrites newer state.
- Offline state distinguishes cached read-only content from unavailable mutations.

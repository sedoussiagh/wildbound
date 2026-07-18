---
spec_id: technical.security_privacy
version: 1.0.0
status: normative
depends_on:
  - online.safety_moderation
  - system.economy_trade
---

# Security and Privacy

## Trust model

Mobile client, network, user-generated text and purchase callbacks are untrusted.
Server validates identity, authorization, state, sequence, content version and
limits. Never trust client time, position, damage, reward, ownership or receipt.

## Threats

Modified client, replay, race/duplication, botting, purchase fraud, account theft,
spam/harassment, trade scam, DDoS, admin abuse, leaked secret and compromised
dependency.

## Required controls

- TLS/WSS; short session + refresh; secure device storage.
- Server authorization on every mutation.
- Schema validation, allowlists, payload/rate limits.
- Idempotency, optimistic concurrency and transactions.
- Immutable economy/admin audit.
- Store receipt validation server-side before entitlement.
- Secrets vault, rotation, least privilege and environment separation.
- Signed builds, locked dependencies, SBOM and CI security scan.
- Admin MFA, RBAC, just-in-time access and immutable audit.

## Anti-cheat

Authoritative simulation; impossible-speed/action detection; economy anomaly and
collusion review; match replay from seed/action log. Heuristics create review,
not irreversible ban by themselves except immediate containment.

## Data minimization

Separate account, gameplay, analytics and moderation data. No precise location,
contact book or advertising ID required. Analytics never store chat, free names,
email or private message. Logs hash/pseudonymize user ID where direct ID is not
operationally necessary.

## Privacy lifecycle

Document purpose, legal basis/consent, retention, access and deletion for each
field. In-app export/correction/delete. Deletion uses grace period, cancels
public identity, anonymizes social content and preserves only scoped fraud/legal
facts. Legal requirements require regional counsel before launch.

## Incident priorities

SEV-1: large duplication/loss, compromise or user-safety danger. Contain through
kill switch, preserve evidence, communicate, reconcile ledger, rotate secrets,
restore and publish blameless postmortem.

## Security acceptance criteria

- Replaying any economic request cannot duplicate effect.
- User A cannot access user B’s den draft, messages or inventory by ID guessing.
- Block and sanctions are server-enforced.
- No token/secret appears in logs, analytics, crash report or client content.

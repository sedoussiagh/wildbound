---
spec_id: content.reward_rules
version: 1.0.0
status: normative
depends_on:
  - content.item_catalog
  - system.progression
---

# Reward Rules

## Reward sources

Quest claim, combat completion, discovery, journal milestone, crafting, event and
purchase validation. Each source type has a unique server-owned source ID.

## Resolution order

1. Validate source and eligibility.
2. Lock claim key `(account, source_type, source_id)`.
3. Resolve deterministic rewards and server-side random drops.
4. Apply wallet/inventory atomically.
5. Write ledger and claim record.
6. Return a receipt with before/after, without secret randomness state.

## Group eligibility

Present at start or joined before lock point, not AFK, at least one meaningful
action appropriate to class, and present or reconnectable at completion. Damage
alone is never the only criterion.

## Overflow

Currency respects hard cap and reports discarded overflow before claim if claim
can be delayed. Item overflow enters a seven-day reserve. Bound unique duplicate
becomes a documented non-premium substitute or is blocked before claim.

## Invariants

- One source produces at most one claim per account unless repeat policy says so.
- Client never supplies quantity or rarity awarded.
- Random drops record loot table version for audit.
- A purchase receipt cannot be used as a combat/quest claim key.

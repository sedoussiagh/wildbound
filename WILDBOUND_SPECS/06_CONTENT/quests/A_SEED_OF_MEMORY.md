---
spec_id: quest.a_seed_of_memory
version: 1.0.0
status: normative
depends_on:
  - content.quest_catalog
  - map.oakheart_village
  - monster.moss_slime
  - content.item_catalog
---

# A Seed of Memory

Main quest, level 1, no prerequisite, estimated 6 minutes.

## Steps

1. Talk to `Elder Rowan`; receive a provisional `Heartroot Charm` not yet owned.
2. Win guided combat against one `Moss Slime` with Split Bud disabled.
3. Equip the provisional `Heartroot Charm`.
4. Return to Rowan and claim.

## Rewards

30 `Paw Coins`; provisional charm becomes permanent
`equipment.starter_charm`. If already owned through migration, reward only coins.

## Recovery

If abandoned, provisional charm disappears. Disconnect in combat restarts the
guided fight; disconnect after victory resumes at equip step.

## Acceptance criteria

- Every class can win using only its two initially enabled skills.
- The charm cannot be traded or duplicated.
- Tutorial can be replayed later without rewards.

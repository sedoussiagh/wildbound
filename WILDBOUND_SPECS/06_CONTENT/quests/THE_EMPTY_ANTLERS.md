---
spec_id: quest.the_empty_antlers
version: 1.0.0
status: normative
depends_on:
  - content.quest_catalog
  - quest.roots_remember
  - monster.the_hollow_stag
  - map.oakheart_village
---

# The Empty Antlers

Main quest, minimum level 15, estimated 15 minutes after checkpoint.

## Steps

Defeat `The Hollow Stag`; view or skip the release scene; return to
`Elder Rowan`; inspect projection of the `Hollow Crown`.

## Rewards

One `Hollow Antler Arch`; one `Wild Mirror Fragment`; MVP story completion flag.

## Acceptance criteria

- Skipping cinematics still provides summary and quest credit.
- Boss and quest rewards use separate idempotent claims.
- Party members at different quest stages receive only eligible rewards.
- Completing the story never requires PvP, trade or free chat.

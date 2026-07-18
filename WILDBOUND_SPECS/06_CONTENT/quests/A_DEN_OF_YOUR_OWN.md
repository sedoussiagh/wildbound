---
spec_id: quest.a_den_of_your_own
version: 1.0.0
status: normative
depends_on:
  - content.quest_catalog
  - quest.whispers_in_moss
  - map.willow_den
---

# A Den of Your Own

Side/main-feature quest, minimum level 3, estimated 5 minutes.

## Steps

Talk to `Tock Rivergear`; visit own `Willow Den`; place any decoration; save the
layout. A loaned Moss Lamp is available if inventory has no decoration.

## Reward

One permanent `Moss Lamp`. Loaned copy is converted rather than duplicated.

## Acceptance criteria

- Undo, invalid placement and save are introduced.
- Leaving without save preserves a local draft but does not complete the quest.
- Den defaults to private.

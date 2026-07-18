---
spec_id: quest.the_wild_mirror
version: 1.0.0
status: normative
depends_on:
  - content.quest_catalog
  - quest.the_pack_we_make
  - monster.brambleback
  - system.evolution
---

# The Wild Mirror

Class quest, minimum level 10, estimated 12 minutes.

## Steps

Defeat `Brambleback`; inspect both evolution previews; complete a short sandbox
turn with each branch; choose one evolution; confirm after comparison.

## Rewards

Activate selected evolution; one `Wild Mirror Fragment`. The choice itself does
not consume the fragment.

## Safeguards

No default selection, no timer, and closing the screen preserves unchosen state.
First branch change remains free within the grace window defined by evolution.

## Acceptance criteria

- Both branches can be tested before choice.
- Retry of claim cannot activate two branches or duplicate fragment.
- Choice is blocked if class/evolution IDs are incompatible.

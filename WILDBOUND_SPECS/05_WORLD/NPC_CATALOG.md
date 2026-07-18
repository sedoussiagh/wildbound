---
spec_id: world.npc_catalog
version: 1.0.0
status: normative
depends_on:
  - world.alderwild
---

# NPC Catalog

## Elder Rowan

ID `npc.elder_rowan`; old deer; narrative guide. Patient, admits uncertainty,
never infantilizes. Gives `A Seed of Memory`, `The Wild Mirror` and main arc.
Location: `Rowan Square`; unavailable only during explicit story scenes.

## Pip Thimbletail

ID `npc.pip_thimbletail`; mouse tailor. Manages appearance preview and basic
cosmetics. Dialogue energetic, no pressure to buy. Every premium preview includes
price, ownership and all evolution silhouettes.

## Mara Mallow

ID `npc.mara_mallow`; rabbit herbalist. Teaches healing, `Alchemy` and resource
codex. Provides solo alternatives to cooperative puzzles.

## Brann Stonepaw

ID `npc.brann_stonepaw`; bear smith. Teaches equipment and `Woodwork`. Explains
normalization PvP and never calls low-rarity gear « useless ».

## Sable Quickwhisk

ID `npc.sable_quickwhisk`; fox explorer. Owns `Wild Journal`, map hints and mentor
mode. Gives clues rather than exact secret coordinates until assistance requested.

## Tock Rivergear

ID `npc.tock_rivergear`; otter inventor. Unlocks `Willow Den`, editor and
decoration crafting. Always offers an undo/recovery explanation.

## Vesper Moonwing

ID `npc.vesper_moonwing`; owl arena referee. Explains consent, normalization and
fair play. Starts duels only after both players confirm rules.

## Clover Nib

ID `npc.clover_nib`; squirrel trade operator. Explains binding, five-second
review and scam warnings in neutral language. Handles trade restrictions.

## NPC data contract

Each NPC requires ID, English name, animal, pronouns per locale, role, home map,
interaction services, dialogue states, quest references, availability rules,
accessibility label and fallback behavior if service is unavailable.

## Invariants

- Aucun service critique ne dépend d’une présence aléatoire du NPC.
- Le texte métier sensible provient du serveur ou d’une spec versionnée.
- Un NPC vendeur ne présente jamais un achat premium comme nécessaire.

---
spec_id: content.crafting_recipes
version: 1.0.0
status: normative
depends_on:
  - content.item_catalog
  - system.economy_trade
---

# Crafting Recipes

| Recipe ID | Profession | Inputs | Output | Unlock |
|---|---|---|---|---:|
| `recipe.moss_lamp` | Woodwork | 2 Moss Gel, 1 Soft Leaf | 1 Moss Lamp | 5 |
| `recipe.softleaf_rug` | Tailoring | 3 Soft Leaf, 1 Spore Dust | 1 Softleaf Rug | 5 |
| `recipe.bramble_trophy` | Woodwork | 1 Bramble Core, 2 Thorn Tusk, 2 Boar Hide | 1 Bramble Trophy | 10 |
| `recipe.hollow_antler_arch` | Woodwork | 1 Hollow Antler, 4 Hollow Bark, 2 Crystal Shard | 1 Hollow Antler Arch | 15 |
| `recipe.morphstone` | Alchemy | 5 Wild Mirror Fragment, 1 Heartroot Sap | 1 Morphstone | 10 |

## Transaction rules

Craft is immediate, deterministic and cannot fail. The server validates recipe
version, unlock, quantities, inventory capacity and idempotency, then consumes
all inputs and creates output in one transaction. Bound ingredient makes output
bound only when recipe explicitly says so; trophy and Morphstone recipes do.

## Acceptance criteria

- Preview lists exact post-craft balances and binding.
- Duplicate request returns original result without consuming again.
- Insufficient input changes nothing.
- Disabling a recipe does not remove already crafted objects.

---
spec_id: content.item_catalog
version: 1.0.0
status: normative
depends_on:
  - system.economy_trade
---

# Item Catalog

## Data contract

Each item defines stable ID, English display name, kind, rarity, stack limit,
tradeable, binding rule, acquisition sources, uses, sell value and deprecation
fallback. `bound=true` always overrides `tradeable`.

## Currencies

| ID | Name | Limit | Trade | Use |
|---|---|---:|---|---|
| `currency.paw_coins` | Paw Coins | 999999 | no | normal vendors/craft |
| `currency.leaf_tokens` | Leaf Tokens | 99999 | no | event cosmetics |

## Resources

| ID | Name | Rarity | Stack | Trade | Primary source/use |
|---|---|---|---:|---|---|
| `resource.moss_gel` | Moss Gel | common | 999 | yes | Moss Slime; lamps/alchemy |
| `resource.soft_leaf` | Soft Leaf | common | 999 | yes | woods; tailoring |
| `resource.spore_dust` | Spore Dust | fine | 999 | yes | Spore Pup; dyes/alchemy |
| `resource.bark_scale` | Bark Scale | common | 999 | yes | Bark Toad; woodwork |
| `resource.thorn_tusk` | Thorn Tusk | fine | 999 | yes | Thorn Boar; trophies |
| `resource.boar_hide` | Boar Hide | common | 999 | yes | Thorn Boar; tailoring |
| `resource.ash_feather` | Ash Feather | common | 999 | yes | Ashwing Crow; cosmetics |
| `resource.bramble_core` | Bramble Core | rare | 99 | no | Brambleback trophy |
| `resource.crystal_shard` | Crystal Shard | fine | 999 | yes | Crystal Beetle; lamps |
| `resource.moonfang_pelt` | Moonfang Pelt | fine | 999 | yes | Moonfang; tailoring |
| `resource.moon_dust` | Moon Dust | rare | 99 | yes | Hunter; advanced dyes |
| `resource.heartroot_sap` | Heartroot Sap | rare | 99 | no | Root Wisp; Morphstone |
| `resource.hollow_bark` | Hollow Bark | fine | 999 | yes | Hollow Fawn; den arch |
| `resource.hollow_antler` | Hollow Antler | rare trophy | 99 | no | Hollow Stag victory |
| `resource.wild_mirror_fragment` | Wild Mirror Fragment | rare evolution | 5 | no | boss/quests; Morphstone |

## Evolution item

`item.morphstone` / `Morphstone`: rare, stack 5, bound, non-tradeable. Allows one
branch switch through an atomic evolution transaction. No use from inventory
without opening the comparison/confirmation flow.

## Decorations

| ID | Name | Size | Category | Trade | Source |
|---|---|---:|---|---|---|
| `decor.moss_lamp` | Moss Lamp | 1×1 | lamp | yes | quest/craft |
| `decor.softleaf_rug` | Softleaf Rug | 2×2 | floor | yes | quest/craft |
| `decor.bramble_trophy` | Bramble Trophy | 2×1 | trophy | no | craft |
| `decor.hollow_antler_arch` | Hollow Antler Arch | 3×1 | trophy | no | quest/craft |

## Cosmetics and equipment

- `cosmetic.rowan_cape` / `Rowan Cape`: fine, one, bound, visual only.
- `cosmetic.moss_headband` / `Moss Headband`: fine, one, bound, visual only.
- `equipment.starter_charm` / `Heartroot Charm`: common, slot `Charm`, bound,
  `+5 Health`; unique per account, cannot trade.

## Invariants

- Item names remain English in every locale.
- A stack never exceeds its limit; overflow goes to temporary reserve.
- Premium purchases are always bound and non-tradeable.
- An unknown/deprecated item loads as a visible `Archived Item` record and is not
  silently deleted.

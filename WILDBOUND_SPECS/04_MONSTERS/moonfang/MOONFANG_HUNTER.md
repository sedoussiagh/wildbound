---
spec_id: monster.moonfang_hunter
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Moonfang Hunter

## Identity and stats

ID `monster.moonfang_hunter`; family `Moonfang`; assassin; levels 10–16; budget 2.
Health 85, Power 23, Guard 9, Speed 15, 3 AP, 4 MP.

## Actions

- **Lone Mark**: 1 AP, range 4, cooldown 2. Applique `Marked` uniquement à un
  héros sans allié adjacent.
- **Moon Leap**: 2 AP, range 3, cooldown 2. Saute adjacent à une cible marquée et
  inflige `20 + floor(Power × 0.75)`. Nécessite une case d’arrivée libre.
- **Hunter Bite**: 1 AP, melee, `13 + floor(Power × 0.65)`.

## AI

Recherche cible isolée, applique `Lone Mark`, puis `Moon Leap` au tour suivant.
Si le joueur rejoint un allié avant résolution, le mark reste mais Leap perd son
bonus de +20 % prévu et l’intention est mise à jour.

## Drops

`Moonfang Pelt` 75 % quantité 1–2 ; `Moon Dust` 25 % quantité 1.

## Acceptance criteria

- `Lone Mark` ne peut être lancé sur une cible non isolée.
- Se regrouper fournit un contre-jeu mesurable avant Leap.
- Aucune case d’arrivée valide annule l’action sans téléportation illégale.

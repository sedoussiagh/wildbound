---
spec_id: monster.moonfang_cub
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Moonfang Cub

## Identity and stats

ID `monster.moonfang_cub`; family `Moonfang`; pack; levels 8–14; budget 1.5.
Health 65, Power 17, Guard 8, Speed 12, 3 AP, 4 MP.

## Actions

- **Pack Bite**: 1 AP, melee, damage `12 + floor(Power × 0.6)`. Gagne +20 % si
  un autre `Moonfang` vivant est adjacent à la cible ; bonus non cumulable.
- **Circle**: règle de mouvement, préfère finir adjacent à un allié mais sur un
  côté différent de la cible.

## AI

Choisit d’abord une cible déjà menacée par un autre Moonfang. Si aucun bonus de
pack n’est possible, se repositionne plutôt que d’attaquer, sauf si la cible est
sous 25 % Health.

## Drops

`Moonfang Pelt` 45 %, quantité 1.

## Acceptance criteria

- Le bonus de pack est prévisualisé avant le déplacement final.
- Un seul allié suffit et plusieurs n’augmentent pas le bonus.
- L’IA ne passe pas son tour si une élimination légale est disponible.

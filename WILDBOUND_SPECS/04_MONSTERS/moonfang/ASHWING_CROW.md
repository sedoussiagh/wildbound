---
spec_id: monster.ashwing_crow
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Ashwing Crow

## Identity and stats

ID `monster.ashwing_crow`; family `Moonfang`; ranged attacker; levels 5–11;
encounter budget 1.5.
Health 52, Power 18, Guard 5, Speed 13, 3 AP, 4 MP.

## Actions

- **Wing Dart**: 1 AP, range 4, damage `11 + floor(Power × 0.6)`.
- **Ash Mark**: 1 AP, range 4, cooldown 2, applique `Marked` 2 tours. Si la cible
  est déjà `Marked`, l’action est illégale.
- **Flit**: mouvement passif ; peut traverser une case d’obstacle bas, mais pas y
  terminer.

## AI

Maintient 3–4 cases. Marque une cible non marquée si un autre allié peut
l’attaquer ce round ; sinon `Wing Dart`. Après attaque, utilise ses MP restants
pour s’éloigner sans entrer dans un terrain dangereux.

## Drops

`Ash Feather` 70 %, quantité 1–2.

## Acceptance criteria

- L’IA ne marque pas une cible qu’aucun allié ne peut menacer.
- `Flit` n’autorise jamais une fin de mouvement sur obstacle.
- Le marquage montre la prochaine source probable de dégâts sans révéler une
  information cachée.

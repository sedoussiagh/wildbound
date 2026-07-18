---
spec_id: monster.crystal_beetle
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Crystal Beetle

## Identity and stats

ID `monster.crystal_beetle`; family `Moonfang`; protector; levels 8–14; budget 2.
Health 105, Power 14, Guard 18, Speed 4, 3 AP, 2 MP.

## Actions

- **Crystal Shell**: 1 AP, self, cooldown 2. `+12 Guard` jusqu’au prochain tour et
  intercepte 30 % des dégâts directs du plus faible allié adjacent.
- **Prism Ram**: 2 AP, range 2 line, damage `15 + floor(Power × 0.6)`, push 1.
- **Mandible**: 1 AP, melee, damage `10 + floor(Power × 0.5)`.

## AI

Se place entre le héros le plus menaçant et l’allié au plus faible Health. Sur
case `Crystal`, privilégie `Crystal Shell`; sinon utilise `Prism Ram` si un push
vers un obstacle est possible.

## Drops

`Crystal Shard` 80 %, quantité 1–2.

## Acceptance criteria

- L’interception ne crée pas de boucle avec une autre redirection.
- Le lien protégé est visible.
- Détruire/remplacer le terrain `Crystal` retire seulement son bonus de terrain,
  pas `Crystal Shell`.

---
spec_id: monster.root_wisp
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Root Wisp

## Identity and stats

ID `monster.root_wisp`; family `Hollow`; controller; levels 9–16; budget 2.
Health 58, Power 16, Guard 6, Speed 11, 3 AP, 3 MP.

## Actions

- **Binding Root**: 2 AP, range 3, cooldown 3. Applique `Rooted` jusqu’à la fin du
  prochain tour de la cible après test Resolve. Les boss reçoivent seulement
  `Slowed`.
- **Memory Flicker**: 1 AP, range 4, damage `10 + floor(Power × 0.5)` et échange
  visuellement deux intentions ennemies factices ; les vraies cases dangereuses
  restent marquées et l’effet n’altère jamais les règles.

## AI

Root une cible pouvant sortir d’une zone de boss ou atteindre le Wisp. Ne Root
pas une unité avec `Control Guard` si une autre cible existe. Garde 3 cases.

## Drops

`Heartroot Sap` 35 %, quantité 1, lié au compte.

## Accessibility and safety

`Memory Flicker` crée du thème sans mentir : la cible réelle, les coûts et les
zones restent exacts. Une option réduit l’effet à une brève variation de couleur.

## Acceptance criteria

- Un contrôle dur déclenche `Control Guard` après résolution.
- L’effet visuel ne modifie aucune donnée ou sélection.
- La cible de `Binding Root` est visible un tour suffisamment tôt en combat boss.

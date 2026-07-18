---
spec_id: monster.moss_slime
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Moss Slime

## Identity

- ID `monster.moss_slime`; family `Mosskin`; role `basic`.
- Level range 1–4; encounter budget 1.
- Silhouette ronde verte, expressions lisibles, aucune viscosité réaliste.

## Base stats

Health 55, Power 12, Guard 4, Speed 6, 3 AP, 2 MP.

## Actions

- **Soft Bump**: 1 AP, range 1, damage `10 + floor(Power × 0.5)`.
- **Split Bud**: réaction unique quand Health passe pour la première fois à 50 %
  ou moins. Si moins de six ennemis sont présents, crée un `Moss Bud` adjacent :
  Health 20, Power 8, Guard 0, 1 AP, 2 MP, uniquement `Soft Bump`. Le parent ne
  perd pas de Health. Si aucune case n’est libre, la réaction est consommée.

## AI

Cherche la cible vivante la plus proche, se déplace par chemin le plus court puis
attaque si adjacent. Ne fuit pas et n’anticipe pas les terrains. Le tutoriel peut
désactiver `Split Bud` lors du premier combat.

## Drops

- `Moss Gel`: 100 %, quantité 1–2.
- `Soft Leaf`: 35 %, quantité 1.

## Encounter use

Premier adversaire pédagogique ; groupe de 2–3 avec `Spore Pup` pour enseigner
les priorités. Ne pas associer plus de quatre Slimes dans une rencontre mobile.

## Acceptance criteria

- `Split Bud` ne se déclenche qu’une fois, même après soin.
- Le spawn et sa case sont déterministes.
- Le combat tutoriel est gagnable sans évolution ni équipement.

---
spec_id: monster.bark_toad
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Bark Toad

## Identity and stats

ID `monster.bark_toad`; family `Mosskin`; skirmisher; levels 3–8; budget 1.5.
Health 70, Power 14, Guard 7, Speed 7, 3 AP, 3 MP.

## Actions

- **Bark Hop**: 1 AP, cooldown 2, saut jusqu’à 3 cases ; ignore unités et
  obstacles bas. À l’arrivée, les unités adjacentes subissent 6 dégâts fixes.
- **Tongue Push**: 2 AP, range 3 line, damage
  `12 + floor(Power × 0.5)`, push 1 si légal.
- **Bark Snap**: 1 AP, melee, damage `10 + floor(Power × 0.55)`.

## AI

Préfère `Tongue Push` si la cible peut entrer sur `Thorns` ou s’éloigner de ses
alliés. Sinon utilise `Bark Hop` pour atteindre une case adjacente à deux héros.
Évite de terminer sur terrain dangereux si une alternative égale existe.

## Drops

`Bark Scale` 75 %, quantité 1–2.

## Acceptance criteria

- Le télégraphe de `Bark Hop` affiche case et splash.
- `Tongue Push` inflige ses dégâts si le push échoue.
- Le saut déclenche seulement le terrain d’arrivée.

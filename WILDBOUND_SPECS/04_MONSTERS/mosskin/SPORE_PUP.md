---
spec_id: monster.spore_pup
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Spore Pup

## Identity and stats

ID `monster.spore_pup`; family `Mosskin`; support; levels 2–6; budget 1.
Health 48, Power 11, Guard 5, Speed 10, 3 AP, 3 MP.

## Actions

- **Nibble**: 1 AP, range 1, damage `8 + floor(Power × 0.45)`.
- **Friendly Spore**: 2 AP, range 3, cooldown 2. Cible l’allié au plus faible
  Health relatif et le soigne de `14 + floor(Power × 0.6)`, puis pose sous lui un
  `Healing Bloom` valeur 6 consommable par toute unité.

## AI

Si un allié est sous 70 % Health et dans portée après déplacement, utilise
`Friendly Spore`. Sinon garde 2–3 cases avec le héros le plus proche et utilise
`Nibble` uniquement si adjacent. Ne se soigne lui-même que s’il est le dernier.

## Drops

`Soft Leaf` 80 % quantité 1–2 ; `Spore Dust` 30 % quantité 1.

## Counterplay

Focus du support, occupation du bloom ou séparation de sa cible. L’intention
montre cible, soin prévu et case de bloom.

## Acceptance criteria

- L’IA choisit toujours le même allié en cas d’égalité via ID.
- Un héros peut consommer le bloom ennemi.
- Le soin ne dépasse pas max Health.

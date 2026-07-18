---
spec_id: monster.thorn_boar
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Thorn Boar

## Identity and stats

ID `monster.thorn_boar`; family `Mosskin`; charger; levels 4–10; budget 2.
Health 95, Power 17, Guard 10, Speed 8, 3 AP, 3 MP.

## Actions

- **Tusk Jab**: 1 AP, melee, damage `12 + floor(Power × 0.6)`.
- **Briar Charge**: charge télégraphiée. Tour A : choisit une ligne de 2–5 cases,
  affiche flèches et passe en `Braced` (+8 Guard). Tour B : avance jusqu’au bout
  ou premier obstacle. Première unité touchée subit
  `24 + floor(Power × 0.8)`, push 1, puis la charge s’arrête. Les cases traversées
  deviennent `Thorns` un tour. Cooldown 3 après résolution.

## AI

Choisit la ligne touchant le plus de héros, puis la cible au plus faible Guard.
N’utilise pas la charge si aucune ligne de deux cases n’est valide. Entre deux
charges, avance et attaque la cible la plus proche.

## Drops

`Thorn Tusk` 65 % quantité 1 ; `Boar Hide` 45 % quantité 1.

## Counterplay

Sortir de la ligne, bloquer avec obstacle invoqué, utiliser `Immovable` ou pousser
le Boar pendant sa préparation pour changer son alignement. Le télégraphe est
recalculé seulement si le Boar est déplacé.

## Acceptance criteria

- La charge ne pivote jamais au tour de résolution.
- Le premier obstacle ou unité arrête le Boar.
- Les `Thorns` montrent leur expiration avant mouvement.

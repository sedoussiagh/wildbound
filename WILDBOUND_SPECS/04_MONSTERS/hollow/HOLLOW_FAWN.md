---
spec_id: monster.hollow_fawn
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Hollow Fawn

## Identity and stats

ID `monster.hollow_fawn`; family `Hollow`; decoy; levels 10–17; budget 2.
Health 75, Power 18, Guard 8, Speed 14, 3 AP, 4 MP.

## Actions

- **False Trail**: 2 AP, cooldown 3. Crée un `Memory Decoy` sur une case libre à
  range 2. Le decoy a 1 Health, aucun tour, porte clairement l’icône `Decoy` et
  expire après 2 tours. Il bloque ciblage de case mais pas mouvement forcé.
- **Antler Spark**: 1 AP, range 3, damage `13 + floor(Power × 0.6)`.
- Détruire le decoy donne 5 Spirit au héros responsable, maximum une fois/tour.

## AI

Place le decoy sur une ligne de tir ou une case d’objectif, jamais sur l’unique
sortie sûre d’une mécanique de boss. Puis kite à range 3.

## Drops

`Hollow Bark` 55 %, quantité 1.

## Acceptance criteria

- Le decoy n’imite jamais l’identité d’un vrai joueur.
- Sa nature et sa durée sont toujours visibles.
- Il ne bloque aucune case sûre obligatoire.

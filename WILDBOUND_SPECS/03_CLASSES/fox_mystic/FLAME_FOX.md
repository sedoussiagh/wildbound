---
spec_id: evolution.flame_fox
version: 1.0.0
status: normative
depends_on:
  - class.fox_mystic
  - system.evolution
---

# Flame Fox

## Identity

- Evolution ID : `evolution.flame_fox`
- Display name : `Flame Fox`
- Advanced form : `Ember Sage`, post-MVP
- Specialty : area damage and persistent fire

## Evolution skills

### Foxfire Ring

- ID `skill.foxfire_ring`; 2 AP; range 3; radius 1; cooldown 3.
- Damage each enemy `20 + floor(Power × 0.7)`.
- Les alliés sont ignorés ; le centre peut être vide.

### Ember Trail

- ID `skill.ember_trail`; 2 AP; range 3 line; cooldown 3.
- Jusqu’à trois cases deviennent `Burning`; toute unité déjà dessus subit
  `6 + floor(Power × 0.3)` avant pose.
- Un obstacle haut arrête la ligne.

### Wildfire — Ultimate

- ID `skill.wildfire`; 0 AP; 100 Spirit; range 4; square 3×3; once per battle.
- Damage `24 + floor(Power × 0.8)` to enemies, puis pose `Burning` valeur 10
  pendant 2 tours sur les cases libres de la zone.
- Les alliés ne prennent pas le hit mais subissent ensuite le terrain normal.

## Strengths and counters

Forte contre groupes statiques et zones étroites. Faible si l’ennemi se disperse,
remplace le terrain ou force le Fox à bouger. La branche ne possède aucun root :
elle dépend des alliés ou de la géométrie pour retenir les cibles.

## Acceptance criteria

- `Wildfire` distingue clairement impact instantané et cases dangereuses futures.
- Les terrains alliés peuvent blesser les alliés après le cast.
- `Ember Trail` s’arrête au premier obstacle haut.
- Aucun effet de feu ne se cumule au-delà de la valeur/durée la plus forte.

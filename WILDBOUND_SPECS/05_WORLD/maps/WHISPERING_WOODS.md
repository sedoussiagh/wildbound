---
spec_id: map.whispering_woods
version: 1.0.0
status: normative
depends_on:
  - world.alderwild
  - system.exploration
  - monster.moss_slime
  - monster.spore_pup
  - monster.bark_toad
  - monster.thorn_boar
  - monster.ashwing_crow
  - monster.brambleback
---

# Whispering Woods

## Contract

- ID `map.whispering_woods`; adventure zone; levels 1–12.
- Capacity 30 players; battle grids 7×7, boss 9×9.
- Checkpoints `softleaf_gate`, `mossbell_pond`.
- Features gathering, secrets, `Fissure Event`, `Mentor Scale`.

## Subzones

1. `Softleaf Trail` — safe introduction, Moss Slime and Soft Leaf.
2. `Briar Crossing` — narrow paths, Bark Toad and Thorn Boar.
3. `Mossbell Pond` — checkpoint, Spore Pup, gathering and social rest.
4. `Old Burrow` — Ashwing Crow, hidden journal entries.
5. `Bramble Clearing` — instanced boss entrance.

## Encounter progression

| Tier | Composition examples | New lesson |
|---|---|---|
| 1 | 1–2 Moss Slime | movement, attack |
| 2 | 2 Slime + Spore Pup | target priority, healing terrain |
| 3 | Bark Toad + Slime | push and jump |
| 4 | Thorn Boar + Spore Pup | telegraph and safe lane |
| 5 | Ashwing Crow + Toad | range and mark |
| boss | Brambleback | multi-turn telegraph |

## Exploration content

Personal nodes: moss, soft leaves and bark. Three puzzles: bell-spore sequence,
leaf bridge weights, reflected fireflies. Ten `Wild Journal` entries have at
least two discovery clues. `Fissure Event` opens 10 minutes but creates personal
group instances, not a shared damage race.

## Spawn and recovery

Monsters are visible; contact opens encounter preview. Defeat returns to nearest
checkpoint. Leaving a group battle instance returns each player to their prior
adventure instance or a compatible replacement.

## Acceptance criteria

- Level 1 player cannot wander directly into a level 10 encounter without warning.
- Each subzone has one route accessible without precision movement.
- All six monsters can be disabled independently through content configuration.
- Removing a monster leaves at least one valid encounter per progression tier.

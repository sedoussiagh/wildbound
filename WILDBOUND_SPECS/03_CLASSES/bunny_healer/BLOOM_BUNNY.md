---
spec_id: evolution.bloom_bunny
version: 1.0.0
status: normative
depends_on:
  - class.bunny_healer
  - system.evolution
---

# Bloom Bunny

## Identity

- Evolution ID : `evolution.bloom_bunny`
- Display name : `Bloom Bunny`
- Advanced form : `Rose Warden`, post-MVP
- Specialty : area sustain and healing terrain

## Evolution skills

### Petal Shelter

- ID `skill.petal_shelter`; 2 AP; range 3; radius 1; cooldown 3.
- Heal each ally `16 + floor(Power × 0.55)`.
- Maximum trois cibles ; le lanceur peut être inclus.

### Seed of Hope

- ID `skill.seed_of_hope`; 2 AP; range 4; single tile; cooldown 3.
- Pose `Healing Bloom` valeur `10 + floor(Power × 0.4)` pendant 2 tours.
- La première unité, alliée ou ennemie, qui finit son tour dessus consomme le
  terrain et reçoit le soin.

### Spring Chorus — Ultimate

- ID `skill.spring_chorus`; 0 AP; 100 Spirit; all allies; once per battle.
- Instant heal `28 + floor(Power × 0.8)`, puis heal-over-time 10 au début des
  deux prochains tours de chaque cible vivante.
- Ne cible pas les unités `Downed`.

## Strengths and counters

Forte contre dégâts progressifs et équipe groupée. Faible face au burst, à la
dispersion et à l’occupation ennemie des blooms. Elle contrôle peu la position.

## Acceptance criteria

- `Seed of Hope` peut être consommé par un ennemi et l’UI l’annonce.
- `Petal Shelter` respecte le maximum de trois cibles.
- `Spring Chorus` ne relève pas et ne dépasse pas max Health.
- Les ticks de soin restent idempotents après reconnexion.

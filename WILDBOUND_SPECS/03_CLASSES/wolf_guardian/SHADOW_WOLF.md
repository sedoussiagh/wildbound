---
spec_id: evolution.shadow_wolf
version: 1.0.0
status: normative
depends_on:
  - class.wolf_guardian
  - system.evolution
---

# Shadow Wolf

## Identity

- Evolution ID : `evolution.shadow_wolf`
- Display name : `Shadow Wolf`
- Advanced form : `Dusk Alpha` at level 30, post-MVP
- Specialty : mobile interception and counterattack

## Gameplay promise

`Shadow Wolf` protège en menaçant l’attaquant et en changeant rapidement de
front. Il perd la couverture de zone d’`Iron Wolf` et demande davantage
d’anticipation.

## Evolution skills

### Night Pounce

- ID : `skill.night_pounce`
- 2 AP, range 3, single enemy, cooldown 2.
- Dash to nearest legal adjacent tile, then damage
  `18 + floor(Power × 0.7)`.
- Si aucune case adjacente légale n’existe au cast, la compétence est illégale.
- Ignore les unités alliées sur le trajet, pas les obstacles hauts.

### Moon Counter

- ID : `skill.moon_counter`
- 2 AP, self, cooldown 3.
- Jusqu’au prochain tour, la première attaque directe à range ≤2 déclenche une
  riposte de `16 + floor(Power × 0.6)` après réception des dégâts.
- Pas de riposte si le Wolf est `Downed`; pas de chaîne de counters.

### Dusk Hunt — Ultimate

- ID : `skill.dusk_hunt`
- 0 AP, 100 Spirit, range 4, single enemy, once per battle.
- Damage : `42 + floor(Power × 1.1)`.
- Après résolution, `Hidden` pendant 1 tour si le Wolf n’est pas adjacent à un
  autre ennemi vivant.
- Ne téléporte pas et requiert ligne de vue.

## Recommended loadouts

- Interceptor : `Howl Guard`, `Guard Step`, `Night Pounce`, `Moon Counter`.
- Hunter : `Pack Pull`, `Claw Strike`, `Night Pounce`, `Shared Hide`.

## Counters and limits

Réponses : bait du counter avec faible attaque, contrôle de case d’arrivée,
terrain et attaque à plus de deux cases. `Dusk Hunt` est un finisher mais ne doit
pas éliminer seul une unité équivalente à pleine Health.

## Acceptance criteria

- La case d’arrivée de `Night Pounce` est affichée avant confirmation.
- `Moon Counter` se consomme sur la première attaque directe légale seulement.
- Un terrain ne déclenche pas le counter.
- `Hidden` de `Dusk Hunt` n’est pas appliqué si un ennemi reste adjacent.

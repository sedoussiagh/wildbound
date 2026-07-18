---
spec_id: evolution.iron_wolf
version: 1.0.0
status: normative
depends_on:
  - class.wolf_guardian
  - system.evolution
---

# Iron Wolf

## Identity

- Evolution ID : `evolution.iron_wolf`
- Display name : `Iron Wolf`
- Unlock : level 10 via `The Wild Mirror`
- Advanced form : `Iron Alpha` at level 30, post-MVP
- Specialty : zone protection and forced-movement denial

## Gameplay promise

`Iron Wolf` tient un point et protège plusieurs alliés. Il est très lisible et
résistant, mais lent et vulnérable aux attaques qui ignorent le placement ou
épuisent ses cooldowns.

## Evolution skills

### Steel Wall

- ID : `skill.steel_wall`
- 2 AP, range 1, radius 1 around target tile, cooldown 3.
- Each ally in area receives shield
  `16 + floor(Power × 0.5)` for 2 owner turns.
- Une unité déplacée hors de la zone conserve son bouclier.
- Maximum trois cibles ; preview indique les valeurs individuelles.

### Anchor Paw

- ID : `skill.anchor_paw`
- 1 AP, self, cooldown 3.
- Applies `Immovable` and `+12 Guard` until next turn.
- Ne bloque pas téléportation volontaire mais interdit push, pull et swap ennemi.
- Le cast après déplacement est autorisé.

### Unbroken Pack — Ultimate

- ID : `skill.unbroken_pack`
- 0 AP, 100 Spirit, all living allies, once per battle.
- Shield : `30 + floor(Power × 0.8)` for 2 target turns.
- Les alliés `Downed` ne sont ni relevés ni ciblés.
- L’ultime ne cumule pas avec une seconde instance de lui-même.

## Recommended loadouts

- Fortress : `Howl Guard`, `Challenge Roar`, `Steel Wall`, `Anchor Paw`.
- Escort : `Shared Hide`, `Guard Step`, `Steel Wall`, `Claw Strike`.

## Counters and limits

Réponses : dispersion, attaques à distance, expiration des boucliers, dégâts de
terrain non redirigés. La branche ne doit pas gagner par temporisation seule :
ses dégâts restent bas et les boucliers ont des fenêtres visibles.

## Acceptance criteria

- `Steel Wall` ne cible jamais plus de trois alliés.
- `Anchor Paw` refuse tous les déplacements forcés pendant sa durée.
- `Unbroken Pack` ne relève pas un allié et n’accorde Spirit à personne.
- Un écran compare clairement résistance supérieure et mobilité inférieure à
  `Shadow Wolf`.

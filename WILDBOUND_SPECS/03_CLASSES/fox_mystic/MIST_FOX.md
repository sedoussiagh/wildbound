---
spec_id: evolution.mist_fox
version: 1.0.0
status: normative
depends_on:
  - class.fox_mystic
  - system.evolution
---

# Mist Fox

## Identity

- Evolution ID : `evolution.mist_fox`
- Display name : `Mist Fox`
- Advanced form : `Gloom Sage`, post-MVP
- Specialty : vision control, reposition and marks

## Evolution skills

### Veil Mist

- ID `skill.veil_mist`; 2 AP; range 4; radius 1; cooldown 3.
- Pose `Mist` 2 tours ; les ennemis présents reçoivent `Slowed` 1 tour.
- Le slow est testé une fois au cast, pas à chaque entrée.

### Phantom Trail

- ID `skill.phantom_trail`; 2 AP; teleport up to 3; cooldown 3.
- Téléporte le Fox et pose `Mist` sur case de départ et d’arrivée pendant 1 tour.
- Les deux cases doivent être valides ; la case d’arrivée libre.

### Gloom Theatre — Ultimate

- ID `skill.gloom_theatre`; 0 AP; 100 Spirit; all enemies; once per battle.
- Damage `12 + floor(Power × 0.5)`, applique `Marked` 2 tours et `Slowed` au
  prochain tour.
- Ignore la ligne de vue, mais pas immunité de boss aux contrôles.

## Strengths and counters

Excellent pour réduire la portée et créer une fenêtre de focus. Faible en dégâts
bruts et contre révélation, cleanse ou ennemis déjà proches. `Mist` affecte aussi
les alliés et le lanceur : la maîtrise vient du placement.

## Acceptance criteria

- La preview de `Phantom Trail` montre les deux terrains.
- Entrer après le cast dans `Veil Mist` n’applique pas de nouveau slow.
- `Gloom Theatre` ne révèle pas un ennemi `Hidden` par lui-même.
- La comparaison d’évolution présente contrôle supérieur, dégâts inférieurs à
  `Flame Fox`.

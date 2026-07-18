---
spec_id: evolution.gale_bunny
version: 1.0.0
status: normative
depends_on:
  - class.bunny_healer
  - system.evolution
---

# Gale Bunny

## Identity

- Evolution ID : `evolution.gale_bunny`
- Display name : `Gale Bunny`
- Advanced form : `Storm Hare`, post-MVP
- Specialty : tempo, movement and ally rescue

## Evolution skills

### Tailwind

- ID `skill.tailwind`; 2 AP; range 4; ally/self; cooldown 2.
- `+2 MP` au prochain tour de la cible.
- Ne se cumule pas avec `Lucky Foot`; seule la valeur la plus élevée s’applique.

### Flash Relay

- ID `skill.flash_relay`; 2 AP; range 4; single ally; cooldown 3.
- Échange les positions si les deux cases sont légales pour leurs occupants.
- La cible reçoit `+1 AP` à son prochain tour, sans dépasser 4 AP.
- Interdit si l’une des unités est `Rooted` ou `Immovable` par un ennemi.

### Storm Parade — Ultimate

- ID `skill.storm_parade`; 0 AP; 100 Spirit; all allies; once per battle.
- Shield `12 + floor(Power × 0.4)` for 1 turn and `+2 MP` next turn.
- Ne modifie pas immédiatement l’ordre de tour.

## Strengths and counters

Sauve une cible mal placée et accélère les objectifs de plateau. Soins bruts plus
faibles que `Bloom Bunny`; vulnérable aux roots, espaces bloqués et burst.

## Acceptance criteria

- `Flash Relay` est refusé sans consommation si une destination devient illégale.
- Les effets d’entrée de terrain se résolvent pour les deux unités après swap.
- L’AP bonus ne dépasse jamais 4.
- `Storm Parade` n’accorde aucun tour supplémentaire.

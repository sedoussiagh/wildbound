---
spec_id: monster.catalog
version: 1.0.0
status: normative
depends_on:
  - system.combat
  - system.exploration
---

# Monster Catalog

## Familles MVP

| Family | Theme | Combat language | Members |
|---|---|---|---|
| `Mosskin` | forêt vivante altérée | push, spores, thorns, charge | 6 |
| `Moonfang` | prédateurs de nuit/cristal | pack, mark, armor, range | 4 |
| `Hollow` | souvenirs corrompus | root, decoy, board control | 2 |

## Règles communes

- Les monstres ne sont ni capturés ni jouables.
- L’intention de leur prochaine action est visible avant la décision du joueur.
- L’IA est déterministe à seed, état et tour identiques.
- Priorités : action obligatoire de phase → survie tactique → capacité identitaire
  → attaque de base → déplacement utile → guard.
- Un monstre ne lit pas une action client non encore validée.
- Toute égalité de cible est départagée par distance, Health relatif, puis ID.

## Scaling de niveau

Les stats indiquées dans chaque fichier sont celles du niveau minimum. Pour
chaque niveau supplémentaire dans la plage :

```text
Health = floor(base_health × (1 + 0.09 × delta_level))
Power  = base_power + floor(1.3 × delta_level)
Guard  = base_guard + floor(0.8 × delta_level)
Speed  = base_speed
```

Un boss applique ensuite le scaling de taille de groupe du système de combat.
Les compétences utilisent `monster.Power` sauf valeur fixe explicitement dite.

## Encounter budget

| Rôle | Budget |
|---|---:|
| basic/support | 1 |
| ranged/skirmisher/pack | 1.5 |
| charger/protector/controller/decoy | 2 |
| elite | 3 |
| boss | rencontre dédiée |

Budget cible : solo facile 2–3, solo standard 4, trio standard 8–10. Un combat
d’onboarding ne contient qu’une mécanique nouvelle à la fois.

## Drops

Les chances sont tirées individuellement par joueur éligible, une fois à la fin.
`chance=1.0` garantit le drop. Une plage min/max est uniforme sauf table spéciale.
Le client affiche chances et conditions, mais le serveur effectue le tirage.

## Invariants

- Une capacité majeure possède télégraphe et contre-jeu.
- Aucun monstre normal ne retire plus d’un tour complet par contrôle.
- Un spawn n’excède jamais le plafond d’unités de la rencontre.
- Le loot ne dépend jamais d’un résultat déclaré par le client.

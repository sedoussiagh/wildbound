# Combat Content POC

Ce document décrit le contenu réellement implémenté par le POC. Les noms de
classes, monstres, sorts et arènes sont en anglais ; les descriptions UI peuvent
être localisées. Les ressources `.tres` restent la source de données éditable.

## Règles du prototype

- Grille isométrique `9 × 9`, sans chiffre dessiné dans les cases.
- Une unité vivante par case ; déplacement cardinal, distance de Manhattan.
- Le joueur commence avec `3 PA`, `3 PM` et 30 secondes par tour.
- Un sort est exécuté dès que son icône puis un Slime valide sont touchés.
- Les Slimes jouent l'un après l'autre, avec `1 PA` et `2 PM` dans ce POC.
- Le combat se termine quand tous les Slimes sont vaincus.
- Changer de personnage remet le combat à zéro, mais conserve layout et groupe.

## Personnages et sorts

### Wolf Guardian

| Spell | PA | Range | Target | Power | Scaling |
|---|---:|---:|---|---:|---:|
| `Claw Strike` | 1 | 1 | single | 20 | 0.80 |
| `Guard Break` | 2 | 1 | single | 32 | 0.90 |
| `Wild Roar` | 3 | 2 | area radius 1, max 3 | 16 | 0.55 |

### Fox Mystic

| Spell | PA | Range | Target | Power | Scaling |
|---|---:|---:|---|---:|---:|
| `Spark Bolt` | 1 | 4 | single, line of sight | 18 | 0.75 |
| `Ember Arc` | 2 | 4 | area radius 1, max 3, line of sight | 14 | 0.55 |
| `Starfall` | 3 | 5 | area radius 1, max 3, line of sight | 27 | 0.80 |

Formule : `floor((power + floor(attacker.Power × scaling)) × 100 / (100 + Guard))`, minimum 1.

## Moss Slime

- `55 HP`, `12 Power`, `4 Guard`, `1 PA`, `2 PM` dans le POC.
- `Soft Bump` : portée 1, puissance 10, scaling 0.50.
- Trois rencontres visibles : `moss_slime_woods` (1),
  `moss_slime_creek` (2), `moss_slime_ruins` (3).
- Chaque groupe réapparaît après la victoire.

## Arènes modulaires

| Resource | Display name | Obstacles | Enemy spawns |
|---|---|---:|---:|
| `moonlit_crossing.tres` | `Moonlit Crossing` | 4 | 3 |
| `moss_ring.tres` | `Moss Ring` | 4 | 3 |
| `broken_path.tres` | `Broken Path` | 5 | 3 |
| `twin_groves.tres` | `Twin Groves` | 6 | 3 |

Au lancement, une seed choisit une ressource d'arène. La taille de groupe vient
de la rencontre open world ; hors open world, elle est choisie entre 1 et 3.
Même seed + mêmes actions produit le même combat.

## Extension unitaire

- Nouveau sort : créer une ressource avec le script `SkillDefinition`, puis
  l'ajouter à la liste `Skills` de la ressource de classe.
- Nouvelle arène : créer une ressource avec `ArenaDefinition`, fournir trois
  spawns ennemis et l'ajouter à `CombatState.ARENAS`.
- Nouvelle rencontre : ajouter un `Marker2D` dans `world_canvas.tscn`, sa taille
  dans `BattlePoc.ENCOUNTER_GROUP_SIZES`, puis son interaction dans `WorldPoc`.

Ces six sorts constituent un kit POC orienté dégâts. Les kits normatifs plus
riches de `WILDBOUND_SPECS/03_CLASSES` restent la cible de production.

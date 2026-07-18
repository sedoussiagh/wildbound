# POC Traceability

| Spec | Version | Composant généré | Couverture |
|---|---:|---|---|
| `generation.implementation_roadmap` | 1.0.0 | `scenes/poc/battle_poc.tscn` | Increment 1 jouable |
| `system.combat` | 1.0.0 | `scripts/combat/combat_state.gd` | grille 7×7, AP/MP, Manhattan, dégâts déterministes, tours |
| `class.wolf_guardian` | 1.0.0 | `scripts/combat/combat_state.gd` | statistiques niveau 1 et `Claw Strike` |
| `monster.moss_slime` | 1.0.0 | `scripts/combat/combat_state.gd` | statistiques, `Soft Bump`, déplacement vers la cible |
| `ux.mobile_controls` | 1.0.0 | `scripts/poc/battle_poc.gd` | paysage 1280×720, tap, preview, confirmation, boutons 56 px et icônes |
| `ux.accessibility` | 1.0.0 | `scripts/poc/battle_board.gd` | coordonnées, labels M/A, texte + couleur, clavier |
| `world.art_audio_direction` | 1.0.0 | `assets/`, `scripts/poc/battle_board.gd` | illustration fantasy lisible, profondeur 2.5D, silhouettes et feedback visuel |

## Visual implementation

- `assets/backgrounds/whispering_woods_arena_v1.png` : décor d’arène original.
- `assets/characters/wolf_guardian_v1.png` : sprite alpha du héros.
- `assets/characters/moss_slime_v1.png` : sprite alpha du monstre.
- `assets/characters/wolf_guardian/` : quatre poses de marche et quatre poses de
  `Claw Strike`.
- `assets/characters/moss_slime/` : quatre poses de bond et quatre poses de
  `Soft Bump`.
- `assets/ui/icons/` : icônes des six actions du POC, séparées des textes localisés.
- `scripts/poc/battle_board.gd` : projection isométrique, profondeur, ombres,
  grille fusionnée au terrain, particules et animations déterministes par poses.
- `tests/test_visual_smoke.gd` : déplacement, tour ennemi, impacts et victoire.

## Assumptions

- Le combat est le premier tutoriel : `Split Bud` est désactivé conformément à
  `monster.moss_slime`.
- Les deux cases rocheuses servent uniquement à valider le pathfinding ; elles
  sont des obstacles hauts sans mécanique de ligne de vue dans ce POC.
- Le domaine hors ligne préfigure l’autorité serveur mais n’est pas une autorité
  de production. Le réseau commence seulement à l’Increment 2.

## Acceptance checks

- Une action illégale ne modifie ni position ni ressource.
- Les dégâts publics correspondent exactement à la formule normative.
- Même état initial + même action = même position et mêmes événements ennemis.
- Deux unités ne terminent pas sur la même case.
- AP, MP et Health sont bornés à zéro.

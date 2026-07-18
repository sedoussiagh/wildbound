# POC Traceability

| Spec | Version | Composant généré | Couverture |
|---|---:|---|---|
| `generation.implementation_roadmap` | 1.0.0 | `scenes/poc/battle_poc.tscn` | Increment 1 jouable |
| `system.combat` | 1.0.0 | `scripts/combat/combat_state.gd` | grille 7×7, AP/MP, Manhattan, dégâts déterministes, tours |
| `class.wolf_guardian` | 1.0.0 | `scripts/combat/combat_state.gd` | statistiques niveau 1 et `Claw Strike` |
| `class.fox_mystic` | 1.0.0 | `scripts/characters/hero_catalog.gd`, `scripts/combat/combat_state.gd` | statistiques niveau 1, `Spark Bolt`, portée 4 et ligne de vue |
| `ux.onboarding` | 1.0.0 | `scenes/poc/character_select.tscn`, `scripts/poc/game_flow.gd` | comparaison, choix initial et changement libre de classe sans reset |
| Authoring Godot | POC | `resources/`, `scenes/ui/`, `docs/GODOT_EDITING_GUIDE.md` | UI visible dans l'éditeur, données Inspector, thème partagé et marqueurs de map |
| `monster.moss_slime` | 1.0.0 | `scripts/combat/combat_state.gd`, `scripts/world/world_state.gd` | statistiques, `Soft Bump`, respawn et récompense de répétition réduite |
| `ux.mobile_controls` | 1.0.0 | `scripts/poc/battle_poc.gd` | paysage 1280×720, tap, preview, confirmation, boutons 56 px et icônes |
| `ux.accessibility` | 1.0.0 | `scripts/poc/battle_board.gd` | coordonnées, labels M/A, texte + couleur, clavier |
| `world.art_audio_direction` | 1.0.0 | `assets/`, `scripts/poc/battle_board.gd` | illustration fantasy lisible, profondeur 2.5D, silhouettes et feedback visuel |
| `system.core_loops` | 1.0.0 | `scripts/poc/game_flow.gd` | déplacement → interaction/collecte/combat → feedback → retour sûr |
| `system.exploration` | 1.0.0 | `scripts/world/world_poc.gd` | tap-to-move, stick virtuel, ressources personnelles, focus tactile, rencontre visible |
| `map.whispering_woods` | 1.0.0 | `assets/world/`, `scripts/world/world_canvas.gd` | zone aventure POC, collecte, point social et Moss Slime visible |
| `system.quests` | 1.0.0 | `scripts/world/world_state.gd` | machine d’état de quête, objectifs lisibles et récompenses atomiques |
| `system.economy_trade` | 1.0.0 | `scripts/world/world_state.gd` | échange local déterministe d’une ressource contre une monnaie POC |
| `system.dens` | 1.0.0 | `scripts/world/world_state.gd` | achat, placement unique et persistance d’une décoration POC |

## Visual implementation

- `assets/backgrounds/whispering_woods_arena_v1.png` : décor d’arène original.
- `assets/characters/wolf_guardian_v1.png` : sprite alpha du héros.
- `assets/characters/moss_slime_v1.png` : sprite alpha du monstre.
- `assets/characters/wolf_guardian/` : quatre poses de marche et quatre poses de
  `Claw Strike`.
- `assets/characters/fox_mystic/` : quatre poses de marche et quatre poses de
  lancement de `Spark Bolt`.
- `assets/characters/moss_slime/` : quatre poses de bond et quatre poses de
  `Soft Bump`.
- `assets/ui/icons/` : icônes des actions du POC, dont `Spark Bolt`, séparées des textes localisés.
- `assets/world/whispering_woods_hub_v1.png` : zone d’exploration 2.5D avec
  landmarks séparés et chemins continus.
- `assets/characters/npcs/owl_sage_v1.png` : PNJ de quête original détouré.
- `scripts/world/world_canvas.gd` : personnages triés par profondeur, marqueurs,
  ressources, points d’intérêt, particules et animation de marche.
- `scripts/world/world_poc.gd` : déplacement multi-input, HUD, interactions,
  dialogue, combat en un clic et demande de changement de classe.
- `scripts/poc/game_flow.gd` : chargement du monde/combat, sauvegarde JSON,
  récompense et retour à la position d’exploration.
- `scripts/poc/battle_board.gd` : projection isométrique, profondeur, ombres,
  grille fusionnée au terrain, particules et animations déterministes par poses.
- `tests/test_visual_smoke.gd` : déplacement, tour ennemi, impacts et victoire.

## Assumptions

- Le combat est le premier tutoriel : `Split Bud` est désactivé conformément à
  `monster.moss_slime`.
- Les deux cases rocheuses servent au pathfinding et bloquent la ligne de vue de
  `Spark Bolt` ; `Fox Mystic` doit se repositionner pour ouvrir un tir légal.
- Le domaine hors ligne préfigure l’autorité serveur mais n’est pas une autorité
  de production. Le réseau commence seulement à l’Increment 2.
- `First Bloom` est une quête composite propre au POC destinée à tester plusieurs
  systèmes rapidement ; elle n’ajoute ni ne modifie de contenu normatif dans
  `WILDBOUND_SPECS`.

## Acceptance checks

- Une action illégale ne modifie ni position ni ressource.
- Les dégâts publics correspondent exactement à la formule normative.
- Même état initial + même action = même position et mêmes événements ennemis.
- Deux unités ne terminent pas sur la même case.
- AP, MP et Health sont bornés à zéro.
- Le premier lancement exige un choix de classe réversible avant confirmation,
  puis le même héros est utilisé dans l'exploration, le combat et la sauvegarde.
- Le joueur peut changer librement de classe depuis le monde ouvert sans perdre
  l’XP, les monnaies, la quête, les objets ou les décorations.
- `Spark Bolt` applique exactement sa formule normative, sa portée 4 et sa ligne de vue.
- Le tap-to-move et les contrôles directs modifient la position dans les bornes.
- Toucher un monstre une seule fois déclenche le déplacement d’approche puis la
  transition de combat.
- En combat, choisir un sort puis toucher une cible légale exécute directement
  l’action, sans étape de confirmation supplémentaire.
- La victoire revient au monde, conserve XP et récompenses, puis fait réapparaître
  `Moss Slime` avec une récompense d’entraînement réduite aux clears suivants.
- La mort du dernier adversaire déclenche automatiquement le retour au monde
  après le feedback visuel de victoire, sans action supplémentaire du joueur.
- Une ressource collectée ou une décoration placée ne peut pas être dupliquée.

# Modifier WILDBOUND manuellement dans Godot

Le POC est organisé pour que la présentation soit modifiable dans l'éditeur 2D
et que les statistiques principales soient modifiables dans l'Inspector, sans
éditer le GDScript.

## Ouvrir le projet

1. Lancez Godot 4.7.
2. Importez `game/project.godot`.
3. Dans le dock **FileSystem**, ouvrez directement la scène que vous souhaitez
   modifier. `game_flow.tscn` ne contient que le conteneur de navigation, car les
   écrans sont chargés dynamiquement.

## Écran de sélection

Ouvrez `scenes/poc/character_select.tscn` pour modifier le fond, les textes,
l'espacement, le panneau principal, le bouton d’annulation et la disposition des
cartes. Cette même scène sert au choix initial et au changement libre de classe.

Les cartes sont des instances de `scenes/ui/hero_card.tscn`. Modifiez cette scène
une seule fois pour changer la présentation de toutes les classes.

## Statistiques, sorts et sprites des héros

Sélectionnez une ressource dans `resources/heroes/` :

- `wolf_guardian.tres`
- `fox_mystic.tres`

L'Inspector expose l'identité, les statistiques niveau 1, la liste `Skills`,
le portrait et les cycles de marche/attaque. Ces ressources alimentent
la sélection, l'open world et le combat.

Chaque sort est une ressource indépendante dans `resources/skills/`. L'Inspector
permet de modifier son nom anglais, sa description, son icône, le coût en PA,
la portée, les dégâts, la ligne de vue et le mode `single`, `area` ou `chain`.
L'ordre de la liste `Skills` d'un héros détermine l'ordre des trois icônes.

Pour créer une classe, dupliquez une ressource `.tres`, changez son `hero_id`,
puis enregistrez-la dans `scripts/characters/hero_catalog.gd`.

## Open world

Ouvrez `scenes/world/world_poc.tscn` pour modifier visuellement :

- le fond et l'atmosphère ;
- le résumé du joueur ;
- le stick directionnel mobile ;
- le HUD, le bouton `ChangeClassButton` et tous ses textes.

Ouvrez ensuite `scenes/world/world_canvas.tscn`. Les enfants de
`InteractionMarkers` correspondent aux positions jouables de `Owl Sage`, des
baies, du `Trade Post`, du `Home Plot`, de `Moss Slime`, etc. Déplacez un
`Marker2D` avec l'outil de déplacement : la nouvelle position est utilisée par
le rendu et par la détection d'interaction.

Les marqueurs `MossSlimeWoods`, `MossSlimeCreek` et `MossSlimeRuins`
représentent respectivement des groupes de 1, 2 et 3 Slimes.

Le décor de terrain reste une illustration unique. Pour modifier sa composition,
remplacez `assets/world/whispering_woods_hub_v1.png`. Une future map construite
tuile par tuile devra utiliser plusieurs `TileMapLayer`.

## Combat

Ouvrez `scenes/poc/battle_poc.tscn`. Le fond, le plateau et le HUD sont de vrais
nœuds sélectionnables.

Le HUD est réparti en quatre panneaux indépendants dans l’arbre 2D :

- `SpellDock`, à gauche, ne contient que les icônes des sorts ;
- `SkillTooltip`, placé au-dessus du dock et visible au survol ;
- `StatsHUD` et `TurnHUD`, pour les HP/PA/PM et le timer de 30 secondes ;
- `DialogueHUD`, en bas, séparé des choix tactiques.

Sélectionnez `BattleBoard` pour modifier dans l'Inspector :

- `Editor Obstacles`, utilisé uniquement pour la prévisualisation dans l'éditeur ;
- les couleurs des cases paires et impaires ;
- la couleur des lignes de la grille.

Les layouts aléatoires ne sont pas stockés dans la scène. Ouvrez les ressources
de `resources/arenas/` pour modifier unitairement leur nom, le spawn du joueur,
les trois spawns ennemis et les obstacles. Conservez les coordonnées entre
`(0, 0)` et `(8, 8)` et au moins trois spawns ennemis distincts.

Le script `@tool` dessine une prévisualisation du plateau, des obstacles et des
combattants directement dans la vue 2D. Les animations restent déterministes en
GDScript, mais leurs images proviennent des ressources de héros éditables.

## Thème partagé

Les couleurs et styles de base sont centralisés dans
`resources/themes/wildbound_theme.tres`. Une propriété locale définie sur un
nœud de scène reste prioritaire sur ce thème.

## Noms techniques à conserver

Les nœuds marqués **Unique Name in Owner** sont référencés par `%NodeName` dans
les scripts. Vous pouvez les déplacer dans l'arbre, mais évitez de renommer :

- `WolfGuardianCard`, `FoxMysticCard`, `ConfirmButton`, `CancelButton`,
  `SelectionLabel`, `Title`, `Subtitle` ;
- `WorldCanvas`, `ExplorationHUD`, `MobileDPad`, `ChangeClassButton`, les labels du HUD ;
- `BattleBoard`, `AttackButton`, `SkillButton2`, `SkillButton3`,
  `ChangeHeroButton`, `ArenaLabel`, les jauges HP, les badges PA/PM, le timer et les
  panneaux du HUD de combat ;
- `SceneHost` et `TransitionOverlay`.

Après une modification, lancez le projet avec `F6` pour tester une scène seule,
puis `F5` pour tester la navigation complète.

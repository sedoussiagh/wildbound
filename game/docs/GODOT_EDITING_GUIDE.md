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

L'Inspector expose l'identité, les statistiques niveau 1, le sort de base,
l'icône, le portrait et les cycles de marche/attaque. Ces ressources alimentent
la sélection, l'open world et le combat.

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

Le décor de terrain reste une illustration unique. Pour modifier sa composition,
remplacez `assets/world/whispering_woods_hub_v1.png`. Une future map construite
tuile par tuile devra utiliser plusieurs `TileMapLayer`.

## Combat

Ouvrez `scenes/poc/battle_poc.tscn`. Le fond, le plateau et le HUD sont de vrais
nœuds sélectionnables.

Sélectionnez `BattleBoard` pour modifier dans l'Inspector :

- `Editor Obstacles`, utilisé aussi par les règles du combat ;
- les couleurs des cases paires et impaires ;
- la couleur des lignes de la grille.

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
- `BattleBoard`, les boutons et labels du HUD de combat ;
- `SceneHost` et `TransitionOverlay`.

Après une modification, lancez le projet avec `F6` pour tester une scène seule,
puis `F5` pour tester la navigation complète.

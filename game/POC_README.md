# Wildbound — Open World + Combat POC

Ce POC transforme la preuve de combat initiale en petite boucle d’aventure
hors ligne : exploration temps réel, interactions, rencontre visible, combat
tactique puis retour persistant dans le monde.

Au premier lancement, le joueur choisit son animal-classe entre `Wolf Guardian`
et `Fox Mystic`. Le bouton `Changer de classe` permet ensuite de basculer
librement entre les deux sans perdre la progression.

## Exploration jouable

- Déplacement libre du héros sélectionné par tap-to-move, WASD, flèches ou stick
  virtuel ; le cycle de marche s’active uniquement pendant le mouvement.
- Zone `Whispering Woods` 2.5D avec `Trade Post`, `Home Plot`, `Moon Shrine`,
  ressources visibles, PNJ et clairière de rencontre.
- Quête tutorielle verticale `First Bloom` : dialogue avec `Owl Sage`, collecte,
  combat contre `Moss Slime`, retour et récompense.
- Inventaire léger : `Glow Berry`, `Leaf Coins`, XP, énergie et décoration
  persistante `Glow Lantern`.
- `River Scout` démontre la présentation d’une présence sociale ; son dialogue
  indique explicitement que le réseau n’est pas encore connecté dans ce POC.
- Trois rencontres visibles sont placées dans le monde : `Moss Slime` seul,
  `Moss Slimes ×2` et `Moss Slimes ×3`. Un seul toucher fait marcher le héros
  jusqu'au groupe puis lance le combat, sans seconde confirmation.
- L’état est sauvegardé dans `user://wildbound_open_world_poc.json` après chaque
  interaction confirmée et avant/après un combat.

## Rendu 2.5D

- Plateau 9×9 projeté en isométrie ; la grille tactique translucide est peinte
  directement sur le sol de la map au lieu de former une plateforme séparée.
- Quatre arènes choisies au lancement (`Moonlit Crossing`, `Moss Ring`,
  `Broken Path`, `Twin Groves`) possèdent des obstacles et spawns différents.
- Aucun chiffre ni nom de coordonnée n'est dessiné sur les cases.
- Arrière-plan original de `Whispering Woods` avec profondeur atmosphérique.
- Sprites illustrés de `Wolf Guardian`, `Fox Mystic` et `Moss Slime` avec ombre au sol.
- Cycles illustrés de quatre poses pour la marche et l’attaque de chaque unité,
  redécoupés avec une marge alpha par pose et synchronisés avec les tweens case
  par case, l’anticipation et l’impact.
- Dégâts flottants, squash/stretch, disparition et célébration.
- Particules d’ambiance et HUD semi-transparent adapté au paysage mobile.
- Dock minimaliste de trois sorts à gauche : icônes seules, description complète au
  survol, état sélectionné visible et commandes secondaires séparées.
- Barre supérieure dédiée aux HP, PA et PM, avec jauges et badges colorés ; le
  dialogue et le journal restent dans un panneau indépendant en bas.

## Lancer

1. Ouvrir `project.godot` avec Godot 4.7.
2. Appuyer sur `F6`/`F5` ou sur le bouton **Run Project**.
3. Utiliser le toucher ou la souris. Le clavier est également supporté.

Pour modifier les scènes, les marqueurs de map, les styles ou les ressources de
classes depuis l'Inspector, consultez `docs/GODOT_EDITING_GUIDE.md`.

## Boucle de combat

- Chaque héros commence avec 3 AP et 3 MP.
- Les cases cyan indiquent les déplacements possibles, sans lettre superposée.
- Sélectionner un sort affiche toute sa portée en orange avant le ciblage ; une
  cible réellement attaquable reçoit un contour renforcé.
- `Wolf Guardian` utilise `Claw Strike`, `Guard Break` et `Wild Roar`.
- `Fox Mystic` utilise `Spark Bolt`, `Ember Arc` et `Starfall`.
- Les sorts de zone peuvent toucher jusqu'à trois Slimes regroupés.
- `Spark Bolt` coûte 1 AP, porte jusqu'à 4 cases et exige une ligne de vue libre ;
  les piliers intégrés à la map peuvent donc bloquer le tir de `Fox Mystic`.
- Choisir `Claw Strike`, puis toucher `Moss Slime`, lance immédiatement le sort :
  aucune confirmation supplémentaire n’est demandée.
- `Terminer le tour` déclenche le déplacement et les attaques déterministes du monstre.
- Chaque tour joueur dure 30 secondes. Une jauge passe à l’orange puis au rouge
  avant de terminer automatiquement le tour lorsque le temps est écoulé.
- Le bouton de changement de personnage bascule entre `Wolf Guardian` et
  `Fox Mystic`. Le combat redémarre sur la même arène contre le même groupe.
- Dans la boucle open world, vaincre `Moss Slime` joue l’animation de victoire
  puis retourne automatiquement dans la map. Le monstre réapparaît pour pouvoir
  être rejoué : 8 Leaf Coins + 40 XP au premier clear, puis 2 Coins + 10 XP.

Contrôles clavier : flèches pour déplacer le focus, `Entrée` pour sélectionner,
`1`/`2`/`3` pour les sorts, `C` pour changer de personnage, `E` pour terminer
le tour et `R` pour recommencer.

## Test déterministe

Quand l’exécutable Godot est disponible dans le terminal :

```powershell
godot --headless --path . --script res://tests/test_combat_state.gd
godot --headless --path . --script res://tests/test_character_classes.gd
godot --headless --path . --script res://tests/test_random_encounters.gd
```

Test de fumée du combat animé complet :

```powershell
godot --headless --path . --script res://tests/test_visual_smoke.gd
godot --headless --path . --script res://tests/test_fox_visual_smoke.gd
```

Tests du monde et de la boucle complète :

```powershell
godot --headless --path . --script res://tests/test_world_state.gd
godot --headless --path . --script res://tests/test_game_flow_smoke.gd
godot --headless --path . --script res://tests/test_combat_auto_exit.gd
godot --headless --path . --script res://tests/test_combat_hud.gd
```

## Limites intentionnelles

- Hors ligne uniquement. La présence sociale est simulée ; aucun autre joueur
  réel, serveur, chat réseau ou synchronisation anti-triche n’est encore actif.
- La sauvegarde JSON locale sert au POC et n’est pas une autorité de production.
- `First Bloom`, `Glow Berry` et `Leaf Coins` forment une boucle de démonstration
  composite ; ils doivent être remplacés ou réalignés sur le contenu normatif
  avant la production de contenu.
- `Split Bud` est désactivé, comme autorisé pour le premier combat tutoriel.
- Les illustrations `v1` sont des placeholders originaux générés pour ce POC ;
  leur provenance et les limites de production sont dans `assets/ART_ASSET_NOTES.md`.
- L’interface expose la légalité par texte et couleur, mais une
  validation complète par lecteur d’écran reste une étape de production mobile.

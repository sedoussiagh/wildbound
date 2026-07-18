# Art Asset Notes

Les trois assets `v1` de ce POC ont été générés avec l’outil intégré de génération
d’images, puis intégrés au projet comme placeholders de direction artistique.
Ils sont originaux et ne cherchent pas à reproduire un personnage, une map ou une
interface protégée d’un autre jeu.

## `whispering_woods_arena_v1.png`

- Usage : arrière-plan 16:9 de l’arène tactique.
- Direction : clairière forestière isométrique 2.5D, centre calme pour recevoir
  la grille, profondeur par plans et lumière atmosphérique.
- Contraintes : aucun personnage, aucune grille, aucun texte, logo ou watermark.

## `wolf_guardian_v1.png`

- Usage : sprite statique animé par Godot.
- Direction : loup protecteur tout public, fourrure bleu-gris, armure feuille et
  bois, écharpe teal, vue trois-quarts isométrique.
- Détourage : source sur chroma `#ff00ff`, transformée en PNG alpha par le helper
  local `remove_chroma_key.py` avec soft matte et despill.

## `moss_slime_v1.png`

- Usage : sprite statique animé par Godot.
- Direction : monstre tutoriel rond, vert, couvert de mousse, lisible et non
  menaçant, vue trois-quarts isométrique.
- Détourage : même procédure chroma que `Wolf Guardian`.

## Cycles de personnages

Les dossiers `characters/wolf_guardian/`, `characters/fox_mystic/` et
`characters/moss_slime/` contiennent chacun deux cycles de quatre poses :
`walk_0..3.png` et `attack_0..3.png`.

- `Wolf Guardian` : marche avec transfert du poids, puis anticipation, coup de
  griffe, impact et récupération de `Claw Strike`.
- `Moss Slime` : petit bond élastique, puis compression, projection, impact et
  récupération de `Soft Bump`.
- `Fox Mystic` : marche légère en robe teal, canalisation et récupération de
  `Spark Bolt`. Le projectile reste dessiné séparément par Godot pour éviter un
  doublon dans la pose d’attaque.
- Méthode : nouvelles feuilles 4×2 générées à partir de chaque personnage de
  référence sur chroma magenta, détourage alpha, séparation par composantes,
  recentrage et marge transparente de sécurité. Aucun morceau d’une pose voisine
  ne subsiste dans les frames exportées.
- Les images n’incluent ni texte ni interface afin que le timing reste contrôlé
  par Godot et puisse être remplacé cycle par cycle.

## Icônes d’actions

Le dossier `ui/icons/` contient les icônes originales `claw_strike`, `spark_bolt`,
`end_turn`, `move`, `confirm`, `cancel` et `restart`. Elles partagent une direction fantasy
forestière peinte et restent indépendantes des libellés localisés.

`spark_bolt.png` a été générée avec l'outil d'image intégré : éclair magique
cyan-blanc, cœur doré et détails végétaux, conçu pour rester lisible à 48 px sur
chroma magenta. La feuille et l'icône ont ensuite été détourées par soft matte,
despill et exportées en PNG alpha avant l'import Godot.

## `whispering_woods_hub_v1.png`

- Usage : arrière-plan de la zone d’exploration avant le combat.
- Direction : carte forestière isométrique 2.5D connectée, avec cercle de réunion,
  marché, emplacement de décoration, sanctuaire, ressources et clairière.
- Composition : les landmarks jouables restent dans les 72 % gauches afin de
  conserver un HUD mobile permanent à droite.
- Contraintes : environnement uniquement, aucun personnage, texte, UI ou grille.

## `owl_sage_v1.png`

- Usage : PNJ de la quête composite `First Bloom` du POC.
- Direction : hibou anthropomorphe bienveillant, manteau de sage végétal et bâton,
  vue trois-quarts compatible avec les sprites existants.
- Détourage : chroma `#ff00ff`, soft matte strict et despill. Le seuil opaque a
  été resserré pour conserver les tons bruns du plumage.

## Production

Avant une sortie commerciale, ces placeholders doivent passer par une revue de
direction artistique, cohérence multi-poses, droits de publication, optimisation
mobile et création d’un atlas compressé par plateforme.

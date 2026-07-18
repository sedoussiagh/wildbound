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

Les dossiers `characters/wolf_guardian/` et `characters/moss_slime/` contiennent
chacun deux cycles de quatre poses : `walk_0..3.png` et `attack_0..3.png`.

- `Wolf Guardian` : marche avec transfert du poids, puis anticipation, coup de
  griffe, impact et récupération de `Claw Strike`.
- `Moss Slime` : petit bond élastique, puis compression, projection, impact et
  récupération de `Soft Bump`.
- Méthode : génération intégrée à partir des sprites `v1`, feuille 4×2 sur chroma
  `#ff00ff`, détourage alpha, découpe en huit cellules et nettoyage des fragments.
- Les images n’incluent ni texte ni interface afin que le timing reste contrôlé
  par Godot et puisse être remplacé cycle par cycle.

## Icônes d’actions

Le dossier `ui/icons/` contient six icônes originales : `claw_strike`, `end_turn`,
`move`, `confirm`, `cancel` et `restart`. Elles partagent une direction fantasy
forestière peinte et restent indépendantes des libellés localisés.

## Production

Avant une sortie commerciale, ces placeholders doivent passer par une revue de
direction artistique, cohérence multi-poses, droits de publication, optimisation
mobile et création d’un atlas compressé par plateforme.

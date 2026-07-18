# Wildbound — Offline Combat POC

Ce POC implémente l’`Increment 1 — Offline combat proof` du roadmap.

## Rendu 2.5D

- Plateau 7×7 projeté en isométrie ; la grille tactique translucide est peinte
  directement sur le sol de la map au lieu de former une plateforme séparée.
- Arrière-plan original de `Whispering Woods` avec profondeur atmosphérique.
- Sprites illustrés de `Wolf Guardian` et `Moss Slime` avec ombre au sol.
- Cycles illustrés de quatre poses pour la marche et l’attaque de chaque unité,
  synchronisés avec les tweens case par case, l’anticipation et l’impact.
- Dégâts flottants, squash/stretch, disparition et célébration.
- Particules d’ambiance et HUD semi-transparent adapté au paysage mobile.
- Icônes dédiées pour déplacement, attaque, confirmation, annulation, fin de tour
  et redémarrage ; les libellés restent visibles pour l’accessibilité.

## Lancer

1. Ouvrir `project.godot` avec Godot 4.7.
2. Appuyer sur `F6`/`F5` ou sur le bouton **Run Project**.
3. Utiliser le toucher ou la souris. Le clavier est également supporté.

## Boucle jouable

- `Wolf Guardian` commence avec 3 AP et 3 MP.
- Toucher une case marquée `M` déplace le héros et consomme le coût du chemin.
- `Claw Strike` coûte 1 AP et cible `Moss Slime` à portée 1.
- La première sélection affiche les dégâts exacts ; confirmer ou toucher de nouveau.
- `Terminer le tour` déclenche le déplacement et les attaques déterministes du monstre.
- Vaincre `Moss Slime` affiche la victoire ; `Recommencer` réinitialise tout l’état.

Contrôles clavier : flèches pour déplacer le focus, `Entrée` pour sélectionner,
`A` pour l’attaque, `E` pour terminer le tour et `R` pour recommencer.

## Test déterministe

Quand l’exécutable Godot est disponible dans le terminal :

```powershell
godot --headless --path . --script res://tests/test_combat_state.gd
```

Test de fumée du combat animé complet :

```powershell
godot --headless --path . --script res://tests/test_visual_smoke.gd
```

## Limites intentionnelles

- Hors ligne uniquement ; aucune persistance, récompense ou économie.
- `Split Bud` est désactivé, comme autorisé pour le premier combat tutoriel.
- Les illustrations `v1` sont des placeholders originaux générés pour ce POC ;
  leur provenance et les limites de production sont dans `assets/ART_ASSET_NOTES.md`.
- L’interface expose les coordonnées et la légalité par texte et couleur, mais une
  validation complète par lecteur d’écran reste une étape de production mobile.

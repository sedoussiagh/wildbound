---
spec_id: system.dens
version: 1.0.0
status: normative
depends_on:
  - system.customization
  - online.shared_world
---

# Dens and Decoration

## Rôle

`Willow Den` est l’espace privé persistant du héros. Il transforme les trophées
de jeu en expression sociale sans modifier la puissance.

## Éditeur

- Grille de placement invisible, objets 1×1 à 4×4.
- Rotation par quarts de tour si l’objet la supporte.
- Catégories : floor, wall, furniture, lamp, plant, trophy, interactive.
- Placement invalide affiché en rouge + motif ; jamais confirmé.
- Undo/redo sur les 20 dernières opérations locales.
- Sauvegarde explicite avec version attendue ; conflit propose recharger ou
  dupliquer le brouillon.
- Limite MVP : 100 objets placés, dont 10 interactifs.

## Visibilité

`private`, `friends`, `guild`, `showcase`. Le propriétaire peut expulser, bloquer
ou fermer immédiatement. Les visiteurs ne déplacent rien et ne voient aucun
stockage privé.

## Réactions

Phrases et réactions prédéfinies. Pas de compteur public total obligatoire. Le
showcase hebdomadaire mélange sélection éditoriale et aléatoire afin de limiter
le concours de popularité.

## Invariants

- Un objet placé reste possédé et ne peut être simultanément tradé.
- Retirer un objet le rend à l’inventaire sans coût.
- Un visiteur ne peut jamais modifier ou dupliquer le den.
- Les collisions garantissent un chemin de la porte à une zone libre.

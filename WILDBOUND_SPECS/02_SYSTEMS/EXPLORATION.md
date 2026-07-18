---
spec_id: system.exploration
version: 1.0.0
status: normative
depends_on:
  - system.core_loops
---

# Exploration

## Déplacement

Dans les zones non tactiques, mouvement temps réel par tap-to-move ou stick
virtuel. Les joueurs n’entrent pas en collision. Les NPC, sorties, ressources et
interactions ont une zone tactile minimum et un focus accessible.

## Structure d’un biome

Chaque biome cible contient : un hub ou camp, plusieurs sous-zones, 10 entrées de
`Wild Journal`, 3 puzzles, 1 événement court, 1 donjon et 1 boss. Le MVP réalise
complètement `Whispering Woods` et le donjon `Moonroot Hollow`.

## Collecte

- Nœuds visibles dans le monde mais récompense personnelle après interaction.
- Pas de vol de ressource entre joueurs.
- Réapparition déterminée serveur et instance, non affichée en compte à rebours.
- Inventaire plein : ressource envoyée dans une réserve temporaire récupérable au
  hub pendant sept jours.

## Secrets et puzzles

Un secret est détectable par au moins deux canaux parmi visuel, son, vibration et
indice texte. Aucun pixel hunting obligatoire. Un puzzle coopératif possède une
solution solo plus lente ou des partenaires NPC.

## Déclenchement des combats

Toucher un monstre ouvre une fiche de menace : famille, niveau, taille prévue,
récompenses et durée. Le joueur confirme solo ou groupe. Aucun combat aléatoire
ne coupe une interaction sociale.

## Mentor Scale

Dans une zone inférieure, statistiques et équipement du mentor sont plafonnés.
Les compétences restent disponibles si elles ne suppriment pas une mécanique.
La récompense mentor quotidienne est cosmétique ou liée, jamais échangeable.

## Acceptance criteria

- Deux joueurs peuvent récolter le même nœud sans s’en priver.
- Toute sortie de map affiche destination et niveau conseillé.
- Une déconnexion hors combat replace au dernier checkpoint sûr.
- Un joueur réduit en mentor reste utile sans tuer seul un boss en un tour.

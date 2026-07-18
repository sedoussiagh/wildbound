---
spec_id: system.progression
version: 1.0.0
status: normative
depends_on:
  - product.mvp_scope
  - system.core_loops
---

# Progression

## Niveau et XP

- MVP : niveaux 1–20 ; cible long terme : 50.
- Sources : quêtes, combats, découvertes et premières actions sociales positives.
- Pas de vente d’XP ni de multiplicateur premium.
- Après cinq répétitions quotidiennes d’une rencontre, l’XP décroît graduellement
  jusqu’à 25 % ; le loot normal demeure.
- `Rested XP` s’accumule hors ligne jusqu’à deux niveaux et double uniquement
  l’XP de combat consommée.

## Jalons MVP

| Niveau | Déblocage |
|---:|---|
| 1 | classe, tutoriel, deux compétences |
| 2 | troisième compétence |
| 3 | `Willow Den` |
| 4 | groupes |
| 5 | crafting |
| 7 | troisième preset |
| 10 | évolution, duel et trade sous conditions |
| 12 | `Moonroot Hollow` |
| 15 | difficulté donjon haute |
| 20 | fin d’arc MVP et progression post-MVP verrouillée |

## Axes parallèles

Le `Wild Journal` contient cinq chemins indépendants : `Explorer`, `Fighter`,
`Helper`, `Decorator`, `Trader`. Chaque chapitre donne titre, motif ou décoration.
Aucune puissance unique n’exige PvP, trade ou groupe.

## Maîtrise de classe

La maîtrise progresse en utilisant des actions identitaires, pas en infligeant
uniquement des dégâts. Elle débloque descriptions avancées, variantes visuelles
et emotes de classe. Elle ne modifie pas les statistiques PvP normalisées.

## Rattrapage

- Quêtes principales jamais expirées.
- Bonus de retour informatif, sans compte à rebours agressif.
- Saisons passées peuvent rendre leurs cosmétiques disponibles plus tard.
- `Mentor Scale` permet de jouer avec un débutant sans trivialiser la zone.

## Invariants

- L’XP confirmée ne diminue jamais.
- Le niveau est dérivé d’une courbe versionnée, jamais fourni par le client.
- Chaque récompense est attribuée une fois par source/idempotency key.
- Aucun axe social n’est obligatoire pour finir l’histoire principale.

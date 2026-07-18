---
spec_id: system.quests
version: 1.0.0
status: normative
depends_on:
  - system.core_loops
  - system.progression
---

# Quest System

## Catégories

- `main` : arc narratif, toujours jouable solo.
- `class` : apprend l’identité de classe et l’évolution.
- `adventure_board` : objectif flexible de 3–10 minutes.
- `world_project` : contribution communautaire sans classement obligatoire.
- `friendship` : coopération volontaire sans pouvoir exclusif.

## Contrat d’une quête

Une quête définit ID stable, nom anglais, catégorie, niveau minimum, prérequis,
résumé, étapes ordonnées, règles de groupe, durée estimée, récompenses, états de
dialogue, reprise après déconnexion et télémétrie.

## Progression

- Une étape ne se valide que sur événement serveur.
- Les objectifs de collecte ne consomment pas l’objet sauf mention explicite.
- En groupe, le crédit de défaite s’applique à tout membre présent et actif.
- Une quête abandonnée conserve les récompenses déjà légitimement acquises mais
  réinitialise ses objets temporaires.
- Aucun objectif quotidien ne demande plus de 20 minutes cumulées.

## États

`locked`, `available`, `active`, `step_complete`, `ready_to_claim`, `completed`,
`deprecated`. Le claim est idempotent. Une quête dépréciée déjà active fournit un
chemin de complétion ou une compensation documentée.

## Acceptance criteria

- Chaque objectif affiche progression, lieu, mode et récompense.
- Le joueur peut suivre au moins trois quêtes simultanément.
- Une action effectuée avant activation ne compte que si la quête le déclare.
- Une récompense d’inventaire plein va dans la réserve temporaire.

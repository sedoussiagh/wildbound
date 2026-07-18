---
spec_id: system.evolution
version: 1.0.0
status: normative
depends_on:
  - system.progression
  - system.combat
---

# Evolution System

## Principe

La classe du héros est permanente. Au niveau 10, le joueur choisit une branche
d’évolution qui spécialise son style sans remplacer son identité animale.

## Déblocage initial

Conditions cumulatives : niveau 10, quête `The Wild Mirror` terminée, aucun
combat en cours. L’écran compare les deux branches : rôle, difficulté, deux
compétences, ultime, forces, limites et aperçu visuel. Aucun choix par défaut
n’est précoché.

Le choix conserve nom du héros, apparence, amitiés, guilde, quêtes, équipement
compatible et historique. Les deux nouvelles compétences sont débloquées ;
l’ultime de la branche devient disponible.

## Changement de branche

- Consomme une `Morphstone`, sauf premier essai gratuit dans les 48 heures de
  jeu actif suivant le choix initial.
- Interdit en combat, matchmaking, trade verrouillé ou transaction en cours.
- Montre avant validation les compétences retirées/ajoutées et les presets
  invalidés.
- Les anciennes compétences restent acquises mais inéquipables.
- Les presets incompatibles sont archivés, jamais supprimés silencieusement.
- Opération atomique et idempotente côté serveur.

## Acquisition de Morphstone

Recette : 5 `Wild Mirror Fragment` + 1 `Heartroot Sap`. Sources : quête
mensuelle, voie gratuite de saison, difficulté haute d’un boss avec limite
hebdomadaire. L’objet est lié au compte, non échangeable et jamais vendu contre
monnaie premium.

## Forme avancée post-MVP

Au niveau 30, la branche évolue vers une forme avancée. Celle-ci améliore
principalement expression et flexibilité ; elle ne doit pas rendre la branche
inférieure obsolète. Toute forme avancée reste hors MVP jusqu’à validation des
six branches niveau 10.

## Invariants

- Un héros possède exactement une classe et au plus une branche active.
- Une branche active appartient toujours à la classe du héros.
- Un changement ne modifie ni niveau, ni XP, ni inventaire hors coût annoncé.
- Un paiement réel ne déclenche jamais une évolution.
- Une répétition du même `idempotency_key` ne consomme pas deux objets.

## Acceptance criteria

- Un joueur peut consulter la comparaison sans posséder de `Morphstone`.
- Une déconnexion pendant la transaction aboutit à l’état avant ou après, jamais
  à un état partiel.
- Un preset incompatible affiche les remplacements requis avant usage.
- Le journal d’audit contient ancienne branche, nouvelle branche, coût et motif.

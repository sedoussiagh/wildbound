---
spec_id: system.retention_liveops
version: 1.0.0
status: normative
depends_on:
  - system.core_loops
  - technical.analytics
---

# Retention and LiveOps

## Principle

La rétention vient de l’attachement au héros, de la maîtrise, de la création et
des relations, pas de la peur de perdre. Aucun mécanisme ne punit une absence.

## Recurring activities

- `Adventure Board`: trois cartes de 3/5/10 minutes renouvelées, reroll gratuit.
- `World Project`: progression communautaire sans classement individuel forcé.
- `Den Showcase`: thème hebdomadaire, participation volontaire.
- `Wild Journal`: objectifs permanents et guide de retour.
- Donjon : bonus de première victoire, puis récompenses normales utiles.

## Season model

8–12 semaines, thème narratif léger, voie gratuite complète et éventuelle voie
premium cosmétique. Progression par activités variées, rattrapage en fin de saison,
aucune puissance ou monnaie échangeable. Récompenses importantes peuvent revenir
après une période annoncée.

## Notifications

Opt-in par catégorie : ami/guilde, activité planifiée, contenu, achat/support.
Heures calmes locales. Aucun message « tu vas perdre », aucune référence à une
série cassée ou à des amis déçus. Maximum configurable et désactivation simple.

## Live configuration

Feature flags and content schedules have owner, start/end UTC, target cohort,
fallback and kill switch. Server time is authoritative. A disabled event leaves
claims already earned available.

## Guardrails

Monitor session duration/night play, reports, spending concentration, crashes and
return after break. An engagement gain accompanied by safety or wellbeing decline
is not a successful experiment.

## Acceptance criteria

- Missing a day/week does not remove earned or permanent progress.
- Daily objectives total ≤20 minutes and can be ignored.
- Every timed activity shows timezone-safe start/end and claim policy.
- LiveOps outage cannot corrupt base progression.

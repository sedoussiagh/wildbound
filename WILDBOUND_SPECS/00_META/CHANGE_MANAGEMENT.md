---
spec_id: meta.change_management
version: 1.0.0
status: normative
depends_on:
  - meta.specification_standard
  - meta.dependency_map
---

# Change Management

## Types de changement

- **Patch** : correction éditoriale sans effet observable.
- **Minor** : ajout compatible, nouvelle classe ou champ optionnel.
- **Major** : changement d’invariant, suppression ou sémantique incompatible.

## Procédure unitaire

1. Identifier le `spec_id` modifié.
2. Lire ses dépendances et rechercher ses références entrantes.
3. Décrire avant/après et motivation.
4. Évaluer combat, économie, social, UX, données et exploitation.
5. Ajouter ou adapter les critères d’acceptation.
6. Augmenter la version du module.
7. Si une donnée persistée change, documenter migration et rollback.

## Compatibilité du contenu

- Un ID publié ne doit pas être renommé ni réutilisé.
- Un contenu retiré passe d’abord à `deprecated` et reste lisible en sauvegarde.
- Une sauvegarde contenant une ancienne évolution doit charger un substitut
  explicite, jamais une classe aléatoire.
- Une modification de statistique augmente `balance_version`.
- Un changement de payload augmente `protocol_version` s’il n’est pas compatible.

## Fiche d’impact requise

```text
Module:
Version avant/après:
Motif:
Références entrantes:
Impact sauvegardes:
Impact équilibre/économie:
Impact localisation/accessibilité:
Migration:
Rollback:
Tests ajoutés:
```

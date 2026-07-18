---
spec_id: meta.dependency_map
version: 1.0.0
status: normative
depends_on:
  - meta.specification_standard
---

# Dependency Map

## Graphe logique

```mermaid
flowchart TD
  META["Specification Standard"] --> PRODUCT["Product Vision"]
  META --> COMBAT["Combat System"]
  PRODUCT --> CLASSES["Classes / Evolutions"]
  COMBAT --> CLASSES
  COMBAT --> MONSTERS["Monsters"]
  CLASSES --> ENCOUNTERS["Encounters / Maps"]
  MONSTERS --> ENCOUNTERS
  PRODUCT --> WORLD["World Bible"]
  WORLD --> ENCOUNTERS
  ENCOUNTERS --> QUESTS["Quests"]
  QUESTS --> REWARDS["Items / Economy"]
  COMBAT --> NETWORK["Online Contracts"]
  REWARDS --> NETWORK
  NETWORK --> DAT["Technical Architecture"]
```

## Chargement minimal par type de tâche

| Tâche | Modules obligatoires |
|---|---|
| ajouter une compétence | standard, combat, classe ou évolution propriétaire |
| ajouter un monstre | standard, combat, catalogue monstre, map cible |
| modifier une map | standard, exploration, monde, monstres et quêtes référencés |
| modifier une récompense | progression, économie, objets, quête/monstre source |
| générer un client | UX, contenu, contrats online, exigences non fonctionnelles |
| générer un serveur | combat, économie, modèle de domaine, contrats et sécurité |

## Règle anti-couplage

Une classe ne référence jamais directement une map. Une map référence les
monstres qu’elle accueille. Une quête peut référencer classes, maps, monstres et
objets, mais ces modules ne dépendent pas de la quête. Cela permet de supprimer
ou remplacer une quête sans modifier le gameplay fondamental.

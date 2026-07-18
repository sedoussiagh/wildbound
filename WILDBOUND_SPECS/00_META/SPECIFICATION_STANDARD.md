---
spec_id: meta.specification_standard
version: 1.0.0
status: normative
depends_on: []
---

# Specification Standard

## Rôle

Définir comment lire, modifier et transformer ce corpus en code ou en données.

## Niveau normatif

Les mots `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT` et `MAY` expriment le degré
d’obligation. En cas de contradiction, l’ordre de priorité est :

1. invariants de sécurité et de protection des mineurs ;
2. invariants économiques et autorité serveur ;
3. spécification du module le plus spécifique ;
4. règles d’un système transversal ;
5. vision produit et exemples non normatifs.

Une contradiction non résolue bloque la génération. Elle ne doit pas être
arbitrée silencieusement par un outil.

## Métadonnées requises

Chaque nouveau module commence par :

```yaml
spec_id: category.stable_snake_case_id
version: 1.0.0
status: draft | review | normative | deprecated
depends_on:
  - other.spec_id
```

`spec_id` ne change jamais après publication. Une modification compatible
augmente la version mineure ; un changement de contrat augmente la version
majeure et fournit une migration.

## Sections minimales d’un module de contenu

- `Intent` : fonction du contenu dans l’expérience.
- `Identity` : nom affiché anglais et identifiant stable.
- `Rules` : comportement précis.
- `Data contract` : champs requis et contraintes.
- `Dependencies` : références externes.
- `Invariants` : faits qui ne peuvent pas devenir faux.
- `Acceptance criteria` : scénarios vérifiables.
- `Open questions` : décisions non prises, jamais présentées comme implémentées.

## Granularité et ownership

Le plus petit agrégat éditorial indépendant est : une classe avec ses six
compétences de base, une évolution avec ses deux compétences et son ultime, un
monstre, une map, une quête ou un système. Une valeur de compétence se modifie
uniquement dans son fichier propriétaire ; elle ne doit pas être recopiée dans un
autre module runtime. Les catalogues résument et référencent, sans devenir une
seconde source chiffrée.

## Conventions d’identifiants

| Type | Format | Exemple |
|---|---|---|
| classe | `class.<id>` | `class.wolf_guardian` |
| évolution | `evolution.<id>` | `evolution.iron_wolf` |
| compétence | `skill.<id>` | `skill.claw_strike` |
| monstre | `monster.<id>` | `monster.moss_slime` |
| map | `map.<id>` | `map.whispering_woods` |
| quête | `quest.<id>` | `quest.a_seed_of_memory` |
| objet | `<kind>.<id>` | `resource.moss_gel` |
| NPC | `npc.<id>` | `npc.elder_rowan` |
| événement | `<domain>_<action>_<result>` | `combat_match_completed` |

Les identifiants sont ASCII, en `snake_case`, et indépendants du texte traduit.

## Noms affichés et localisation

- Les noms propres de contenu MUST rester en anglais dans toutes les langues.
- Les descriptions, tutoriels et messages système MUST être localisables.
- Une clé de traduction suit `<domain>.<id>.<field>`.
- Un nom anglais n’est pas traduit, mais peut être translittéré si une locale
  l’exige légalement ou techniquement.

## Valeurs absentes

`TBD` signifie qu’une décision est requise. Un générateur MUST échouer si un
`TBD` influence une règle, une sauvegarde ou un contrat réseau. Il MAY utiliser
un placeholder pour l’art, l’audio ou un texte non fonctionnel.

## Critère d’acceptation d’un changement

Un changement modulaire est recevable si ses dépendances sont à jour, ses liens
sont valides, ses invariants restent satisfaits et ses effets sur progression,
économie, accessibilité, localisation, télémétrie et migration sont documentés.

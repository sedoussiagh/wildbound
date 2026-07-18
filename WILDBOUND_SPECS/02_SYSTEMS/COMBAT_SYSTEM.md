---
spec_id: system.combat
version: 1.0.0
status: normative
depends_on:
  - product.vision
  - meta.glossary
---

# Combat System

## Intent

Combat tactique au tour par tour inspiré de la lisibilité de Dofus, allégé pour
mobile. Un combat standard dure 3–7 minutes ; un boss 8–12 minutes. Les règles
sont déterministes et le serveur est la seule autorité.

## Plateau

- Grille standard : `7 × 7`; boss : `9 × 9`.
- Une unité vivante par case finale.
- Un allié peut être traversé mais pas occupé.
- Obstacle haut : bloque mouvement et ligne de vue.
- Obstacle bas : bloque mouvement, pas la ligne de vue.
- Une case dangereuse doit avoir couleur, motif et icône.
- Zones de placement : six cases par équipe, sélection pendant 15 secondes.

## Tour et ressources

- Chaque unité commence son tour avec `3 AP` et `3 MP`, sauf modificateur.
- Les AP et MP non dépensés ne sont pas conservés.
- Timer : 35 s PvE, 25 s PvP ; avertissement visuel à 8 s.
- Deux expirations consécutives activent `Auto Guard`.
- Trois expirations déclarent AFK selon le mode.
- `Auto Guard` termine le tour et donne `+10 Guard` jusqu’au prochain tour ; il
  n’attaque jamais automatiquement.

## Statistiques

| Stat | Domaine | Effet |
|---|---:|---|
| `Health` | entier ≥ 1 | vie maximum |
| `Power` | entier ≥ 0 | dégâts, soins et boucliers |
| `Guard` | entier ≥ 0 | mitigation des dégâts |
| `Speed` | entier ≥ 0 | ordre initial et départages |
| `Focus` | 0–100 | puissance des statuts, plafonnée par effet |
| `Resolve` | 0–100 | résistance aux contrôles, plafonnée |

Ordre initial : `Speed` décroissante, puis seed de match. `Speed` ne donne jamais
de tour supplémentaire.

## Formules

```text
raw_damage = skill_power + floor(attacker.Power × scaling)
mitigation = 100 / (100 + max(0, defender.Guard))
final_damage = max(1, floor(raw_damage × mitigation × modifiers))
heal = floor((skill_power + source.Power × scaling) × modifiers)
shield = floor(skill_power + source.Power × scaling)
```

- Aucun jet aléatoire de dégâts.
- Critique seulement si explicitement défini ; multiplicateur `1.5`.
- Modificateurs cumulés plafonnés entre `-40 %` et `+50 %`.
- Le bouclier absorbe avant `Health`; plusieurs boucliers expirent du plus ancien
  au plus récent et ne fusionnent que si la compétence le précise.
- Un soin ne dépasse pas `max_health`; l’excédent est perdu.

## Mouvement et ciblage

- Distance par défaut : Manhattan.
- Un trajet coûte 1 MP par case et doit être continu.
- Une compétence spécifie `range`, `shape`, besoin de ligne de vue et cibles.
- L’UI prévisualise coût, cases valides, résultat exact et effets avant validation.
- Après confirmation, une action n’est annulable que si le serveur la refuse.
- Un déplacement forcé ne consomme pas de MP et ne déclenche qu’une fois chaque
  case d’entrée traversée.

## États standards

| État | Règle |
|---|---|
| `Shielded` | réserve chiffrée absorbant les dégâts |
| `Taunted` | une attaque directe vise la source si elle est légale |
| `Slowed` | `-1 MP` au prochain tour, minimum 1 |
| `Rooted` | mouvement volontaire interdit ; déplacement forcé autorisé |
| `Poisoned` | dégâts fixes au début du tour, maximum 3 stacks |
| `Marked` | prochain coup reçu `+20 %`, puis consommation |
| `Hidden` | non ciblable au-delà de 2 cases ; dissipé en attaquant |
| `Immovable` | immunité aux déplacements forcés |
| `Downed` | ne joue plus ; relevable en PvE |
| `Control Guard` | `+50 Resolve` pendant un tour après contrôle dur |

Un contrôle dur ne peut empêcher plus d’un tour complet consécutif. L’immunité
ou `Control Guard` doit être visible avant le ciblage.

## Terrains

| Terrain | Résolution |
|---|---|
| `Burning` | 8 dégâts en fin de tour, durée 2 tours |
| `Mist` | portée maximum 2 vers/depuis la case |
| `Thorns` | 6 dégâts à l’entrée volontaire |
| `Healing Bloom` | soigne 8 en fin de tour puis disparaît |
| `Ice` | premier déplacement continue d’une case si libre |
| `Crystal` | `+10 Guard` si l’unité n’a pas bougé ce tour |

Une case ne contient qu’un terrain principal. Le nouveau terrain remplace
l’ancien après résolution des effets d’entrée déjà déclenchés.

## Loadout

- 4 compétences actives + 1 ultime d’évolution.
- Au moins une active coûte 1 AP.
- Trois presets par héros.
- Modification hors combat uniquement.
- Le MVP débloque six compétences de base ; chaque évolution en ajoute deux.
- En PvP normalisé, valeurs d’équipement et niveau sont remplacés par un template.

## Spirit et ultime

- Jauge de 0 à 100, remise à zéro au début du combat.
- `+15` au début de chaque tour après le premier.
- `+5` quand un allié reçoit des dégâts, une fois par tour.
- `+10` pour l’action identitaire de classe, une fois par tour.
- Une ultime coûte 100 et ne peut être utilisée qu’une fois par combat standard.

## Défaite PvE

À 0 Health, un héros devient `Downed` pendant deux tours. Un allié adjacent peut
dépenser 2 AP pour le relever à 30 % Health. Après la fenêtre, il est retiré du
combat. Une défaite d’équipe ramène au checkpoint sans perte de monnaie ni des
objets déjà confirmés.

## Scaling coopératif

La difficulté est fixée au lancement : Health ennemie ×1.0 solo, ×1.65 duo,
×2.2 trio. Les mécaniques ne disparaissent pas, mais les exigences simultanées
peuvent être réduites en solo. Les récompenses sont personnelles.

## Contrat d’action abstrait

Chaque action possède `action_id`, `actor_id`, `type`, `target`,
`expected_state_version`, `protocol_version`. Le serveur valide dans l’ordre :
authentification, match, version, idempotence, tour, acteur, ressources, cible,
effet. Une erreur ne consomme aucune ressource.

## Invariants

- AP/MP/Health ne deviennent jamais négatifs.
- Deux unités ne terminent jamais sur la même case.
- Même seed + état + actions = même état final.
- Un `action_id` n’est appliqué qu’une fois.
- Le client ne déclare ni dégâts, ni victoire, ni loot.
- Un boss télégraphie toute zone majeure un tour avant impact.

## Acceptance criteria

- Une cible illégale renvoie une erreur stable sans modifier l’état.
- Une reconnexion restitue snapshot et 20 dernières actions.
- Le calcul de preview client correspond au résultat serveur pour les règles
  publiques, sans devenir source d’autorité.
- Chaque état possède icône, texte, durée et alternative non colorimétrique.

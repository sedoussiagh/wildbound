---
spec_id: class.wolf_guardian
version: 1.0.0
status: normative
depends_on:
  - class.catalog
  - system.combat
---

# Wolf Guardian

## Identity

- Content ID : `class.wolf_guardian`
- Display name : `Wolf Guardian`
- Animal : wolf
- Role : protector / positional control
- Difficulty : easy
- Evolution IDs : `evolution.iron_wolf`, `evolution.shadow_wolf`

`Wolf Guardian` protège par placement, bouclier et redirection. Son joueur doit
se sentir utile avant même d’infliger des dégâts. Sa faiblesse est la portée et
la difficulté à protéger deux fronts éloignés.

## Base stats — level 1

| Health | Power | Guard | Speed | Focus | Resolve |
|---:|---:|---:|---:|---:|---:|
| 125 | 18 | 16 | 8 | 6 | 12 |

## Identity action

Une fois par tour, accorder un bouclier à un allié ou rediriger ses dégâts donne
`+10 Spirit`. Se protéger soi-même ne compte que si aucun allié vivant n’est
présent. Le gain est décidé à la résolution effective, pas au cast.

## Base skills

### Claw Strike

- ID : `skill.claw_strike`
- 1 AP, range 1, single enemy, cooldown 0.
- Damage : `20 + floor(Power × 0.8)`, puis mitigation.
- Intention : action fiable quand les autres outils sont indisponibles.

### Howl Guard

- ID : `skill.howl_guard`
- 2 AP, range 3, self or ally, cooldown 2.
- Shield : `24 + floor(Power × 0.7)`, duration 2 owner turns.
- La ligne de vue est requise. Réutiliser remplace uniquement le bouclier de
  cette même compétence si la nouvelle valeur est supérieure.

### Pack Pull

- ID : `skill.pack_pull`
- 2 AP, range 3 en ligne, enemy, cooldown 2.
- Damage : `12 + floor(Power × 0.5)`.
- Après dégâts, attire d’une case si destination libre et cible non `Immovable`.
- Le sort reste légal si l’attraction est impossible ; preview l’indique.

### Guard Step

- ID : `skill.guard_step`
- 1 AP, self movement, cooldown 2.
- Se déplace d’une case libre vers un allié choisi à range 3, puis `+8 Guard`
  jusqu’au début du prochain tour.
- Ne traverse pas obstacle haut et ne déclenche pas `Thorns` sur la case de départ.

### Challenge Roar

- ID : `skill.challenge_roar`
- 2 AP, radius 1 autour du lanceur, cooldown 3.
- Applique `Taunted` pendant le prochain tour de chaque ennemi affecté, après
  test Resolve. Les boss peuvent convertir l’effet en `-10 % Power` un tour.

### Shared Hide

- ID : `skill.shared_hide`
- 2 AP, range 2, single ally, cooldown 3.
- Pendant 2 tours de la cible, 30 % des dégâts directs après mitigation sont
  transférés au Wolf. Le transfert ne se retransfère jamais et ne peut tuer le
  Wolf en dessous de 1 Health ; le surplus reste sur l’allié.

## Play patterns

- Débutant : `Howl Guard` → approcher → `Challenge Roar` → `Claw Strike`.
- Coop : protéger une cible fragile avec `Shared Hide`, puis contrôler l’espace.
- Solo : `Pack Pull` réduit la distance ; la Guard compense le faible Power.

## Balance boundaries

- Aucun bouclier de base ne doit annuler plus d’une attaque standard équivalente.
- `Shared Hide` ne s’applique pas au poison, terrain ou coût de sacrifice.
- Le Wolf ne possède pas de soin complet dans son kit.
- Ses déplacements longue portée appartiennent seulement à `Shadow Wolf`.

## Visual/audio direction

Silhouette large, épaules protectrices, animations de cercle et de meute. Les
boucliers utilisent un contour de feuilles, jamais une bulle opaque masquant le
pelage. Sons graves mais chaleureux, sans grognement agressif réaliste.

## Acceptance criteria

- Protéger un allié augmente Spirit au maximum une fois par tour.
- `Pack Pull` inflige ses dégâts même contre une cible `Immovable`.
- Une chaîne de redirections ne peut pas boucler.
- Le tutoriel solo est gagnable avec `Claw Strike` et `Howl Guard` seulement.

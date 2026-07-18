---
spec_id: class.fox_mystic
version: 1.0.0
status: normative
depends_on:
  - class.catalog
  - system.combat
---

# Fox Mystic

## Identity

- Content ID : `class.fox_mystic`
- Display name : `Fox Mystic`
- Animal : fox
- Role : ranged damage / terrain controller
- Difficulty : medium
- Evolution IDs : `evolution.flame_fox`, `evolution.mist_fox`

Le Fox transforme le plateau et gagne en planifiant. Il possède la meilleure
portée de base, mais faible Health/Guard et dépend de son positionnement.

## Base stats — level 1

| Health | Power | Guard | Speed | Focus | Resolve |
|---:|---:|---:|---:|---:|---:|
| 100 | 24 | 8 | 12 | 14 | 8 |

## Identity action

Créer un terrain qui affecte une unité, révéler une cible ou appliquer un
contrôle effectif accorde `+10 Spirit`, une fois par tour. Replacer un terrain
sans effet immédiat ne donne pas de Spirit.

## Base skills

### Spark Bolt

- ID `skill.spark_bolt`; 1 AP; range 4; single enemy; cooldown 0.
- Damage `18 + floor(Power × 0.75)`; ligne de vue requise.

### Cinder Trap

- ID `skill.cinder_trap`; 2 AP; range 4; single tile; cooldown 2.
- Pose `Burning` pendant 2 tours. Si une unité occupe la case, inflige d’abord
  `8 + floor(Power × 0.4)`, puis pose le terrain.

### Quickstep

- ID `skill.quickstep`; 1 AP; teleport up to 2; cooldown 2.
- Case visible, libre et dans ligne de vue. Ne déclenche pas les terrains des
  cases traversées, mais déclenche la case d’arrivée.

### Trick Mark

- ID `skill.trick_mark`; 1 AP; range 3; single enemy; cooldown 2.
- Applique `Marked` 2 tours ; le prochain hit reçoit +20 %, puis consomme.
- Réappliquer renouvelle la durée, sans augmenter le bonus.

### Tail Sweep

- ID `skill.tail_sweep`; 2 AP; cone 3 adjacent; cooldown 2.
- Damage `14 + floor(Power × 0.55)` et push 1 en ordre proche→loin.
- Une collision contre obstacle annule le push, sans dégâts de collision.

### Spirit Lantern

- ID `skill.spirit_lantern`; 2 AP; range 3; radius 1; cooldown 3.
- Révèle `Hidden` et donne `+8 Focus` aux alliés pendant 2 tours.
- La lanterne est un effet instantané, pas une unité ciblable.

## Balance boundaries

- Le Fox ne doit pas cumuler dégâts élevés, mobilité et contrôle dans une même
  action de base.
- Sa survie dépend de distance et terrain ; pas de bouclier personnel permanent.
- `Spark Bolt` reste inférieur au burst conditionnel d’une évolution.

## Acceptance criteria

- Tout terrain montre durée et ordre de résolution.
- `Quickstep` ne traverse aucun contrôle qui interdit explicitement la
  téléportation.
- `Tail Sweep` résout les cibles dans un ordre déterministe.
- Le tutoriel explique au moins une interaction terrain + déplacement.

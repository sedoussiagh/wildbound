---
spec_id: class.bunny_healer
version: 1.0.0
status: normative
depends_on:
  - class.catalog
  - system.combat
---

# Bunny Healer

## Identity

- Content ID : `class.bunny_healer`
- Display name : `Bunny Healer`
- Animal : rabbit
- Role : healing / ally mobility
- Difficulty : easy
- Evolution IDs : `evolution.bloom_bunny`, `evolution.gale_bunny`

Le Bunny garde le groupe actif et corrige le placement. Il ne doit pas rendre un
healer obligatoire : ses soins sont utiles mais limités par AP et cooldowns.

## Base stats — level 1

| Health | Power | Guard | Speed | Focus | Resolve |
|---:|---:|---:|---:|---:|---:|
| 110 | 20 | 10 | 14 | 12 | 12 |

## Identity action

Un soin effectif sur un allié ou un repositionnement d’allié donnant un avantage
accorde `+10 Spirit`, une fois par tour. L’overheal seul ne compte pas.

## Base skills

### Carrot Jab

- ID `skill.carrot_jab`; 1 AP; range 1; cooldown 0.
- Damage `18 + floor(Power × 0.7)`.

### Kindle Bloom

- ID `skill.kindle_bloom`; 2 AP; range 3; ally/self; cooldown 1.
- Heal `22 + floor(Power × 0.75)`; ligne de vue requise.

### Hop Away

- ID `skill.hop_away`; 1 AP; jump up to 2; cooldown 2.
- Ignore unités et obstacles bas, pas les obstacles hauts ; déclenche terrain
  d’arrivée uniquement.

### Clean Paws

- ID `skill.clean_paws`; 2 AP; range 3; ally/self; cooldown 3.
- Retire un effet négatif selon priorité : contrôle dur, poison, marked, slow.
- Le joueur voit l’effet qui sera retiré avant cast.

### Quick Snack

- ID `skill.quick_snack`; 1 AP; self; once per battle.
- Heal `14 + floor(Power × 0.4)`; ne peut cibler personne d’autre.

### Lucky Foot

- ID `skill.lucky_foot`; 2 AP; range 3; single ally; cooldown 2.
- `+1 MP` et `+10 Resolve` au prochain tour de la cible.
- Plusieurs instances renouvellent la durée sans cumuler les valeurs.

## Balance boundaries

- Les soins ne compensent pas indéfiniment tous les dégâts entrants.
- Le Bunny doit toujours disposer d’une action offensive simple.
- Aucun revive à distance dans le kit de base.
- Sa mobilité personnelle est forte, sa Guard reste moyenne.

## Acceptance criteria

- L’UI affiche soin effectif et overheal séparément.
- `Clean Paws` retire toujours le même effet dans le même état.
- `Quick Snack` ne peut être utilisé deux fois après reconnexion.
- Le contenu solo reste gagnable sans spam de soins infini.

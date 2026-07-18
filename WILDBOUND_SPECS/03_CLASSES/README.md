---
spec_id: class.catalog
version: 1.0.0
status: normative
depends_on:
  - system.combat
  - system.evolution
---

# Class Catalog

## Matrice MVP

| Class | Primary role | Difficulty | Level 10 branches | Identity action |
|---|---|---:|---|---|
| `Wolf Guardian` | protector/control | 1/3 | `Iron Wolf`, `Shadow Wolf` | shield or redirect ally damage |
| `Fox Mystic` | damage/terrain | 2/3 | `Flame Fox`, `Mist Fox` | apply terrain or control |
| `Bunny Healer` | heal/mobility | 1/3 | `Bloom Bunny`, `Gale Bunny` | effective heal or ally reposition |

## Règles communes

- Le joueur est l’animal ; la classe n’est ni un compagnon ni une créature
  capturée.
- La classe est permanente après confirmation de création.
- Chaque classe commence avec six compétences et deux branches.
- Loadout : quatre actives ; branche active fournit deux actives et une ultime.
- Chaque classe doit pouvoir finir l’histoire solo avec son propre kit.
- Une composition tank/heal/damage n’est jamais obligatoire.
- Toute branche possède une force claire, une limite exploitable et au moins deux
  réponses adverses lisibles.

## Budget d’équilibrage niveau 1

Health `100–125`, Power `18–24`, Guard `8–16`, Speed `8–14`. Une compétence
à 1 AP sans cooldown assure toujours une action utile. Une compétence de mobilité
est disponible dans le kit de base ou la branche.

## Ajout d’une classe

Créer un dossier depuis `99_TEMPLATES/CLASS_TEMPLATE.md`, puis deux fichiers
d’évolution. L’ajout est `post-MVP` tant qu’il n’existe pas : tutoriel, 6+2+2
compétences, 2 ultimes, animations, ancrages cosmétiques, scénario solo, tests de
matchups et localisation.

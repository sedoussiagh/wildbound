---
spec_id: monster.the_hollow_stag
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# The Hollow Stag

## Identity

ID `monster.the_hollow_stag`; family `Hollow`; boss; levels 12–20. Antagoniste du
donjon MVP, cerf majestueux dont les bois vides projettent des souvenirs brisés.
Le combat teste terrain, regroupement et lecture des intentions.

## Base stats

Health 720, Power 28, Guard 18, Speed 10, 3 AP, 3 MP. Grille 9×9. Le boss ne peut
pas être déplacé de plus d’une case par action et convertit Root en Slow.

## Phase 1 — Remembering, 100 à 71 %

- **Memory Roots**: marque trois cases, puis au tour suivant inflige
  `18 + floor(Power × 0.6)` et Root 1 tour. Au moins deux cases sûres restent
  accessibles à chaque héros.
- **Hollow Charge**: ligne de quatre cases télégraphiée ; impact
  `26 + floor(Power × 0.8)`, push 1. Un cristal bloque la charge et perd son état.

## Phase 2 — Fracture, 70 à 36 %

Au seuil, **Crown of Thorns** convertit quatre cases périphériques en `Thorns`
pendant trois tours et invoque un `Root Wisp` en duo/trio uniquement. Le boss
alterne Roots et Charge ; jamais les deux impacts au même tour.

## Phase 3 — Empty Antlers, 35 à 0 %

- **Empty Antlers**: télégraphe deux cônes opposés. Au tour suivant, damage
  `30 + floor(Power × 0.9)` et retire un buff positif. Les quatre cases latérales
  sont sûres et mises en évidence.
- Après résolution, le boss perd 8 Guard jusqu’au prochain tour : fenêtre de
  contre-attaque.

## Deterministic state machine

`roots_telegraph → roots_resolve → basic → charge_telegraph → charge_resolve`.
Les transitions de phase remplacent `basic` suivant. La seed choisit orientation
parmi les options légales, sans supprimer une case sûre.

## Solo adaptations

Pas de `Root Wisp`; deux cases Root au lieu de trois ; durée des `Thorns` deux
tours. Dégâts et séquence restent identiques pour préserver l’apprentissage.

## Drops per eligible player

- `Hollow Antler` 100 % ×1, trophée lié.
- `Wild Mirror Fragment` 35 % ×1, lié.
- `Paw Coins` 100 % ×80–110.
- Première victoire de quête : `Hollow Antler Arch` via claim séparé.

## Failure and checkpoint

Défaite replace à `Stag Gate`; les deux premières salles restent validées pendant
la session du donjon. Le boss recommence à pleine Health, sans reconsommer une
clé. Une option permet de revoir les mécaniques avant nouvelle tentative.

## Acceptance criteria

- Aucun tour ne combine deux impacts majeurs.
- Chaque télégraphe est compréhensible sans couleur.
- Le mode solo est gagnable par les six évolutions au niveau 15 avec équipement
  de biome, selon simulation de référence.
- Les récompenses sont réclamées exactement une fois par `match_id`.
- Reconnexion restaure phase, télégraphes, terrains et ordre d’action.

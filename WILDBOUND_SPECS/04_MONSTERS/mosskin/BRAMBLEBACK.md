---
spec_id: monster.brambleback
version: 1.0.0
status: normative
depends_on:
  - monster.catalog
---

# Brambleback

## Identity

ID `monster.brambleback`; family `Mosskin`; boss; levels 7–12. Sanglier massif
couvert de ronces. Première vérification de maîtrise du déplacement et des zones.

## Base stats

Health 480, Power 22, Guard 14, Speed 5, 3 AP, 3 MP. Grille 9×9 en solo ou 7×7
événement court. Scaling coopératif standard.

## Phase 1 — 100 à 61 % Health

- **Rooted Charge**: prépare une ligne de 5 cases, puis charge au tour suivant.
  Impact `28 + floor(Power × 0.9)`, push 2. Se cogner à un obstacle après avoir
  raté étourdit le boss jusqu’à son prochain tour et retire 10 Guard.
- **Tusk Sweep**: 2 AP, cone adjacent, damage `16 + floor(Power × 0.6)`, push 1.

## Phase 2 — 60 à 31 %

Au seuil, **Thorn Ring** crée un anneau de `Thorns` à distance 2 pendant deux
tours et invoque deux `Moss Buds`. Puis alterne charge et sweep. Le centre reste
sûr pour éviter toute situation sans issue.

## Phase 3 — 30 à 0 %

**Raging Tusk** remplace le sweep : 3 AP, deux arcs opposés télégraphiés, damage
`22 + floor(Power × 0.8)`. Le boss perd 6 Guard et gagne 1 MP. Une seule action
majeure par tour.

## State machine

`select_charge` → `telegraph` → `resolve_charge` → `recover` → `sweep`; les
transitions de seuil s’insèrent après une action complète, jamais au milieu.

## Drops per eligible player

`Bramble Core` 100 % ×1, lié ; `Paw Coins` 100 % ×45–60. Première victoire de
quête garantit aussi le crédit de `The Wild Mirror`, sans drop supplémentaire.

## Accessibility

Charge : flèches + empreintes + son rythmique + vibration optionnelle. Phase
change : bannière texte, animation courte skippable et nouvelle couleur de ronce
accompagnée d’un motif.

## Acceptance criteria

- Chaque charge laisse au moins deux cases sûres atteignables pour un héros à
  3 MP au moment du télégraphe.
- Les transitions ne donnent pas un tour supplémentaire au boss.
- Une déconnexion/reconnexion ne répète ni spawn ni récompense.
- Le combat est terminable par chacune des trois classes en solo au niveau 10.

---
spec_id: product.mvp_scope
version: 1.0.0
status: normative
depends_on:
  - product.vision
---

# MVP Scope

## Inclus

- Plateformes : Android et iOS ; interface portrait non supportée.
- Niveau maximum : 20.
- 3 classes, 6 évolutions de niveau 10.
- 5 maps : hub, zone d’aventure, donjon, tanière et arène.
- 12 monstres dont 2 boss.
- Combat PvE solo, duo et trio.
- Duel PvP amical 1v1 avec option de normalisation.
- Personnalisation du pelage, accessoires et quatre emplacements d’équipement.
- Amis, groupe, guildes simples, phrases rapides, block et report.
- Tanière décorée, visite sur invitation et showcase.
- Crafting simple, commerce direct restreint au niveau 10.
- Français et anglais au lancement.

## Hors MVP

- Ranked 3v3, raids 6 joueurs et `Trade Post` global.
- Classes `Bear Bruiser`, `Owl Ranger`, `Otter Artificer`.
- Formes avancées de niveau 30.
- Biomes au-delà de `Moonroot Hollow`.
- Élevage, capture, marketplace premium ou cross-trade.

## Vertical slice obligatoire avant production complète

1. Créer un héros `Wolf Guardian`.
2. Personnaliser couleur et motif.
3. Voir d’autres joueurs dans `Oakheart Village`.
4. Lancer un combat autoritaire contre `Moss Slime`.
5. Se déplacer, utiliser `Claw Strike`, terminer et recevoir une récompense.
6. Placer `Moss Lamp` dans `Willow Den`.
7. Quitter, revenir et retrouver le même état.

## Exit criteria MVP

- Le contenu principal est terminable solo.
- Aucun achat ne modifie une statistique ou récompense de combat.
- Reconnexion et idempotence empêchent doubles récompenses.
- Les parcours critiques sont utilisables avec texte agrandi, réduction de
  mouvement, alternatives couleur et contrôles tactiles accessibles.
- Les outils block/report sont fonctionnels avant le chat libre.

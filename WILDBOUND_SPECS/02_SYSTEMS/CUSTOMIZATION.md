---
spec_id: system.customization
version: 1.0.0
status: normative
depends_on:
  - product.vision
  - system.evolution
---

# Hero Customization

## Création

Le joueur choisit classe, nom, couleur principale, couleur secondaire, couleur
des yeux et motif. Le héros reste clairement identifiable comme son animal et sa
classe à petite taille d’écran.

## Couches visuelles

1. silhouette de classe ;
2. forme d’évolution ;
3. palette de pelage ;
4. motif ;
5. yeux ;
6. équipements `Charm`, `Cloak`, `Band`, `Badge` ;
7. cosmétique de tête/corps ;
8. effet de pas et emote.

Les couches 3–8 ne modifient aucune statistique. Les objets doivent déclarer les
silhouettes compatibles et points d’ancrage. Une incompatibilité masque l’objet
dans l’équipement, pas dans l’inventaire.

## Lisibilité tactique

- L’équipe et le contour de sélection priment sur la palette du pelage.
- Les accessoires ne masquent pas les indicateurs d’état.
- Les effets premium respectent le mode « effets réduits ».
- Une option remplace les apparences adverses par des silhouettes standards.

## Nom du héros

Longueur 3–16 caractères visibles, Unicode normalisé, filtrage et réservation
côté serveur. Les noms de contenu anglais sont réservés. Une violation renvoie
une raison neutre et permet une nouvelle saisie sans perdre la personnalisation.

## Invariants

- Changer d’apparence ne change jamais le combat ou la rareté de loot.
- Évoluer conserve couleurs, motif, nom et historique.
- Tout achat cosmétique propose un aperçu sur les six branches MVP.
- Les palettes restent distinguables en principaux modes de daltonisme.

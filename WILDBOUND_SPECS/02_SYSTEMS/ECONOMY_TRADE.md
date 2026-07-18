---
spec_id: system.economy_trade
version: 1.0.0
status: normative
depends_on:
  - system.progression
  - product.vision
---

# Economy and Trade

## Monnaies

| ID | Source | Usage | Échangeable |
|---|---|---|---|
| `currency.paw_coins` | jeu normal | vendors, crafting | non |
| `currency.leaf_tokens` | événement/saison | boutique événement | non |
| `currency.guild_acorns` | objectifs de guilde | décor et bannière | non |
| `currency.moon_gems` | achat réel | cosmétiques premium | non |

`Moon Gems` ne peuvent jamais acheter ou devenir un objet échangeable.

## Crafting

Métiers communs : `Tailoring`, `Woodwork`, `Alchemy`. Une recette consomme 1–3
ressources, réussit toujours et produit immédiatement. Aucun minuteur accélérable
par paiement, durabilité ou affixe aléatoire.

## Loot

- Ressource commune garantie quand spécifiée.
- Chances publiées dans le codex.
- Loot individuel en groupe, sans Need/Greed.
- Pity visible réservé aux cosmétiques gratuits.
- Les trophées majeurs peuvent être liés au compte.

## Trade direct

Conditions : niveau 10, compte lié, âge du compte ≥72 h, aucune restriction.
Tradeable : ressources standard, décorations fabriquées, teintures communes.
Interdit : équipement, monnaie, `Morphstone`, fragments, récompenses de quête ou
saison et achats premium.

Flux : proposition → offres → verrouillage → récapitulatif obligatoire 5 s → deux
confirmations → transaction atomique. Toute modification réinitialise les deux
confirmations. Expiration après 10 minutes d’inactivité.

## Ledger et idempotence

Chaque mutation enregistre compte, actif, delta, solde après, source,
`idempotency_key`, horodatage et version. Un solde ne devient jamais négatif. Une
transaction échoue totalement si un élément a changé.

## Anti-abus

Limites journalières basées sur valeur serveur, détection des flux circulaires,
nouveaux comptes et écarts de prix. Une alerte ne confisque jamais automatiquement
un objet sans procédure de modération.

## Invariants

- Aucun pouvoir acheté.
- Aucun double claim après reconnexion.
- Tout objet affiche lié/échangeable avant acquisition.
- Toute modification d’une offre annule les confirmations.
- Les logs d’audit ne contiennent pas de token ni message privé complet.

---
spec_id: system.monetization
version: 1.0.0
status: normative
depends_on:
  - system.economy_trade
  - system.customization
  - system.retention_liveops
---

# Monetization

## Allowed products

Outfits, fur patterns, footsteps, emotes, den decoration packs and optional
cosmetic season pass. Every product is previewable on base form and six MVP
evolutions. Purchase uses platform-native confirmation and server receipt
validation.

## Forbidden products

Stats, XP, skills, evolution choice, Morphstone, combat retry, loot chance,
tradeable asset, energy, paid random loot box, paid queue priority, safety feature
or removal of intentionally created friction.

## Pricing and presentation

Full localized store price, contents, ownership and refund/support path. No false
discount, artificial urgency, preselected purchase, confusing multi-currency or
different hidden price by spending behavior. Parental/platform controls apply.

## Moon Gems

Premium currency is bound and not convertible to gameplay/trade assets. Balance
and entitlement are server-owned. Purchase failure or pending state never grants
an item optimistically.

## Season pass

Cosmetic only, no purchase of power. If XP boosts are ever considered, they are
out of scope and require a major spec review because they conflict with current
anti-objectives.

## Acceptance criteria

- Une capture d’écran de l’offre suffit à comprendre prix et contenu.
- Aucune route premium ne réduit le temps d’obtention d’une puissance.
- Restore purchases works without duplicate entitlement.
- Shop can be disabled without blocking inventory or base game.

---
spec_id: online.shared_world
version: 1.0.0
status: normative
depends_on:
  - product.vision
  - system.exploration
---

# Shared World and Presence

## World model

Social/adventure maps are sharded instances with many players; battles and dens
are separate authoritative instances. The world feels continuous through stable
party routing, visible entrances and return points, not by putting all players in
one simulation.

## Capacity and interest

- `Oakheart Village`: 50 players.
- `Whispering Woods`: 30 players.
- Dens: 8; dungeon: party of 3; duel: 2.
- Presence updates prioritize nearby players and party members.
- Distant avatars use reduced update rate and simplified visuals.

## Presence state

Server-owned position, facing, locomotion, emote, interaction state, party badge
and coarse activity. Appearance is a versioned snapshot. Client predicts local
movement visually, but server corrects invalid speed or teleport.

## Instance routing

Party leader’s compatible instance is preferred. If full, move the entire party
to a new instance after confirmation. Friends may request join/teleport; target
must allow it. Block and privacy override routing.

## Reconnection

Social presence retained briefly; reconnect returns to last safe checkpoint if
instance no longer exists. Battle has 30-second reserved presence. No avatar may
remain indefinitely as a ghost.

## Invariants

- A blocked player is excluded from direct join and den visits.
- Client position cannot unlock quest, resource or reward alone.
- Instance IDs are opaque and never used as access control.
- A party split is explicit, not silent.

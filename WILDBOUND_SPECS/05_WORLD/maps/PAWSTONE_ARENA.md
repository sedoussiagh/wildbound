---
spec_id: map.pawstone_arena
version: 1.0.0
status: normative
depends_on:
  - system.combat
  - online.matchmaking
---

# Pawstone Arena

## Contract

- ID `map.pawstone_arena`; PvP; levels 10–20.
- MVP: friendly duel 1v1; capacity model allows future 3v3.
- Grid 7×7; no monster or loot resource.
- Spectating disabled in MVP to reduce privacy and cheating risk.

## Duel flow

Invite → rules screen → both confirm → loadouts lock → placement → up to 12
rounds → result → rematch/leave. Rules choose current or normalized stats. Any
change resets both confirmations.

## Arena layout

Symmetric vertical and horizontal rotation, two low obstacles, two high obstacles,
four neutral terrain anchors. Spawn zones each have six equivalent cells. No map
variant enters rotation without symmetry and matchup review.

## Victory

Eliminate opponent or highest relative Health after round 12. Tiebreak: relative
Health, living units, damage dealt, then draw. Participation grants no farmable
tradeable reward; friendly results do not affect ranked MMR.

## Safety

Only friends or explicit nearby invite by default. Block cancels pending invite.
Quick phrases remain available; free text can be disabled. Leaving before first
turn has no penalty; repeated disconnects only create temporary queue cooldown.

## Acceptance criteria

- Both players receive identical rules hash before placement.
- Normalization removes all purchased/cosmetic effects from calculations.
- Symmetry test produces equivalent reachable cells for both spawns.
- A disconnected player gets 30 s reconnection and `Auto Guard`, never AI attack.

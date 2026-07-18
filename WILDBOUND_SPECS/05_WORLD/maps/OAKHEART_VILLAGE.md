---
spec_id: map.oakheart_village
version: 1.0.0
status: normative
depends_on:
  - world.alderwild
  - world.npc_catalog
  - online.shared_world
---

# Oakheart Village

## Contract

- ID `map.oakheart_village`; kind `social_hub`; levels 1–20.
- Capacity 50 players per instance; no combat grid or hostile spawn.
- Checkpoint `rowan_square`; default login destination if previous map unavailable.

## Spatial layout

`Rowan Square` centralise spawn, story and party finder. Six branches courtes
mènent à `Craft Burrow`, `Trade Post`, `Guild Grove`, `Pawstone Gate`, `Den Portal`
et sortie `Softleaf Gate`. Une boucle extérieure relie les branches sans repasser
par le centre et évite la foule.

## Functional areas

| Area | Service | Unlock |
|---|---|---:|
| `Rowan Square` | story, friends, party finder | 1 |
| `Craft Burrow` | crafting, inventory tutorial | 5 |
| `Trade Post` | direct trade help; market locked MVP | 10 |
| `Guild Grove` | create/join guild | 7 |
| `Den Portal` | own den and visits | 3 |
| `Pawstone Gate` | friendly duel | 10 |
| `Softleaf Gate` | Whispering Woods | 1 |

## Social behavior

Players are rendered by interest radius; maximum 30 full avatars on screen, puis
silhouettes simplifiées. No collision. Quick phrases, emotes, inspect, invite and
block are accessible from a long press. Public free chat follows age/consent.

## Atmosphere

Giant oak, leaf bridges, burrow shops. Day/evening cycle is cosmetic and never
closes a service. Warm acoustic theme; each service has a distinct audio cue that
can be disabled.

## Failure states

If a service is offline, its NPC remains present, explains unavailability and
offers safe return. If instance is full, routing selects another instance while
preserving party members where possible.

## Acceptance criteria

- From spawn, every critical service is reachable in ≤25 seconds.
- A party enters the same adventure instance or receives explicit split choice.
- Blocking a player immediately hides their messages and direct interactions.
- The hub remains navigable at capacity on a low-tier target mobile device.

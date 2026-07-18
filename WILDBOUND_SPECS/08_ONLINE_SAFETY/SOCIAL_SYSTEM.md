---
spec_id: online.social
version: 1.0.0
status: normative
depends_on:
  - online.shared_world
  - online.safety_moderation
---

# Social System

## Relationship layers

- `Nearby`: presence, emotes, allowed chat.
- `Friends`: mutual relation, invites and opt-out online status.
- `Party`: up to 3, shared queue and objectives.
- `Guild`: up to 30 MVP, banner and activities.
- `Block`: immediate unilateral separation.

## Friends

Request can be accepted, declined or ignored. No notification reveals block.
Deleting friendship removes future access but not already earned cosmetic memory.
Online status supports `online`, `friends_only`, `hidden`.

## Party

Leader controls queue, not members’ inventory or quests. A ready check precedes
dungeon/PvP. Leadership transfers if leader leaves. Kicking during active battle
is disabled; report/block remain available.

## Friendship Path

Records mutual milestones such as first dungeon or den visit. Both accounts must
be present and eligible. Rewards are emotes, portrait frames and den objects,
never stats or exchangeable currency.

## Social interaction contract

Every player context menu contains inspect, quick chat, invite/friend, block and
report subject to policy. A blocked user’s existing party/trade is safely ended.

## Acceptance criteria

- Block takes effect within one server round trip across DM, invite, matchmaking
  preference and den visit.
- Hidden status cannot be inferred through friend lists or instance API.
- Social rewards remain after friendship deletion without exposing former friend.

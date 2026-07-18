---
spec_id: world.art_audio
version: 1.0.0
status: normative
depends_on:
  - world.alderwild
  - ux.accessibility
---

# Art and Audio Direction

## Visual target

Stylized 2D three-quarter view, soft shapes, readable silhouette and restrained
detail for mobile. World sprites and tactical units share identity but battle may
use simplified outline/scale for clarity.

## Character production

Each class/evolution requires idle, move 8-direction or equivalent mirrored set,
basic attack, six base skill cues, two evolution skills, ultimate, hit, downed,
revive and emotes. Cosmetics attach to named anchors and are previewed on every
MVP silhouette.

## Monster production

Idle, move, basic, every ability telegraph/resolution, hit, defeat and phase
transition. Telegraph is separate asset/layer from decorative effect. Boss effects
must still read with particles reduced.

## Environment

Tile/object modularity, collision and line-of-sight metadata separated from art.
Every obstacle has high/low readable variant. Interactive nodes have idle and
focus states. Lighting is decorative and cannot hide legal grid information.

## UI style

Leaf/wood forms, high-contrast dark panels, role colors plus icons. Touch states
default/pressed/disabled/focus/error. Avoid tiny ornamental text and opaque effects
over tactical board.

## Audio

Warm acoustic palette with light magical textures. Each skill has selection,
cast and resolution cues; no realistic animal distress. Boss telegraphs use
rhythm and pitch plus visual equivalent. Music transitions at room/phase boundaries
and obeys separate volume.

## Asset contract

Stable asset ID, source license, author, format, dimensions, pivots, anchors,
compression profile, memory estimate, locale dependence and fallback. Missing art
uses clearly marked placeholder without changing collision or timings.

## Acceptance criteria

- Class recognizable at smallest combat zoom without color.
- Effects reduced mode retains all gameplay telegraphs.
- No unlicensed/generated asset enters production without provenance review.
- Audio-off play preserves full information.

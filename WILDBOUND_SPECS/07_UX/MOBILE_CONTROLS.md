---
spec_id: ux.mobile_controls
version: 1.0.0
status: normative
depends_on:
  - system.combat
  - system.exploration
---

# Mobile Controls

## Orientation and safe area

MVP is landscape-only to keep tactical grid and social UI consistent. Reference
logical canvas 1280×720, minimum supported 640×360 logical. All interactive
elements respect notches, rounded corners and system gesture insets.

## Exploration

Default tap-to-move. Optional virtual stick can be left/right, resized 80–140 %
and repositioned. Tap an interactable to approach and interact; second tap cancels
path. Long press opens context menu without triggering movement.

## Combat gesture grammar

1. Tap skill.
2. Legal cells/targets appear.
3. Tap target to show exact preview.
4. Tap `Confirm` or same target again to submit.
5. Tap outside/cancel to return before submit.

Drag may accelerate selection but is never required. Pinch zoom has fixed limits;
two-finger drag pans. One-finger drag never moves camera while choosing a target.

## Touch targets

Minimum 48×48 dp, 8 dp spacing, primary combat actions 56 dp. `End Turn` stays
separate from skills. If AP remain, configurable confirmation or double tap.

## Keyboard/controller fallback

Directional focus covers every menu. Grid uses d-pad/stick, confirm/cancel and
shoulder buttons for skills. Input icons switch without requiring restart.

## Feedback

Every submission gives immediate pressed state, then pending indicator. Server
acceptance plays animation; rejection returns to exact selection with localized
reason. Haptics are optional and never the only feedback.

## Acceptance criteria

- No required gesture uses more than one pointer.
- A player can finish a combat without drag, pinch or long press.
- Controls remain reachable in left-handed layout.
- Rotation attempts pause safely and explain landscape requirement.

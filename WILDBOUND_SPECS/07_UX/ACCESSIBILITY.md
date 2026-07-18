---
spec_id: ux.accessibility
version: 1.0.0
status: normative
depends_on:
  - product.vision
  - ux.mobile_controls
---

# Accessibility

## Visual

- Text scale 100/115/130 %, layouts reflow without clipping.
- Contrast target WCAG AA for text and actionable controls.
- State/danger uses color + pattern + icon + optional label.
- Reduce flashes, particles, shake and parallax independently.
- No sequence above three flashes per second.
- Outline strength and team colors configurable.

## Hearing

Separate master, music, effects, UI and ambience volumes. Subtitles label speaker
and important non-speech audio. Directional sound has visual edge indicator.

## Motor

Tap-to-move and stick, left-handed layout, button scaling, hold/double-tap
alternatives. PvE private groups may choose 60-second turns. No rapid tapping or
timed precision is required outside optional cosmetic interactions.

## Cognitive

Plain language, one consequence per confirmation, persistent glossary, replayable
tutorial, exact preview and reduced-motion transitions. Error messages state what
happened, whether anything changed and next action.

## Screen reader/semantic model

Menus expose role, accessible name, value, selected/disabled state and position.
Combat grid announces coordinate, terrain, occupant, distance and legality in a
consistent order. Decorative art is not focusable.

## Test matrix

Large text + smallest screen; grayscale; deuteranopia/protanopia/tritanopia;
screen reader; switch/keyboard navigation; no audio; reduced motion; 600 ms
network latency.

## Release gate

All onboarding, combat, trade confirmation, report, purchase and account deletion
flows pass manual accessibility review. Known exceptions require owner and date.

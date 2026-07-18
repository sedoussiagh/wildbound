---
spec_id: ux.localization
version: 1.0.0
status: normative
depends_on:
  - meta.specification_standard
  - ux.accessibility
---

# Localization

## Launch locales

English (`en`) and French (`fr`). English is fallback. Locale does not change
server identifiers, matchmaking rules or game balance.

## Proper-name rule

Classes, evolutions, monsters, maps, NPC, skills, items, currencies and named
features remain in English in all locales: `Wolf Guardian`, `The Hollow Stag`,
`Whispering Woods`, `Morphstone`, etc. Grammar around them is translated.

## Keys

`<domain>.<stable_id>.<field>`, for example
`skill.claw_strike.description` or `ui.trade.confirm`. No concatenated sentence;
use placeholders with named variables and plural rules.

## Writing

English plain and concise. French uses consistent tutoiement, short sentences and
non-breaking formatting where supported. Error text says event, consequence and
next action. Gendered NPC text uses locale-approved variants, not improvised
runtime concatenation.

## Pipeline

Extract keys → source review → translation → linguistic QA → pseudo-localization
→ in-context device QA → completeness gate. Missing critical key blocks release;
noncritical missing key falls back to English and emits diagnostic.

## Acceptance criteria

- Proper names match byte-for-byte across locale source values where applicable.
- 130 % French text has no clipping in critical flows.
- Variables cannot inject markup or change an ID.
- Content can add a description without modifying UI code.

---
spec_id: generation.traceability
version: 1.0.0
status: normative
depends_on:
  - generation.brief
---

# Traceability Matrix

| Player outcome | Primary specifications | Required verification |
|---|---|---|
| create animal hero | class catalog, customization, onboarding | class/name/appearance E2E |
| understand first fight | combat, Moss Slime, onboarding | guided battle usability |
| see other players | shared world, Oakheart | 50-avatar load + privacy |
| fight tactically | combat, class/evolution, monster | golden/property/network |
| choose evolution | evolution system + six branch files | comparison + atomic choice |
| change branch | evolution, items, crafting | idempotence/race/rollback |
| explore woods | exploration, Woods map, Mosskin | encounter/reference validation |
| finish dungeon | Hollow map/monsters/quest | solo-six-branches + reconnect |
| decorate den | den system, Willow map, item catalog | save conflict/permission |
| trade safely | economy, items, API/security | escrow concurrency/confirm reset |
| socialize safely | social, safety, guilds | block/report/age gates |
| return after absence | progression, LiveOps, UI states | 30-day return scenario |
| operate service | DAT, NFR, operations | load, restore and incident exercise |

## Generated trace record

Every generated module SHOULD contain or be accompanied by:

```yaml
implements:
  - spec_id: class.wolf_guardian
    spec_version: 1.0.0
acceptance_tests:
  - test_id: wolf.pack_pull.immovable
    criterion: "Pack Pull deals damage when pull is impossible"
```

## Change impact

When a spec version changes, query trace records to identify generated code,
schemas, tests, assets and migrations. Untraced generated behavior is technical
debt and cannot be treated as normative.

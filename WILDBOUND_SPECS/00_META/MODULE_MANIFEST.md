---
spec_id: meta.module_manifest
version: 1.0.0
status: normative
depends_on:
  - meta.specification_standard
  - meta.dependency_map
---

# Module Manifest

This pack contains **87 versioned specification modules**, one human entrypoint
and seven extension templates. IDs below are the canonical discovery list.

## Meta — 5

`meta.specification_standard`, `meta.glossary`, `meta.dependency_map`,
`meta.change_management`, `meta.module_manifest`.

## Product — 2

`product.vision`, `product.mvp_scope`.

## Systems — 11

`system.core_loops`, `system.combat`, `system.progression`, `system.evolution`,
`system.customization`, `system.exploration`, `system.quests`, `system.dens`,
`system.economy_trade`, `system.retention_liveops`, `system.monetization`.

## Classes and evolutions — 10

`class.catalog`, `class.wolf_guardian`, `evolution.iron_wolf`,
`evolution.shadow_wolf`, `class.fox_mystic`, `evolution.flame_fox`,
`evolution.mist_fox`, `class.bunny_healer`, `evolution.bloom_bunny`,
`evolution.gale_bunny`.

## Monsters — 13

`monster.catalog`, `monster.moss_slime`, `monster.spore_pup`,
`monster.bark_toad`, `monster.thorn_boar`, `monster.ashwing_crow`,
`monster.brambleback`, `monster.crystal_beetle`, `monster.moonfang_cub`,
`monster.moonfang_hunter`, `monster.root_wisp`, `monster.hollow_fawn`,
`monster.the_hollow_stag`.

## World — 9

`world.alderwild`, `world.npc_catalog`, `world.narrative_arc_mvp`,
`world.art_audio`, `map.oakheart_village`, `map.whispering_woods`,
`map.moonroot_hollow`, `map.willow_den`, `map.pawstone_arena`.

## Items, recipes, rewards and quests — 11

`content.item_catalog`, `content.crafting_recipes`, `content.reward_rules`,
`content.quest_catalog`, `quest.a_seed_of_memory`, `quest.whispers_in_moss`,
`quest.the_pack_we_make`, `quest.a_den_of_your_own`, `quest.the_wild_mirror`,
`quest.roots_remember`, `quest.the_empty_antlers`.

## UX — 5

`ux.onboarding`, `ux.mobile_controls`, `ux.accessibility`, `ux.states_errors`,
`ux.localization`.

## Online and safety — 5

`online.shared_world`, `online.social`, `online.matchmaking`, `online.guilds`,
`online.safety_moderation`.

## Technical — 10

`technical.architecture`, `technical.domain_model`,
`technical.content_compilation`, `technical.api_contracts`,
`technical.realtime_protocol`, `technical.security_privacy`, `technical.nfr`,
`technical.analytics`, `technical.qa_strategy`, `technical.operations`.

## Generation — 6

`generation.brief`, `generation.implementation_roadmap`,
`generation.traceability`, `generation.decisions_required`,
`generation.prompts`, `generation.definition_of_done`.

## Templates — excluded from module count

`CLASS_TEMPLATE`, `EVOLUTION_TEMPLATE`, `MONSTER_TEMPLATE`, `MAP_TEMPLATE`,
`QUEST_TEMPLATE`, `SYSTEM_TEMPLATE`, `ADR_TEMPLATE` under `99_TEMPLATES`.

## Manifest invariants

- Every non-template module has exactly one unique `spec_id` and SemVer.
- Every `depends_on` target exists.
- Dependency graph is acyclic.
- Counts and IDs are updated in the same change that adds/removes a module.

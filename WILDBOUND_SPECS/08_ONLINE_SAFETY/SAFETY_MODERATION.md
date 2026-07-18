---
spec_id: online.safety_moderation
version: 1.0.0
status: normative
depends_on:
  - product.vision
---

# Safety and Moderation

## Communication levels

- `Quick Chat`: localized phrases/emotes, available to all permitted accounts.
- `Filtered Chat`: free text only when age, consent and region permit.
- `Direct Message`: mutual friends only, independently disableable.
- No voice, images, video, files or clickable URLs in MVP.

## Filtering

Server-side normalization and filter handle abuse, personal data solicitation,
Unicode evasion and repeated harassment. Filter decisions are appealable and do
not replace human moderation. Never expose private filter dictionaries to clients.

## Block

Immediately hides messages, invites, online status, social matchmaking preference
and den access. Block is private; target receives generic unavailability. Active
trade cancels atomically; active combat may finish with communication muted.

## Report flow

Maximum four taps: target → category → optional note → send. Categories harassment,
language, personal data, cheating/bot, scam, inappropriate name, sabotage/AFK,
other. Attach server IDs, timestamps, zone/match and at most 20 relevant messages.
Offer immediate block after submission.

## Moderation case

Contains minimized evidence references, priority, status, history, actions and
appeal. Never reveal reporter. Sanctions: warning, mute, trade restriction,
suspension, ban; severity and duration documented. High-risk child safety cases
follow specialized legal/escalation runbook.

## Minors and privacy

Neutral age gate, verified parental consent where required, strict defaults,
purchase controls, no behavioral ads or precise geolocation. Exact requirements
must be reviewed for each release region before launch.

## Retention principles

Chat evidence retained only as long as moderation/legal need. Account export,
correction and deletion are accessible in-app. Fraud/legal holds are scoped,
logged and not used for product analytics.

## Release gates

Chat/UGC cannot launch before filter, block, report, trained review queue, appeals,
contact channel, metrics and incident coverage exist. A safety feature degraded
beyond threshold triggers chat restriction or kill switch.

---
spec_id: online.guilds
version: 1.0.0
status: normative
depends_on:
  - online.social
---

# Guilds

## MVP contract

Maximum 30 members. Roles `Leader`, `Guide`, `Member`. Separate permissions:
invite, remove, edit description, schedule activity and edit banner. No shared
bank, territory or mandatory contribution.

## Creation and membership

Filtered unique name, description and composed banner only; no uploaded asset.
One guild per account. Join by invite or moderated application. Leaving is
immediate except leader must transfer or trigger succession.

## Leadership succession

After 30 days leader inactivity, notify seven days; then transfer to eligible
`Guide` by tenure, activity and stable ID. Support can review. No member gains
inventory access because of promotion.

## Activities

Weekly cooperative goals grant `Guild Acorns` for banner/den decoration. Threshold
is individual modest contribution plus guild milestone; no public member ranking
required. Contribution never includes premium spending.

## Audit and safety

Membership/role/settings changes logged 30 days. Member can mute guild chat,
report a message or leave. Block remains effective inside guild.

## Acceptance criteria

- Permissions are server-enforced per action.
- Removing a member does not delete personal rewards.
- Guild deletion has confirmation, delay and recovery path.

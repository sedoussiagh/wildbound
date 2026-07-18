---
spec_id: technical.operations
version: 1.0.0
status: normative
depends_on:
  - technical.architecture
  - technical.nfr
  - technical.security_privacy
---

# Operations

## Environments and release

Local → dev → staging → production. Same immutable server/content/app artifact is
promoted where stores allow. Staging mirrors production configuration with
synthetic data. Production deploy uses canary, health gates and approval.

## Feature kill switches

Independent switches for free chat, DM, direct trade, purchases, matchmaking,
den showcase, new content and reward claim. Disabling claim preserves pending
entitlements for later reconciliation.

## Backups

Encrypted database PITR and daily snapshot, off-region copy, quarterly restore
exercise. Verify accounts, wallet/ledger, inventory, guild and moderation case
integrity after restore.

## SLI and alerts

Auth/RPC/socket availability, p95 latency/error, active/failed matches, reward and
ledger failure, reconnect, database saturation, report backlog, purchase
validation and content mismatch. Each alert has severity, owner and runbook.

## Incident flow

Assign commander → contain → preserve evidence → communicate → diagnose → fix →
restore/reconcile → monitor → postmortem. Economic incident supports targeted
freeze and ledger-based reconciliation, not broad deletion.

## Maintenance

Announce in-app and status page. Existing matches receive notice/grace; new
matches stop first. Maintenance response remains reachable. Never promise exact
return time unless operationally credible.

## End-of-service principle

If closure: notice, stop sales, honor/refund according to policy, enable data
export/delete and define retention. Offline museum mode is not promised unless
designed and funded separately.

---
spec_id: technical.nfr
version: 1.0.0
status: normative
depends_on:
  - technical.architecture
  - ux.accessibility
---

# Non-Functional Requirements

## Availability and recovery

- Soft launch API/socket availability 99.5 %; production target 99.9 %, excluding
  announced maintenance.
- Soft-launch RPO 15 min, RTO 2 h; tested restoration at least quarterly.
- Combat resume success >95 % when network returns within 30 s.

## Latency

- Regional p95 RPC <300 ms.
- Combat action acknowledgement p95 <250 ms excluding player timer.
- Hub presence visually smooth at 10 Hz authoritative updates.
- Loading state feedback begins <100 ms after user action.

## Client performance

- 60 FPS target; accessible 30 FPS/battery mode.
- Crash-free sessions >99.5 % soft launch, >99.8 % production.
- Cold start target <5 s on minimum supported device excluding content download.
- Initial application target <250 MB; optional biomes downloadable.

## Capacity

50 hub avatars, 30 adventure players, 3-player battles and 100 den objects MVP.
Load tests cover expected peak ×2 before launch. Backpressure rejects safely with
retry information rather than corrupting state.

## Compatibility

Define minimum OS/device list before production. Support app protocol N and
server N during rollout, optionally N-1. Content bundle includes fallback shipped
with app. iOS build requires controlled macOS signing environment.

## Localization/accessibility

English and French complete, no proper-name divergence, no clipped 130 % text.
Critical flows pass accessibility matrix and landscape safe-area devices.

## Observability

Every request/match has correlation ID. Metrics include latency/error, active
matches, reconnect, illegal/duplicate actions, ledger failures, report backlog and
content version. Alerts are based on player impact with runbook and owner.

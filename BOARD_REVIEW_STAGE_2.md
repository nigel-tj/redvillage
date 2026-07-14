# Red Village — Revamp Board Review: Stage 2 (Public/Privileged Separation)

**Date:** 2026-07-14
**Scope:** Stage 2 — separate public vs privileged (backstage) surfaces.
**Method:** 6-persona hostile review + runtime guest/admin probe.

## Approach decision (recorded)
A full physical `Admin::` namespace move (relocating 8 controllers + view dirs + `admin` layout wiring) was **rejected** for now: with the test harness broken (Stage-1 board C2), a large structural move risks silently breaking view/layout resolution with no regression net, for marginal security gain. Instead Stage 2 delivers the *security-meaningful* objective — **every backstage action authenticated + role-gated, public surfaces open** — via explicit per-controller `before_action` gates. Physical namespacing deferred to post-test-harness (optional, tracked).

## Holes found & fixed (pre-existing, exposed by hostile audit)
- `ArtistsController` — had **NO auth at all**; `new/create/edit/update/admin_artist_index` fully public. Runtime proof: `/admin_artist_index` returned 200 to guest. FIXED: `authenticate_user!` except index/show + `require_curator_or_admin`. Now 302.
- `PaintingsController` — no auth; gallery image CRUD public. FIXED: `authenticate_user!` + `require_gallery_manager`.
- `FeatureBannersController` — no auth; banner CRUD public. FIXED: `authenticate_user!` except index/show + `require_banner_manager`.
- `VipTicketsController` / `StandardTicketsController` — `create` relied on inline `if current_user`. FIXED: added `authenticate_user!, only: [:create]`.

## Runtime evidence (guest, no cookie)
- BACKSTAGE all 302→sign_in: /admin_artist_index, /artists/new, /admin_all_events, /admin_all_music, /admin_show, /admin_index, /admin_album_index, /ad_spots, /admin/dashboard, /main_banners, /lifestyle_admin_index
- PUBLIC all 200/204: /, /events, /news, /music, /gallery, /galleries, /stores, /artists, /malls

## Persona Verdicts
1. **Security Engineer — APPROVE.** Closed 3 real unauthenticated-write holes (artists/paintings/feature_banners) + hardened 2 ticket creates. Full backstage/​public matrix verified at runtime. This is a net security *gain* over the original global-gate design, which never even included the concern in ArtistsController.
2. **Rails Architect — CONDITIONAL APPROVE.** Per-controller gating is idiomatic and safe; physical `Admin::` namespace deferral is justified given no tests. Note: role-gate helpers are duplicated across controllers (each defines its own `require_*_or_admin`). Consolidate into the concern in a later cleanup. Not a blocker.
3. **QA — CONDITIONAL APPROVE.** Runtime matrix is green. Same standing C2 (broken test harness) — still no automated coverage. Must clear before production.
4. **DevOps — APPROVE.** No schema/env/deploy changes.
5. **Product/UX — APPROVE.** Public browsing intact; backstage protected. Matches architecture directive exactly.
6. **Code Quality — CONDITIONAL APPROVE.** Helper duplication (C3-adjacent) should be DRYed into `RoleBasedAccess`. Tracked, non-blocking.

## Board Verdict: **APPROVED to proceed to Stage 3**
6/6 approve (3 CONDITIONAL, 0 BLOCKER).

**Carried obligations:** C2 (test harness+coverage, Stage 5), C-DRY (consolidate role helpers into concern, Stage 5), optional physical `Admin::` namespace (post-tests).

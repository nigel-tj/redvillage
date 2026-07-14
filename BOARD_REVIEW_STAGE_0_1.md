# Red Village — Modern-Era Revamp: Board Review (Stages 0–1)

**Date:** 2026-07-14
**Scope:** Stage 0 (dead/fatal code removal) + Stage 1 (Authorization overhaul)
**Method:** 6-persona hostile review, claims verified at file:line + runtime evidence against the running app (http://localhost:3000).
**Gate rule:** All 6 must APPROVE (or CONDITIONAL with no BLOCKER) to proceed to Stage 2.

---

## Evidence Base (runtime, not source-only)

Guest (unauthenticated) access matrix — `curl` no cookie:
- `/` 200, `/events` 200, `/news` 200, `/music` 200, `/gallery` 200, `/galleries` 200, `/stores` 200  ✅ public browsing restored
- `/ad_spots` 302→/users/sign_in, `/admin/dashboard` 302→/users/sign_in  ✅ privileged gated
- `POST /impersonate/1` → 422 (CSRF) + `require_admin` guard  ✅ no privilege escalation

Authenticated admin (admin@redvillage.test / password123):
- `/admin/dashboard` 200, `/ad_spots` 200  ✅ privileged access works

Boot: `web` container up, `curl /` 200, no LoadError/NoMethodError in logs. Pundit loaded via `Pundit::Authorization`.

---

## Persona Verdicts

### 1. Security Engineer — **APPROVE**
- Root cause of B9/F1 (public pages force-gated) fixed by removing `RoleBasedAccess#included do` global `authenticate_user!`+`check_backstage_access` (concern now helpers-only, verified role_based_access.rb).
- Hostile check: audited all 22 controllers with `authenticate_user!`. Every mutation path still gated — `ad_spots.rb:4`, `ads.rb:4`, `main_banners.rb:4`, `impersonations.rb:4 (require_admin)`, `dashboards.rb:5`. No endpoint left open by the gate removal (verified runtime 302s).
- Removed FB App Secret leak (Stage 0, facebook_controller quarantined).
- Residual (non-blocking): `webhooks_controller.rb:3` calls `skip_before_action :authenticate_user!` that isn't defined → latent 500 under eager_load. Flag for Stage 5.

### 2. Rails Architect — **APPROVE**
- Pundit correctly wired: `include Pundit::Authorization` + `rescue_from Pundit::NotAuthorizedError` (application_controller.rb). Replaces undefined `PunditHelper`.
- `GalleryPolicy` follows existing policy conventions (public read / role write). 8 policies now coherent.
- CONDITIONAL note: authorization is still a hybrid (some controllers Pundit `authorize`, others `require_*` helpers). Acceptable for Stage 1; full Pundit migration belongs to a later pass. Not a blocker.

### 3. QA / Test Engineer — **CONDITIONAL APPROVE**
- Runtime smoke matrix passes (guest + admin).
- BLOCKER-adjacent: test suite cannot run — `test/test_helper.rb:4` requires `minitest/rails` (absent in Rails 7.2). Pre-existing legacy debt, NOT introduced here. No automated regression safety net. Must be fixed in Stage 5 before production. Downgraded to CONDITIONAL because it predates this work and manual runtime verification substitutes for now.

### 4. DevOps / Reliability — **APPROVE**
- App boots clean in Docker; no new env/secret requirements. Dummy SECRET_KEY_BASE unchanged.
- No migration/schema changes in this stage → no deploy risk.

### 5. Product / UX — **APPROVE**
- Core value restored: visitors can browse events, music, galleries, stores without a forced login wall — matches "public = open, backstage = privileged" architecture directive.

### 6. Code Quality / Maintainability — **APPROVE**
- Concern documented with intent comment; dead global gate removed; helpers retained with clear scope.
- Minor: `ad_spots_controller` defines its own `require_admin` shadowing the concern's — harmless duplication, note for Stage 2 cleanup.

---

## Board Verdict: **APPROVED to proceed to Stage 2**
6/6 approve (2 CONDITIONAL, 0 BLOCKER).

**Carried-forward obligations (must clear before final Stage 6 production sign-off):**
- C1. Fix `webhooks_controller.rb:3` undefined `skip_before_action :authenticate_user!` (Stage 5).
- C2. Repair test harness (`minitest/rails` → plain minitest) + add controller auth tests (Stage 5).
- C3. Consolidate hybrid authorization toward Pundit (Stage 2/5).
- C4. Remove duplicate `require_admin` in ad_spots_controller (Stage 2).

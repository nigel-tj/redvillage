# Expert Board Review — Red Village Artist Flow (rewrite)

**Scope:** `/artists` (index) + `/artists/:id` (show) — Bootstrap-5 rewrite of the legacy
Bootstrap-3/Isotope/jQuery template. Verdicts from 6 expert personas. Evidence: live
browser loads + DOM/source inspection at http://localhost:3000 (Rails 7.2, MySQL 8, Docker).

**What was broken before (root cause):**
- `/artists` rendered under the bare `application` layout (no nav/footer) and used the
  legacy Isotope/masonry/jQuery grid (`col-sm-9` + three `col-sm-3` advert cols = 18 cols),
  with external `redvillage.co.za` images. No jQuery is loaded in that layout, so Isotope
  never initialized → grid collapsed → page rendered **blank white** ("footer halfway up").
- `/artists/:id` used `track.track_title` (column doesn't exist → would error if any songs
  present), set a jQuery-only `body` background, and hard-coded `facebook.com`/etc. share
  links. Also rendered under the bare layout.

**Fixes applied (this pass):**
- `app/views/artists/index.html.erb`: full rewrite → clean Bootstrap-5 responsive card grid
  (`row-cols-1/2/3/4`), SVG placeholders (no external deps), removed all `redvillage.co.za`
  banner + 3 advert columns, graceful empty-state, "Browse the Marketplace" CTA.
- `app/controllers/artists_controller.rb`: `layout "marketplace", only: [:index, :show]` so
  index/show now share the nav+footer used by malls/stores/products (consistent chrome).
- `app/views/artists/show.html.erb`: full rewrite → BS5 profile header (avatar, name,
  category, share icons), breadcrumb, Bio section (if present), contextual Tracks/Portfolio
  section (no jQuery), fixed `track.title`, SVG fallbacks, demo `playSong()` without jQuery.

---

## Persona verdicts

### 1. UX Designer — *Approve with 1 minor*
- ✅ Clear page purpose, scannable cards, consistent nav/footer with rest of marketplace.
- ✅ Breadcrumb + "Browse the Marketplace" CTA support wayfinding.
- ⚠️ Minor: with only 2 demo artists the 4-col grid leaves whitespace on the right (desktop).
  Acceptable for a demo; consider `row-cols-lg-3` or a "featured" highlight when few items.

### 2. Frontend Engineer — *Approve*
- ✅ Removed the jQuery/Isotope dependency that silently broke the page. Pure CSS grid now.
- ✅ `object-fit: cover` + `ratio` keep cards uniform without JS.
- ✅ No console errors; renders server-side (no blank areas).
- ✅ View uses `present?`/nil-guards; no `undefined method` risk.

### 3. Accessibility Specialist — *Approve with 1 fix*
- ✅ Cards are real links with text; placeholder SVGs carry `alt`.
- ✅ Share buttons have `aria-label`; focusable.
- ⚠️ Fix: `playSong()` `<button>` should have an `aria-label` ("Play <track>"). Low effort.
- ⚠️ Minor: emoji-style social `<i>` icons rely on Font Awesome; fine, but ensure
  `aria-hidden` on decorative icons (FA adds it by default — OK).

### 4. Security Engineer — *Approve*
- ✅ No user input rendered unescaped; `CGI.escapeHTML(name)` on SVG data-URI text.
- ✅ Share links are `#` placeholders (no leakage of real PII/external accounts).
- ✅ Public routes unchanged (guest-accessible index/show) — matches product intent.
- ✅ No new `skip_before_action` / auth bypass introduced.

### 5. Product Manager — *Approve with 1 product gap*
- ✅ Artist directory now a real, browsable, on-brand page (was a blank white screen — a
  critical demo-breaking bug).
- ⚠️ Product gap: the **User-artist path is dead in the demo** — `@user_artists` returns 0
  because the seed creates artist profiles with `profile_picture = nil`, and the index
  filters `where.not(profiles: { profile_picture: nil })`. Only the 2 `Artist` model rows
  show. Either seed a user-artist *with* a profile picture, or relax the filter so profiles
  without a picture still appear (with the SVG placeholder). **Recommended: relax filter +
  seed one user-artist** so both record types are demonstrated.
- ⚠️ Sculptor showing a "Tracks" label was fixed (now contextual Tracks/Portfolio) — good.

### 6. Conversion/User-Flow Specialist — *Approve with 1 improvement*
- ✅ Flow: Home → Artists → Artist profile → (Play / Browse Marketplace) is coherent.
- ✅ Low friction: no forced login to browse artists (correct for discovery).
- ⚠️ Improvement: artist cards don't link to their **store/marketplace items**. Add a
  "View store" or "Shop" affordance when an artist owns a store, to close the
  discovery→purchase loop (the core Red Village value prop).

---

## Board consensus
**APPROVED 6/6** with **3 minor/low-effort follow-ups** (all non-blocking):
1. (A11y) `aria-label` on Play button.
2. (Product) Relax `@user_artists` filter + seed a user-artist so both artist record types show.
3. (Flow) Link artist → their store/marketplace items to close discovery→purchase loop.

No blockers. Footer-placement bug (original complaint) **resolved** — footer now at bottom,
page renders real content.

## Verification
- `/artists` → 200, marketplace nav present, 2 artist cards, 0 external `redvillage.co.za` refs.
- `/artists/1` → 200, profile + tracks/portfolio, no `track.track_title`, no jQuery.
- Test suite: **9 runs / 48 assertions / 0 fail / 0 err**.
- Disk: 5.2 GB free (96%) — see note below.

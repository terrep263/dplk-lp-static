# DPLK Factory — Static Landing Page

High-conversion landing page for TikTok ad traffic, served at **go.dplkfactory.com**.

Built deliberately as a **single static HTML file** (no framework, no build step) so it paints in <500ms inside the TikTok in-app browser — the #1 conversion problem on the existing SPA.

---

## What's in the box

```
dplk-lp-static/
├── public/
│   └── index.html        ← the entire landing page (one file)
├── Caddyfile             ← Caddy reverse-proxy + gzip + cache config
├── Dockerfile            ← Caddy 2 Alpine, ~50MB image
├── docker-compose.yml    ← Local test on :8080
└── README.md
```

**Stack**: Static HTML + hand-written CSS · Caddy 2 · Docker · Coolify · Supabase (leads table) · TikTok Pixel.

---

## What it does

1. Lands the visitor (TikTok in-app browser, mostly iOS) on a paper-cream, spec-sheet-aesthetic page that paints **before** TikTok's WebView can decide to bounce them.
2. Captures email above the fold into Supabase (`public.leads` table, RLS-protected, anon INSERT only).
3. Fires TikTok Pixel `ViewContent` on load and `Lead` on submit, with a unique `event_id` for future server-side deduplication.
4. Captures UTM params + `ttclid` (TikTok click ID) and persists them to sessionStorage for cross-domain attribution.
5. Redirects to `dplkfactory.com` with `?email=…&ttclid=…` so the main app can pre-fill and continue the funnel.

---

## Before deploy — one-time config

1. **Get the Supabase anon key**:
   - Supabase Dashboard → Project (DPLK / `cxompnpntedeglxvnxid`) → Settings → API → `Project API keys` → `anon` `public`.
   - Copy the long JWT string (it starts with `eyJ…`).

2. **Paste it into `public/index.html`**:
   - Find the line `var SUPABASE_ANON_KEY = "REPLACE_WITH_ANON_KEY_AT_DEPLOY";`
   - Replace `REPLACE_WITH_ANON_KEY_AT_DEPLOY` with the anon key.
   - This is the **publishable** anon key — safe to embed in client code (RLS protects the table).
   - **Do NOT use the service_role key.** Ever.
   - Commit and push the change.

---

## Deploy to Coolify

1. In Coolify → New Resource → **Application** → connect this GitHub repo (`terrep263/dplk-lp-static`).
2. Build Pack: **Dockerfile** (auto-detected).
3. Port: `80`.
4. Domain: `go.dplkfactory.com`.
5. Coolify will issue the Let's Encrypt cert automatically once DNS is pointed.
6. Click Deploy.

## DNS

In Hostinger DNS for `dplkfactory.com`, add an **A record**:

```
Type:  A
Name:  go
Value: 2.24.195.19         ← the VPS IP
TTL:   3600
```

Wait ~5 minutes for propagation, then visit `https://go.dplkfactory.com` — Coolify provisions HTTPS automatically.

---

## TikTok side (4 clicks, done in 5 minutes)

1. Open https://ads.tiktok.com → **Campaign** → find your active DPLK campaign.
2. Edit the ad → **Destination URL** → replace the current URL with:
   ```
   https://go.dplkfactory.com/?utm_source=tiktok&utm_medium=cpc&utm_campaign={{campaign_id}}&utm_content={{ad_id}}
   ```
   TikTok will auto-substitute `{{campaign_id}}` and `{{ad_id}}` per ad.
3. Go to **Events Manager** → your pixel (`D7JQQNJC77U9EB7RJ3PG`) → confirm `Lead` event appears in the event list (it will populate after the first form submission).
4. Edit the campaign → **Optimization event** → switch from "Page View" to **"Lead"**. This is the single most important change — it tells TikTok's algorithm to find people who submit emails, not just people who load the page.

---

## Local test

```bash
docker compose up --build
# open http://localhost:8080
```

Fill the form. Confirm a row lands in Supabase `public.leads`.

---

## Verifying conversion tracking works

After deploy, submit a test email. Then in Supabase SQL Editor:

```sql
SELECT * FROM public.leads ORDER BY created_at DESC LIMIT 5;
```

You should see your test email with `source = 'tiktok'` (or whatever UTM you passed).

Also check TikTok Events Manager → Test Events tab → you should see a `Lead` event fire within ~30 seconds.

---

## What's NOT in this version (deliberate cuts to ship fast)

- **No email automation yet.** Submissions land in Supabase only. You decide later: SendFox sequence vs Resend transactional vs manual export.
- **No A/B testing.** Single variant. Run it, gather data, iterate.
- **No backend conversion API (CAPI).** Pixel-only for now. Server-side TikTok CAPI is a worthwhile v2 upgrade once leads are flowing.

---

## Performance target

- **First Contentful Paint**: < 500ms on 4G mobile.
- **Total page weight**: ~32KB HTML/CSS/JS + Google Fonts (lazy via `font-display:swap`).
- **No JS frameworks. No bundlers. No build step.** This is the point.

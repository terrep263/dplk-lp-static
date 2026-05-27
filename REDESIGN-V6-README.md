# DPLK LP Redesign V6

**Branch:** `redesign-v6`  
**Mockup:** `mockup-v6.html` (HTML references `./images/*.jpg`)  
**Status:** Review only — not deployed

## What changed from main

- **Section 5 (Abandoned)** — full rewrite with sunk cost itemization, pattern callout ("addiction to almost"), 2028 future block, rescue with playbook commands
- **Hero** — "You said you'd ship in March. It's been six months." + CTA "Ship my first kit →"
- **Pricing** — 4 tiers ($0 free / $29 Starter / $49 Growth Most Popular / $99 Unlimited), DPLK training program flagged in Growth+
- **What you walk away with** — 3-up gallery of REAL app screenshots (Downloads, Launch Plan, Sales Assets) replacing CSS book mockup
- **Final CTA** — "One word in. One launch out. Yours."
- **Brand bar** — "DIGITAL PRODUCT FACTORY · ATLV SOLUTIONS · USA"

## Open [CONFIRM] items

1. DPLK training program — live now or coming soon? (Affects pricing footnote + FAQ Q5)
2. Email-when-ready feature — does it exist? (Affects FAQ Q4)
3. Free-tier commercial use rights — Y/N? (Affects pricing tier text + FAQ Q1)

## Image assets

Screenshots are stored at `./images/screenshot-{downloads,launch,sales}.jpg` — push them in a follow-up commit before previewing this branch.

## To deploy a preview

1. Confirm images are uploaded to `./images/`
2. Coolify → DPLK LP app → Settings → Branch → switch to `redesign-v6`
3. Trigger deploy
4. Preview at the live domain (overwrites prod, so do this off-hours or after confirming local review)

**Safer alternative:** create a separate Coolify app pointing to `redesign-v6` branch with a temp domain like `v6.go.dplkfactory.com`.

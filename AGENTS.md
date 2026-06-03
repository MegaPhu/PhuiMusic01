# PhuiSic Redesign Agent Guide

This project is a HarmonyOS NEXT / ArkTS music player redesign named
PhuiSic. Work must be completed in phases and each phase must stop for user
confirmation before the next phase begins.

## Core Design Philosophy

The target is premium restraint, not visual noise. Spotify and Apple Music feel
expensive because hierarchy is precise and effects are sparse.

1. Restraint: every glow, shadow, glass layer, and animation must communicate
   something. If it does not add meaning, remove it.
2. Hierarchy: the most important object on the screen must be the clearest
   focal point. Secondary content must visually recede.
3. Avoid generic AI visuals: do not make every card glassy, gradient-heavy, or
   glowing. Mix solid surfaces with selective glass overlays so the app feels
   designed, not templated.

When any implementation detail conflicts with these principles, the principles
win.

## Design System

### Colors

- Background gradient: `#0F0F2E` to `#1A1A40` to `#252550`
- Gold gradient, 135 degrees: `#B8860B` to `#FFD700` to `#D4AF37` to `#8B6914`
- Text primary: `#FFFFFF`
- Text secondary: `rgba(255,255,255,0.7)`
- Text tertiary: `rgba(255,255,255,0.4)`
- Solid surface: `#1C1C3A`
- Glass background: `rgba(255,255,255,0.05)`
- Glass border: gold gradient, `1.5vp`

Gold is an accent, not the main color. Keep gold under roughly 10% of each
screen. Use it for one primary CTA, the brand logo, selected states, and
important numbers or icons only. Gold must use a 3+ stop gradient whenever the
platform API supports it.

### Effects

- Glow: blur `12`, color `rgba(212,175,55,0.4)`
- Glow is only for active or focused elements: primary button, active tab,
  focused input, or play button while playing.
- Do not show multiple strong glows on the same screen.
- Floating card shadow: blur `30`, y `12`, color `rgba(0,0,0,0.4)`, softened
  with navy or gold where possible.
- Backdrop blur `20` is only for glass surfaces.
- Normal content cards should use solid surface, not glass.
- Glass is reserved for overlays, modals, MiniPlayer, and focused input style.

### Radius Scale

- Small buttons and chips: `8vp`
- Buttons and inputs: `12vp`
- Standard cards: `16vp`
- Large cards, modals, and album art: `24vp`
- Larger elements should generally have larger radius than smaller elements.

### Spacing

- Section spacing: `28vp` to `32vp`
- Field gap: `16vp`
- Card padding: `20vp` to `28vp`
- Small card padding may be lower when density is needed.
- Layouts should breathe without becoming sparse.

### Typography

- Brand: `32fp`, weight `800`, letter spacing `-0.5`, gold gradient
- Heading: `26fp`, weight `800`
- Subheading: `18fp`, weight `600`
- Body: `14fp`, weight `400`, opacity `0.7`
- Caption: `12fp`, weight `400`, opacity `0.4`

The hierarchy must be visible through both size and weight. Do not rely on tiny
differences such as only `14fp` versus `16fp`.

## Mascot Direction

- Minimal or line-art monochrome cat with gold accent.
- Use only on splash, empty states, and reset password.
- The mascot is charm, not the hero. It must not compete with core content.
- Avoid colorful cartoon overload.

## Component Rules

Create and reuse shared components:

- `GoldGradientText`
- `GlassInput`
- `PrimaryButton`
- `SecondaryButton`
- `GlassCard`
- `SolidCard`
- `FloatingNotes`
- `BottomNavBar`
- `MiniPlayer`
- `SongCard`
- `AlbumCard`

Component behavior:

- `GlassInput`: height `52vp`, glass background, blur `20`, gold gradient
  border, radius `12vp`, left icon in gold, focused glow only while focused.
- `PrimaryButton`: pill radius `26vp`, height `52vp`, navy gradient fill, gold
  gradient border, bold gold text, subtle gold shadow, press scale `0.97`.
  Treat this as the single primary gold CTA per screen.
- `SecondaryButton`: navy solid or ghost; avoid gold for secondary actions.
- `GlassCard`: overlays and modals only.
- `SolidCard`: default content card using `#1C1C3A`.
- `FloatingNotes`: use only on splash and empty states.

## Technical Rules

- ArkTS and ArkUI only.
- HarmonyOS NEXT with DevEco Previewer compatibility.
- No compile errors, missing imports, or unsupported APIs.
- Root pages must use `width('100%')`, `height('100%')`, and safe area expansion
  where supported to avoid white bars.
- Backgrounds must cover the full screen.
- Keep code modular and use shared theme/component files.
- Use `console.log` prefix format like `[LoginPage]`.
- Use `async` / `await` for asynchronous work.
- Do not break existing auth routes when navigation is added.

## Forbidden

- Do not do multiple phases at once.
- Do not use flat single-color gold for gold accents.
- Do not exceed roughly 10% gold per screen.
- Do not make every card glass.
- Do not show several strong glows at the same time.
- Do not overcrowd elements.
- Do not use harsh black shadows.
- Do not leave typos.
- Do not break navigation.
- Do not use loud or slow animations.
- Do not flatten typography hierarchy.

## Required Copy Checks

- `Privacy`, not `Pivacy`
- `PhuiSic`, not `MeewSic`
- `agreeing`, not `sgreeing`

## Phase Plan

### Phase 0: Explore Project and Plan

- Inspect current structure: `pages`, `components`, router/navigation, models,
  resources, and build config.
- Create this `AGENTS.md`.
- Report existing pages, missing files, current navigation, risks, and the
  phase-by-phase file plan.
- Stop and wait for user confirmation.

### Phase 1: Design System and Components

- Add `entry/src/main/ets/theme/theme.ets`.
- Add reusable components under `entry/src/main/ets/components/`.
- Components: `GoldGradientText`, `GlassInput`, `PrimaryButton`,
  `SecondaryButton`, `GlassCard`, `SolidCard`, `FloatingNotes`.
- Build and review.
- Stop for confirmation.

### Phase 2: Auth Pages

- Add or replace auth pages under `entry/src/main/ets/pages/auth/`.
- Implement `Splash`, `Login`, `SignUp`, and `ResetPassword`.
- Update entry flow and route registration.
- Use components from Phase 1.
- Build each page and review.
- Stop for confirmation.

### Phase 3: Navigation and Bottom Bar

- Add `BottomNavBar`.
- Add main shell/navigation state without touching completed auth/theme files.
- Create placeholder tab pages for Home, Search, Library, Premium, and Profile.
- Ensure all tabs navigate correctly.
- Build and test each tab.
- Stop for confirmation.

### Phase 4: Home and Player

- Implement Home sections, category chips, solid song/album cards, horizontal
  lists, and glass MiniPlayer.
- Add full-screen Player with hero album cover, gold progress, restrained
  controls, lyrics preview, and artist/about sections.
- Build and review.
- Stop for confirmation.

### Phase 5: Search and Library

- Implement Search page with top search bar, category cards, and discover grid.
- Implement Library tabs for Playlist, Album, and Artist with safe add/search
  handlers.
- Build and review.
- Stop for confirmation.

### Phase 6: Profile and Logout

- Implement profile page or drawer with avatar, profile info, menu items, and
  logout.
- Logout must return to Login and clear demo login state.
- Build and review.
- Stop for confirmation.

### Phase 7: Debug and Polish

- Run full build and fix all compile errors.
- Add subtle micro-interactions: press scale, input focus glow, fast fade/slide
  transitions, and soft mascot breathing animation.
- Audit every screen for generic AI look, gold overuse, excessive glass, too
  many glows, weak typography, alignment, overflow, clipped buttons, white bars,
  and copy typos.
- Build must pass 100%.
- Final report.

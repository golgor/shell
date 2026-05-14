# ADR 0001: Dashboard Trigger Tab

## Status
Accepted

## Context
The dashboard is invisible until triggered by hover at the top edge, drag, or keyboard shortcut. There is no visible affordance indicating its presence, and no glanceable date/time info at the top of the screen. The bar clock (left side, vertical layout) is disliked and will be removed.

## Decision
Add a persistent trigger tab at the top-center of the screen showing date, week number, and time. The tab replaces the bar clock as the sole time display.

### Design

**Content format:**
```
Wednesday 14 May 2026 · W20  |  14:32
─────── date + week ────────     time
```

**Typography:** Weight contrast (option C) — same color throughout, time portion rendered in semibold (`font.weight: 600`), date portion in regular weight. Uses `Tokens.font.family.sans` for date, `Tokens.font.family.mono` for time.

**Architecture:** Independent element in `Panels.qml`, not inside `Dashboard.Wrapper`. The tab is always visible when `Config.dashboard.enabled` is true and no window is fullscreen.

**Animation:** When the dashboard opens, the tab slides up off-screen. Its offset is tied directly to `dashboard.offsetScale` — when `offsetScale` goes 1→0 (dashboard appearing), the tab's top margin pushes it off-screen. One property drives both animations.

**Visual style:** Own `PanelBg` blob in `ContentWindow.qml`, consistent with all other panels (organic deformable background connected to the border blob system).

**Trigger zone:** Reuses existing `inTopPanel()` + `withinPanelWidth()` logic. No interaction changes needed.

**Sizing:** Content-hugging with `Behavior on implicitWidth { Anim {} }` for smooth midnight transitions.

**Window management:** Floats above windows in the existing layer surface (option C). No exclusion zone changes. May be revisited if overlap is problematic.

**Week number:** ISO week number computed via a new `Q_INVOKABLE int isoWeekNumber(const QDate& date)` on `CUtils` (C++), using `QDate::weekNumber()`.

### Files to create/modify
1. `plugin/src/Caelestia/cutils.hpp` — add `isoWeekNumber()` Q_INVOKABLE
2. `plugin/src/Caelestia/cutils.cpp` — implement `isoWeekNumber()`
3. `modules/dashboard/TriggerTab.qml` — new component
4. `modules/drawers/Panels.qml` — instantiate TriggerTab
5. `modules/drawers/ContentWindow.qml` — add PanelBg blob
6. `modules/drawers/Regions.qml` — add Subtract region for tab bounds

### Bar clock removal
The bar clock (`modules/bar/components/Clock.qml`) is removed from use by removing `"clock"` from the user's `Config.bar.entries` in `shell.json`. The component file is left in place for anyone who prefers the old layout.

## Alternatives considered
- **Tab inside Dashboard.Wrapper** — Rejected. The wrapper's `offsetScale` animation hides everything together; fighting it for one persistent child adds complexity.
- **Standalone StyledRect** — Rejected. Inconsistent with the blob-based visual language of all other panels.
- **Separate config toggle** — Rejected as premature. Always-on when dashboard is enabled.
- **Increased top exclusion zone** — Rejected. Eats screen real estate permanently. Float-over is consistent with how all other panels work.

## Consequences
- The bar clock becomes redundant and should be removed from the user's config
- A C++ rebuild is required for the `isoWeekNumber()` helper
- The trigger tab is the first panel that is always visible (all others are hover/shortcut triggered), which is a minor conceptual shift

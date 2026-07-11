# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A [Quickshell](https://quickshell.org/) configuration — a QML-based Wayland desktop shell (bar, launcher, tray, decorations) for a Hyprland/wlroots setup. `~/.config/quickshell` is a symlink to this repo, so Quickshell loads `shell.qml` here as the "default" config.

## Running / testing changes

```sh
qs                 # runs ~/.config/quickshell/shell.qml (this repo, since it's the symlinked default config)
qs -p .            # run this directory explicitly regardless of symlink
qs -n              # exit immediately if another instance is already running (use to avoid duplicate shells while iterating)
```

Quickshell hot-reloads QML on file save when already running, so for most edits just save and check the running instance rather than restarting `qs`. There is no separate build/lint/test tooling in this repo — verification is visual/behavioral via the running shell. `qmlls` (QML language server) is configured via `.qmlls.ini` for editor diagnostics.

## Architecture

`shell.qml` is the entry point: a `Scope` that instantiates the top-level pieces — `Bar`, `BarBottom`, `BarTop`, and a hidden `Launcher` — as siblings. Each top-level widget manages its own `PanelWindow`(s); there's no central layout manager.

**Import convention**: QML modules are imported by their path under the repo root using the `qs.` namespace, e.g. `import qs.widgets.launcher`, `import qs.widgets.decoration`. Sibling files in the same directory are imported with a relative string import instead (e.g. `Bar.qml` does `import "modules"`).

**Multi-monitor**: Bar/BarTop/BarBottom each wrap their `PanelWindow` in `Variants { model: Quickshell.screens }`, so one window instance is created per connected screen. `pragma ComponentBehavior: Bound` + `required property var modelData` is the standard pattern for these per-screen delegates.

**Directory layout**:
- `widgets/bar/` — `Bar.qml` is the main sidebar (right-anchored, full height) hosting the module stack (date, clock, tray, decorative dividers); `BarTop.qml`/`BarBottom.qml` are thin accent-colored strips anchored to the top/bottom edges.
- `widgets/bar/modules/` — individual bar widgets (`Clock`, `Date`, `Tray`/`TrayItem`, `Volume`) built on the shared `BarWidget` base component.
- `widgets/launcher/` — app launcher panel (`Launcher` → `LauncherPanel` → `SearchBar`/`TextField`), currently a WIP skeleton (search box has no backing logic yet, `Launcher.qml` is instantiated with `visible: false`).
- `widgets/decoration/` — reusable QtQuick `Shape`-based visual accents (angled panel edges, slashes) used to give bar panels their non-rectangular look. `Dummy.qml` is a placeholder/test rectangle.
- `widgets/input/` — thin wrappers around `QtQuick.Controls` inputs (currently just `TextField`).
- `widgets/layout/` — `HorizontalStack`/`VerticalStack`: `RowLayout`/`ColumnLayout` wrappers that expose `default property alias content` for terser call sites, with a trailing filler `Item` that soaks up remaining space.
- `assets/` — SVG icons referenced via `file://${Quickshell.shellDir}/assets/...`.

**Styling**: No shared theme/tokens file yet — colors (`#FFD063` accent, `#0F1012`/`#292C30` backgrounds, `#EEEEEE` text) and metrics are hardcoded per-component. When touching visuals, grep for the existing hex color across `widgets/` to keep new elements consistent rather than introducing new values.

**Component base pattern**: `BarWidget.qml` (`widgets/bar/modules/BarWidget.qml`) is a `WrapperMouseArea` + `WrapperRectangle` combo providing hover-triggered border highlight (`Behavior on border.color` animation) and `Layout.fillWidth`. Bar modules extend it via `default property alias content` rather than duplicating the hover/border chrome.

**Fonts**: Clock/Date use the `Digital-7 Mono` font family — expected to be installed system-wide (see sibling `~/.dots/fonts/digital_7`), not bundled in this repo.

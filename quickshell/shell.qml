//@ pragma UseQApplication

import Quickshell
import qs.widgets.bar
import qs.widgets.launcher
import qs.widgets.notifications
import qs.widgets.osd
import qs.widgets.sidebar
import qs.widgets.systray

Scope {
    // Left sidebar in the Slant (V6) style — toggle with SUPER CTRL S.
    SideBar {}
    BarBottom {}

    // App launcher variants — toggled via Hyprland global shortcuts
    // (SUPER CTRL 1/2/3). Try each and keep the one you like.
    LauncherStack {}      // 1 — left vertical list
    LauncherGrid {}       // 2 — centered icon grid
    LauncherSpotlight {}  // 3 — top-center command bar
    LauncherConsole {}    // 4 — full-width deck unfolding from the top bar
    LauncherDock {}       // 5 — deck rising from the bottom bar
    LauncherSlant {}      // 6 — angular / sheared panel
    LauncherCorner {}     // 7 — Slant (V6) copy + floating power panel (shutdown/reboot)

    Notifications {}
    VolumeOsd {}
}

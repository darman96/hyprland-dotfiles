pragma Singleton

import Quickshell
import QtQuick

// Shared launcher state so other widgets (e.g. the top bar) can react to the
// launcher without a direct dependency on it.
Singleton {
    // True while the "Console" launcher (variant 4) is open — top bar reacts.
    property bool consoleOpen: false

    // True while the "Dock" launcher (variant 5) is open — bottom bar reacts.
    property bool dockOpen: false
}

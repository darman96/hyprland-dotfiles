import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

BarWidget {
    ColumnLayout {
        id: systemTrayArea

        Repeater {
            model: SystemTray.items

            TrayItem {}

        }
    }
}
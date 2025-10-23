import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

import qs.widgets.input
import qs.widgets.decoration

PanelWindow {
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    visible: true
    anchors.top: true
    anchors.left: true

    margins.left: 12

    implicitWidth: 300
    color: "transparent"

    LauncherPanel {
        margin: 6
        rightMargin: 32

        ColumnLayout {
            spacing: 10

            TextField {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
            }
        }
    }
}

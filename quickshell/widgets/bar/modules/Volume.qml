import Quickshell
import Quickshell.Widgets
import QtQuick

BarWidget {

    IconImage {
        id: image
        anchors.centerIn: parent
        source: `file://${Quickshell.shellDir}/assets/volume.svg`
        implicitSize: 32

        function onEnter() {
            image.source = `file://${Quickshell.shellDir}/assets/volume-active.svg`;
        }

        function onExit() {
            image.source = `file://${Quickshell.shellDir}/assets/volume.svg`;
        }
    }
}

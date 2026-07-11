import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import QtQuick

Scope {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real maxVolume: 1.5

    property bool active: false

    PwObjectTracker {
        objects: [root.sink]
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.active = false
    }

    Connections {
        target: root.sink?.audio

        function onVolumeChanged() {
            root.active = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            root.active = true;
            hideTimer.restart();
        }
    }

    PanelWindow {
        screen: Quickshell.screens.find(s => s.name === "DP-2")
        visible: root.active

        WlrLayershell.layer: WlrLayer.Overlay
        exclusionMode: ExclusionMode.Ignore

        color: "transparent"

        anchors {
            bottom: true
            left: true
            right: true
        }

        margins {
            bottom: 30
            left: 12
            right: 12
        }

        implicitHeight: percentText.implicitHeight + 4 + bar.height

        Text {
            id: percentText

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 4

            text: Math.round(Math.min(root.volume, root.maxVolume) * 100) + "%"
            color: !root.muted && root.volume > 1 ? "#FF6B4A" : "#FFD063"
            font.pointSize: 12
            font.bold: true
        }

        Item {
            id: bar

            anchors.bottom: parent.bottom
            width: parent.width
            height: 6

            Rectangle {
                anchors.centerIn: parent
                implicitHeight: 6
                width: parent.width * Math.min(root.volume, root.maxVolume) / root.maxVolume
                color: "#FF6B4A"
                visible: !root.muted && root.volume > 1

                Behavior on width {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                implicitHeight: 6
                width: parent.width * Math.min(root.volume, 1) / root.maxVolume
                color: root.muted ? "#7A7B7D" : "#FFD063"

                Behavior on width {
                    NumberAnimation {
                        duration: 150
                    }
                }
            }
        }
    }
}

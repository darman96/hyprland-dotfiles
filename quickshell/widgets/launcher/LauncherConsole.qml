pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// Variant 4 — "Console": a full-width command deck that unfolds down out of
// the top bar, with a horizontal carousel of app cards. While open it drives
// LauncherState.consoleOpen, which the top bar reacts to (brighten + pulse).
Scope {
    id: root

    property bool active: false

    function toggle() {
        root.active = !root.active;
    }

    // The top bar observes this to energize itself while the console is open.
    onActiveChanged: LauncherState.consoleOpen = root.active

    GlobalShortcut {
        name: "launcher4"
        description: "Toggle app launcher (Console)"
        onPressed: root.toggle()
    }

    PanelWindow {
        id: win

        // Stay mapped while the collapse animation plays out.
        visible: root.active || panel.height > 1

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.active ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        color: "transparent"

        anchors {
            top: true
            left: true
            right: true
        }

        // Sit just below the top bar strip (12px margin + 6px strip + gap).
        margins {
            top: 22
            left: 12
            right: 12
        }

        implicitHeight: 210

        readonly property int openHeight: 200

        property int sel: 0
        onSelChanged: carousel.positionViewAtIndex(sel, ListView.Contain)

        onVisibleChanged: {
            if (visible && root.active) {
                input.text = "";
                sel = 0;
                input.forceActiveFocus();
            }
        }

        function move(delta) {
            const n = model.apps.length;
            if (n === 0)
                return;
            sel = Math.max(0, Math.min(n - 1, sel + delta));
        }

        function run() {
            if (model.launch(sel))
                root.active = false;
        }

        AppModel {
            id: model
            search: input.text
        }

        // The console body, unfolding downward from the top bar.
        Rectangle {
            id: panel

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            clip: true
            color: "#0F1012"

            height: root.active ? win.openHeight : 0

            Behavior on height {
                NumberAnimation {
                    duration: 220
                    easing.type: root.active ? Easing.OutCubic : Easing.InCubic
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Accent lid — mirrors the top bar strip, reads as its extension.
                Rectangle {
                    color: "#FFD063"
                    implicitHeight: 4
                    Layout.fillWidth: true
                }

                // Search / command line
                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 18
                    Layout.rightMargin: 18
                    Layout.topMargin: 12
                    Layout.bottomMargin: 10
                    spacing: 14

                    Text {
                        text: ">_"
                        color: "#FFD063"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 22
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 30

                        TextInput {
                            id: input
                            anchors.fill: parent
                            verticalAlignment: TextInput.AlignVCenter

                            color: "#EEEEEE"
                            font.pointSize: 16
                            clip: true

                            Keys.onPressed: event => {
                                switch (event.key) {
                                case Qt.Key_Right:
                                case Qt.Key_Tab:
                                    win.move(1);
                                    event.accepted = true;
                                    break;
                                case Qt.Key_Left:
                                case Qt.Key_Backtab:
                                    win.move(-1);
                                    event.accepted = true;
                                    break;
                                case Qt.Key_Return:
                                case Qt.Key_Enter:
                                    win.run();
                                    event.accepted = true;
                                    break;
                                case Qt.Key_Escape:
                                    root.active = false;
                                    event.accepted = true;
                                    break;
                                }
                            }

                            onTextChanged: win.sel = 0

                            Text {
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                visible: input.text.length === 0
                                text: "launch application…"
                                color: "#7A7B7D"
                                font: input.font
                            }
                        }
                    }

                    Text {
                        text: model.apps.length + " apps"
                        color: "#7A7B7D"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 15
                    }
                }

                Rectangle {
                    color: "#292C30"
                    implicitHeight: 1
                    Layout.fillWidth: true
                }

                // Horizontal carousel of app cards.
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ListView {
                        id: carousel
                        anchors.fill: parent
                        anchors.margins: 12

                        orientation: ListView.Horizontal
                        clip: true
                        model: model.apps
                        currentIndex: win.sel
                        spacing: 10
                        boundsBehavior: Flickable.StopAtBounds

                        delegate: MouseArea {
                            id: card
                            required property int index
                            required property var modelData

                            width: 108
                            height: carousel.height
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: win.sel = index
                            onClicked: win.run()

                            readonly property bool selected: index === win.sel

                            Rectangle {
                                anchors.fill: parent
                                color: card.selected ? "#292C30" : "transparent"
                                border.width: 1
                                border.color: card.selected ? "#FFD063" : "#292C30"

                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: 120
                                    }
                                }

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 8

                                    IconImage {
                                        Layout.alignment: Qt.AlignHCenter
                                        Layout.fillHeight: true
                                        implicitSize: 46
                                        source: Quickshell.iconPath(card.modelData.icon, "application-x-executable")
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: card.modelData.name
                                        color: card.selected ? "#FFD063" : "#EEEEEE"
                                        font.pointSize: 9
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideRight
                                        maximumLineCount: 2
                                        wrapMode: Text.Wrap
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: model.apps.length === 0
                        text: "no matches"
                        color: "#7A7B7D"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 16
                    }
                }
            }
        }
    }
}

pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// Variant 2 — "Grid": centered app-drawer with a dim backdrop and icon tiles.
Scope {
    id: root

    property bool active: false

    function toggle() {
        root.active = !root.active;
    }

    GlobalShortcut {
        name: "launcher2"
        description: "Toggle app launcher (Grid)"
        onPressed: root.toggle()
    }

    PanelWindow {
        id: win

        visible: root.active

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        // Ignore other panels' exclusive zones so the full-screen dim
        // backdrop below isn't shrunk away from the bar strips.
        exclusionMode: ExclusionMode.Ignore

        color: "transparent"

        anchors {
            top: true
            left: true
            right: true
            bottom: true
        }

        property int sel: 0

        onVisibleChanged: {
            if (visible) {
                input.text = "";
                sel = 0;
                input.forceActiveFocus();
            }
        }

        function move(delta) {
            const n = model.apps.length;
            if (n === 0)
                return;
            const next = win.sel + delta;
            if (next < 0 || next >= n)
                return;
            win.sel = next;
            grid.positionViewAtIndex(next, GridView.Contain);
        }

        function run() {
            if (model.launch(sel))
                root.active = false;
        }

        AppModel {
            id: model
            search: input.text
        }

        // Dim backdrop — click anywhere outside to dismiss.
        Rectangle {
            anchors.fill: parent
            color: "#0A0A0C"
            opacity: 0.55

            MouseArea {
                anchors.fill: parent
                onClicked: root.active = false
            }
        }

        Rectangle {
            id: panel
            anchors.centerIn: parent
            width: 760
            height: 560

            color: "#0F1012"
            border.width: 1
            border.color: "#FFD063"
            opacity: 0.98

            // Accent corner brackets for the cyberpunk frame.
            Rectangle {
                anchors.top: parent.top
                anchors.left: parent.left
                width: 5
                height: 28
                color: "#FFD063"
            }
            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                width: 28
                height: 5
                color: "#FFD063"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 14

                // Search header
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Text {
                        text: "APPS"
                        color: "#FFD063"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 22
                        font.letterSpacing: 3
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 34

                        Rectangle {
                            anchors.fill: parent
                            color: "#292C30"
                            border.width: 1
                            border.color: input.activeFocus ? "#FFD063" : "#7A7B7D"

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            TextInput {
                                id: input
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                verticalAlignment: TextInput.AlignVCenter

                                color: "#EEEEEE"
                                font.pointSize: 13
                                clip: true

                                Keys.onPressed: event => {
                                    const cols = Math.max(1, Math.floor(grid.width / grid.cellWidth));
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
                                    case Qt.Key_Down:
                                        win.move(cols);
                                        event.accepted = true;
                                        break;
                                    case Qt.Key_Up:
                                        win.move(-cols);
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
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: input.text.length === 0
                                    text: "Type to search…"
                                    color: "#7A7B7D"
                                    font: input.font
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    color: "#FFD063"
                    implicitHeight: 3
                    Layout.fillWidth: true
                }

                GridView {
                    id: grid
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    clip: true
                    model: model.apps
                    currentIndex: win.sel
                    cellWidth: 140
                    cellHeight: 128
                    boundsBehavior: Flickable.StopAtBounds

                    delegate: MouseArea {
                        id: tile
                        required property int index
                        required property var modelData

                        width: grid.cellWidth
                        height: grid.cellHeight
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: win.sel = index
                        onClicked: win.run()

                        readonly property bool selected: index === win.sel

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 6
                            color: tile.selected ? "#292C30" : "transparent"
                            border.width: 1
                            border.color: tile.selected ? "#FFD063" : "transparent"

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
                                    implicitSize: 52
                                    source: Quickshell.iconPath(tile.modelData.icon, "application-x-executable")
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: tile.modelData.name
                                    color: tile.selected ? "#FFD063" : "#EEEEEE"
                                    font.pointSize: 10
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideRight
                                    maximumLineCount: 2
                                    wrapMode: Text.Wrap
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

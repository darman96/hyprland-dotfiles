pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// Variant 5 — "Dock": the Console concept mirrored to the bottom edge. A
// full-width deck rises up out of the bottom bar, which energizes via
// LauncherState.dockOpen while it is open.
Scope {
    id: root

    property bool active: false

    function toggle() {
        root.active = !root.active;
    }

    onActiveChanged: LauncherState.dockOpen = root.active

    GlobalShortcut {
        name: "launcher5"
        description: "Toggle app launcher (Dock)"
        onPressed: root.toggle()
    }

    PanelWindow {
        id: win

        visible: root.active || panel.height > 1

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.active ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        color: "transparent"

        anchors {
            bottom: true
            left: true
            right: true
        }

        // Sit just above the bottom bar strip (12px margin + 6px strip + gap).
        margins {
            bottom: 22
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

        // The deck, rising up from the bottom bar. Content is pinned to the
        // bottom at full height and revealed by the clipping panel as it grows.
        Rectangle {
            id: panel

            anchors.bottom: parent.bottom
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

            Item {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: win.openHeight

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

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

                    Rectangle {
                        color: "#292C30"
                        implicitHeight: 1
                        Layout.fillWidth: true
                    }

                    // Search / command line, sitting next to the bottom bar.
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 18
                        Layout.rightMargin: 18
                        Layout.topMargin: 10
                        Layout.bottomMargin: 12
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

                    // Accent lid — mirrors the bottom bar strip.
                    Rectangle {
                        color: "#FFD063"
                        implicitHeight: 4
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}

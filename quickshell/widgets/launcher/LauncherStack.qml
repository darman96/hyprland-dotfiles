pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// Variant 1 — "Stack": left-anchored vertical list launcher.
// Framed with the top/bottom accent strips used by the main Bar.
Scope {
    id: root

    property bool active: false

    function toggle() {
        root.active = !root.active;
    }

    GlobalShortcut {
        name: "launcher1"
        description: "Toggle app launcher (Stack)"
        onPressed: root.toggle()
    }

    PanelWindow {
        id: win

        visible: root.active

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        color: "transparent"

        anchors {
            top: true
            right: true
            bottom: true
        }

        margins {
            top: 12
            bottom: 12
            right: 12
        }

        implicitWidth: 360

        property int sel: 0
        onSelChanged: list.positionViewAtIndex(sel, ListView.Contain)

        // Reset state each time the panel opens.
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
            sel = (sel + delta + n) % n;
        }

        function run() {
            if (model.launch(sel))
                root.active = false;
        }

        AppModel {
            id: model
            search: input.text
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                color: "#FFD063"
                implicitHeight: 5
                Layout.fillWidth: true
            }

            WrapperRectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                margin: 12
                border.width: 1
                border.color: "#FFD063"
                color: "#0F1012"
                opacity: 0.95

                ColumnLayout {
                    spacing: 10

                    // Search field
                    RowLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Text {
                            text: "▚"
                            color: "#FFD063"
                            font.pointSize: 14
                            font.bold: true
                        }

                        Item {
                            Layout.fillWidth: true
                            implicitHeight: 26

                            TextInput {
                                id: input
                                anchors.fill: parent
                                verticalAlignment: TextInput.AlignVCenter

                                color: "#EEEEEE"
                                font.family: "Digital-7 Mono"
                                font.pointSize: 16
                                clip: true

                                Keys.onPressed: event => {
                                    switch (event.key) {
                                    case Qt.Key_Down:
                                    case Qt.Key_Tab:
                                        win.move(1);
                                        event.accepted = true;
                                        break;
                                    case Qt.Key_Up:
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

                                // Reset selection to top whenever the query changes.
                                onTextChanged: win.sel = 0

                                Text {
                                    anchors.fill: parent
                                    verticalAlignment: Text.AlignVCenter
                                    visible: input.text.length === 0
                                    text: "search"
                                    color: "#7A7B7D"
                                    font: input.font
                                }
                            }
                        }

                        Text {
                            text: model.apps.length
                            color: "#7A7B7D"
                            font.family: "Digital-7 Mono"
                            font.pointSize: 14
                        }
                    }

                    Rectangle {
                        color: "#FFD063"
                        implicitHeight: 2
                        Layout.fillWidth: true
                    }

                    ListView {
                        id: list
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        clip: true
                        model: model.apps
                        currentIndex: win.sel
                        interactive: true
                        boundsBehavior: Flickable.StopAtBounds
                        spacing: 2

                        delegate: MouseArea {
                            id: appRow
                            required property int index
                            required property var modelData

                            width: ListView.view.width
                            implicitHeight: 40
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: win.sel = index
                            onClicked: win.run()

                            readonly property bool selected: index === win.sel

                            Rectangle {
                                anchors.fill: parent
                                color: appRow.selected ? "#292C30" : "transparent"

                                // Accent bar on the selected row.
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    width: 3
                                    color: "#FFD063"
                                    visible: appRow.selected
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 8
                                    spacing: 10

                                    IconImage {
                                        implicitSize: 26
                                        source: Quickshell.iconPath(appRow.modelData.icon, "application-x-executable")
                                    }

                                    ColumnLayout {
                                        spacing: 0
                                        Layout.fillWidth: true

                                        Text {
                                            text: appRow.modelData.name
                                            color: appRow.selected ? "#FFD063" : "#EEEEEE"
                                            font.pointSize: 12
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }

                                        Text {
                                            visible: text.length > 0
                                            text: appRow.modelData.genericName || appRow.modelData.comment || ""
                                            color: "#7A7B7D"
                                            font.pointSize: 9
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                color: "#FFD063"
                implicitHeight: 5
                Layout.fillWidth: true
            }
        }
    }
}

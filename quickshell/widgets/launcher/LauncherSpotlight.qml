pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// Variant 3 — "Spotlight": top-center command bar with a compact result list.
Scope {
    id: root

    property bool active: false

    function toggle() {
        root.active = !root.active;
    }

    GlobalShortcut {
        name: "launcher3"
        description: "Toggle app launcher (Spotlight)"
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

        readonly property int maxRows: 7

        property int sel: 0
        onSelChanged: list.positionViewAtIndex(sel, ListView.Contain)

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

        // Dim backdrop — click to dismiss.
        MouseArea {
            anchors.fill: parent
            onClicked: root.active = false
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Math.round(parent.height * 0.16)
            width: 640
            spacing: 0

            // Command line
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 60
                color: "#0F1012"
                border.width: 1
                border.color: "#FFD063"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 18
                    spacing: 14

                    Text {
                        text: ">"
                        color: "#FFD063"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 26
                        font.bold: true
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 34

                        TextInput {
                            id: input
                            anchors.fill: parent
                            verticalAlignment: TextInput.AlignVCenter

                            color: "#EEEEEE"
                            font.pointSize: 17
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

                            onTextChanged: win.sel = 0

                            Text {
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                visible: input.text.length === 0
                                text: "run application"
                                color: "#7A7B7D"
                                font: input.font
                            }
                        }
                    }

                    Text {
                        text: model.apps.length + " ▸"
                        color: "#7A7B7D"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 16
                    }
                }
            }

            // Accent seam between the command line and results.
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 3
                color: "#FFD063"
                visible: model.apps.length > 0
            }

            // Results
            Rectangle {
                Layout.fillWidth: true
                // Cap the visible height to maxRows; scroll beyond that.
                implicitHeight: Math.min(model.apps.length, win.maxRows) * 44 + 2
                color: "#0F1012"
                opacity: 0.97
                visible: model.apps.length > 0
                border.width: 1
                border.color: "#292C30"

                ListView {
                    id: list
                    anchors.fill: parent
                    anchors.margins: 1

                    clip: true
                    model: model.apps
                    currentIndex: win.sel
                    interactive: contentHeight > height
                    boundsBehavior: Flickable.StopAtBounds

                    delegate: MouseArea {
                        id: entry
                        required property int index
                        required property var modelData

                        width: ListView.view.width
                        implicitHeight: 44
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: win.sel = index
                        onClicked: win.run()

                        readonly property bool selected: index === win.sel

                        Rectangle {
                            anchors.fill: parent
                            color: entry.selected ? "#1A1C1F" : "transparent"

                            Rectangle {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: 3
                                color: "#FFD063"
                                visible: entry.selected
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 12

                                IconImage {
                                    implicitSize: 24
                                    source: Quickshell.iconPath(entry.modelData.icon, "application-x-executable")
                                }

                                Text {
                                    text: entry.modelData.name
                                    color: entry.selected ? "#FFD063" : "#EEEEEE"
                                    font.pointSize: 12
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: entry.modelData.genericName || ""
                                    color: "#7A7B7D"
                                    font.pointSize: 10
                                    elide: Text.ElideRight
                                    Layout.maximumWidth: 200
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

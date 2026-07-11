pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

// The right bar: a compact utility strip for the SystemTray icons, styled
// in the same family as the Launcher (V6 "Slant") and SideBar — accent
// color, chamfered corners, Digital-7 Mono, the slash-trio motif — but with
// its own plain, evenly-chamfered panel rather than their ornate
// bracket-and-cap silhouette, since this is a secondary/utility bar rather
// than a hero surface.
Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win

            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                right: true
                bottom: true
            }

            margins {
                top: 8
            }

            readonly property int pad: 10
            implicitWidth: 64 + 2 * pad

            Item {
                id: frame

                anchors.fill: parent
                anchors.margins: win.pad

                readonly property int chamfer: 14 // uniform corner cut on all four corners

                Shape {
                    id: panelShape
                    anchors.fill: parent
                    preferredRendererType: Shape.CurveRenderer

                    ShapePath {
                        fillColor: "#0F1012"
                        strokeColor: "#FFD063"
                        strokeWidth: 2

                        startX: frame.chamfer
                        startY: 0
                        PathLine {
                            x: panelShape.width - frame.chamfer
                            y: 0
                        }
                        PathLine {
                            x: panelShape.width
                            y: frame.chamfer
                        }
                        PathLine {
                            x: panelShape.width
                            y: panelShape.height - frame.chamfer
                        }
                        PathLine {
                            x: panelShape.width - frame.chamfer
                            y: panelShape.height
                        }
                        PathLine {
                            x: frame.chamfer
                            y: panelShape.height
                        }
                        PathLine {
                            x: 0
                            y: panelShape.height - frame.chamfer
                        }
                        PathLine {
                            x: 0
                            y: frame.chamfer
                        }
                        PathLine {
                            x: frame.chamfer
                            y: 0
                        }
                    }
                }

                // ── Content ────────────────────────────────────────────────
                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 20
                    anchors.bottomMargin: 20
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 14

                    // Slash-trio deco, echoing the launcher/sidebar header motif.
                    Shape {
                        id: slashes
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 26
                        implicitHeight: 20
                        preferredRendererType: Shape.CurveRenderer

                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: 6
                            startY: 0
                            PathLine { x: 10; y: 0 }
                            PathLine { x: 4; y: slashes.height }
                            PathLine { x: 0; y: slashes.height }
                            PathLine { x: 6; y: 0 }
                        }
                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: 15
                            startY: 0
                            PathLine { x: 19; y: 0 }
                            PathLine { x: 13; y: slashes.height }
                            PathLine { x: 9; y: slashes.height }
                            PathLine { x: 15; y: 0 }
                        }
                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: 24
                            startY: 0
                            PathLine { x: 28; y: 0 }
                            PathLine { x: 22; y: slashes.height }
                            PathLine { x: 18; y: slashes.height }
                            PathLine { x: 24; y: 0 }
                        }
                    }

                    // Slanted divider
                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 4

                        Shape {
                            id: divider
                            anchors.fill: parent
                            preferredRendererType: Shape.CurveRenderer
                            ShapePath {
                                strokeWidth: 0
                                fillColor: "#FFD063"
                                startX: 8
                                startY: 0
                                PathLine { x: divider.width; y: 0 }
                                PathLine { x: divider.width - 8; y: divider.height }
                                PathLine { x: 0; y: divider.height }
                                PathLine { x: 8; y: 0 }
                            }
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "TRAY"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 12
                        color: "#7A7B7D"
                    }

                    ListView {
                        id: trayList
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        clip: true
                        spacing: 10
                        boundsBehavior: Flickable.StopAtBounds
                        model: SystemTray.items

                        delegate: Item {
                            required property SystemTrayItem modelData

                            width: ListView.view.width
                            implicitHeight: 36

                            SysTrayItem {
                                anchors.horizontalCenter: parent.horizontalCenter
                                modelData: parent.modelData
                            }
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        visible: SystemTray.items.values.length === 0
                        text: "--"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 14
                        color: "#7A7B7D"
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: SystemTray.items.values.length
                        font.family: "Digital-7 Mono"
                        font.pointSize: 16
                        color: "#EEEEEE"
                    }
                }
            }
        }
    }
}

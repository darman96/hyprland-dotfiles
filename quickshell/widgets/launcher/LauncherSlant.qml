pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

// Variant 6 — "Slant": breaks up the rectangular layout with angled geometry —
// a chamfered panel, a slanted header divider and sheared row highlights.
Scope {
    id: root

    property bool active: false

    function toggle() {
        root.active = !root.active;
    }

    GlobalShortcut {
        name: "launcher6"
        description: "Toggle app launcher (Slant)"
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
        Rectangle {
            anchors.fill: parent
            color: "#0A0A0C"
            opacity: 0.55

            MouseArea {
                anchors.fill: parent
                onClicked: root.active = false
            }
        }

        Item {
            id: frame
            anchors.centerIn: parent
            width: 620
            height: 470

            readonly property int chamfer: 18
            readonly property int bevel: 4   // inward thickness of the bevel borders
            readonly property int chunkThick: 8   // outward thickness of the heavy border chunks
            readonly property int chunkSlant: 12  // slant of their end pieces
            readonly property int capSize: 10     // floating triangle cap in the bottom-right notch
            readonly property int smallChamfer: 6  // small bevel on the top-right & bottom-left corners

            // Chamfered panel: rectangle with the top-left and bottom-right
            // corners cut off, filled dark with an accent edge.
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
                    // top edge to the small top-right bevel
                    PathLine {
                        x: panelShape.width - frame.smallChamfer
                        y: 0
                    }
                    PathLine {
                        x: panelShape.width
                        y: frame.smallChamfer
                    }
                    PathLine {
                        x: panelShape.width
                        y: panelShape.height - frame.chamfer
                    }
                    PathLine {
                        x: panelShape.width - frame.chamfer
                        y: panelShape.height
                    }
                    // bottom edge to the small bottom-left bevel
                    PathLine {
                        x: frame.smallChamfer
                        y: panelShape.height
                    }
                    PathLine {
                        x: 0
                        y: panelShape.height - frame.smallChamfer
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

                // Thick top-left bevel border — a trapezoid whose inner ends
                // run out to the top and left edges to meet the straight borders.
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    startX: 0
                    startY: frame.chamfer
                    PathLine {
                        x: frame.chamfer
                        y: 0
                    }
                    PathLine {
                        x: frame.chamfer + 2 * frame.bevel
                        y: 0
                    }
                    PathLine {
                        x: 0
                        y: frame.chamfer + 2 * frame.bevel
                    }
                    PathLine {
                        x: 0
                        y: frame.chamfer
                    }
                }

                // Thick bottom-right bevel border — trapezoid running out to the
                // bottom and right edges.
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    startX: panelShape.width
                    startY: panelShape.height - frame.chamfer
                    PathLine {
                        x: panelShape.width - frame.chamfer
                        y: panelShape.height
                    }
                    PathLine {
                        x: panelShape.width - frame.chamfer - 2 * frame.bevel
                        y: panelShape.height
                    }
                    PathLine {
                        x: panelShape.width
                        y: panelShape.height - frame.chamfer - 2 * frame.bevel
                    }
                    PathLine {
                        x: panelShape.width
                        y: panelShape.height - frame.chamfer
                    }
                }

                // Floating triangle cap sitting in the bottom-right bevel notch,
                // detached from the panel by the width of the cut.
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    startX: panelShape.width
                    startY: panelShape.height
                    PathLine {
                        x: panelShape.width
                        y: panelShape.height - frame.capSize
                    }
                    PathLine {
                        x: panelShape.width - frame.capSize
                        y: panelShape.height
                    }
                    PathLine {
                        x: panelShape.width
                        y: panelShape.height
                    }
                }

                // Heavy outward chunk wrapping the bottom-left corner: a third of
                // the way across the bottom edge and 40px up the left edge, with
                // slanted end pieces on both arms.
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    // inner, right end of the bottom arm
                    startX: panelShape.width / 3
                    startY: panelShape.height
                    // outer, slanted right end of the bottom arm
                    PathLine {
                        x: panelShape.width / 3 - frame.chunkSlant
                        y: panelShape.height + frame.chunkThick
                    }
                    // outer bevel across the corner
                    PathLine {
                        x: frame.smallChamfer
                        y: panelShape.height + frame.chunkThick
                    }
                    PathLine {
                        x: -frame.chunkThick
                        y: panelShape.height - frame.smallChamfer
                    }
                    // outer, slanted top end of the left arm
                    PathLine {
                        x: -frame.chunkThick
                        y: panelShape.height - panelShape.height / 7 + frame.chunkSlant
                    }
                    // inner, top end of the left arm
                    PathLine {
                        x: 0
                        y: panelShape.height - panelShape.height / 7
                    }
                    // inner bevel across the corner, then back along the bottom edge
                    PathLine {
                        x: 0
                        y: panelShape.height - frame.smallChamfer
                    }
                    PathLine {
                        x: frame.smallChamfer
                        y: panelShape.height
                    }
                    PathLine {
                        x: panelShape.width / 3
                        y: panelShape.height
                    }
                }

                // Heavy outward chunk wrapping the top-right corner: down a third
                // of the right edge and a fifth back along the top edge, with
                // slanted end pieces on both arms.
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    // inner, bottom of the right arm
                    startX: panelShape.width
                    startY: panelShape.height / 3
                    // outer, slanted bottom end of the right arm
                    PathLine {
                        x: panelShape.width + frame.chunkThick
                        y: panelShape.height / 3 - frame.chunkSlant
                    }
                    // outer bevel across the corner
                    PathLine {
                        x: panelShape.width + frame.chunkThick
                        y: frame.smallChamfer
                    }
                    PathLine {
                        x: panelShape.width - frame.smallChamfer
                        y: -frame.chunkThick
                    }
                    // outer, slanted left end of the top arm
                    PathLine {
                        x: panelShape.width - panelShape.width / 5 + frame.chunkSlant
                        y: -frame.chunkThick
                    }
                    // inner, left end of the top arm
                    PathLine {
                        x: panelShape.width - panelShape.width / 5
                        y: 0
                    }
                    // inner bevel across the corner, then back down the right edge
                    PathLine {
                        x: panelShape.width - frame.smallChamfer
                        y: 0
                    }
                    PathLine {
                        x: panelShape.width
                        y: frame.smallChamfer
                    }
                    PathLine {
                        x: panelShape.width
                        y: panelShape.height / 3
                    }
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 28
                anchors.bottomMargin: 28
                anchors.leftMargin: 30
                anchors.rightMargin: 26
                spacing: 14

                // Header: slash-trio deco + prompt + count
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    // Slanted slash trio, echoing the SearchBar motif.
                    Shape {
                        id: slashes
                        implicitWidth: 26
                        implicitHeight: 22
                        Layout.alignment: Qt.AlignVCenter
                        preferredRendererType: Shape.CurveRenderer

                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: 6
                            startY: 0
                            PathLine {
                                x: 10
                                y: 0
                            }
                            PathLine {
                                x: 4
                                y: slashes.height
                            }
                            PathLine {
                                x: 0
                                y: slashes.height
                            }
                            PathLine {
                                x: 6
                                y: 0
                            }
                        }
                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: 15
                            startY: 0
                            PathLine {
                                x: 19
                                y: 0
                            }
                            PathLine {
                                x: 13
                                y: slashes.height
                            }
                            PathLine {
                                x: 9
                                y: slashes.height
                            }
                            PathLine {
                                x: 15
                                y: 0
                            }
                        }
                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: 24
                            startY: 0
                            PathLine {
                                x: 28
                                y: 0
                            }
                            PathLine {
                                x: 22
                                y: slashes.height
                            }
                            PathLine {
                                x: 18
                                y: slashes.height
                            }
                            PathLine {
                                x: 24
                                y: 0
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 30

                        TextInput {
                            id: input
                            anchors.fill: parent
                            verticalAlignment: TextInput.AlignVCenter

                            color: "#EEEEEE"
                            font.family: "Digital-7 Mono"
                            font.pointSize: 20
                            font.letterSpacing: 1
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
                                text: "run"
                                color: "#7A7B7D"
                                font: input.font
                            }
                        }
                    }

                    Text {
                        text: model.apps.length
                        color: "#7A7B7D"
                        font.family: "Digital-7 Mono"
                        font.pointSize: 18
                    }
                }

                // Slanted divider.
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 4

                    Shape {
                        id: divider
                        anchors.fill: parent
                        preferredRendererType: Shape.CurveRenderer

                        readonly property int slant: 2
                        readonly property int chunk: 6
                        readonly property int chunkSlant: 6
                        readonly property int leftChunkLength: 2
                        readonly property int rightChunkLength: 7

                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: divider.slant
                            startY: 0
                            PathLine {
                                x: divider.width
                                y: 0
                            }
                            PathLine {
                                x: divider.width - divider.slant
                                y: divider.height
                            }
                            PathLine {
                                x: 0
                                y: divider.height
                            }
                            PathLine {
                                x: divider.slant
                                y: 0
                            }
                        }

                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: 0
                            startY: divider.height
                            PathLine {
                                x: divider.width / divider.leftChunkLength
                                y: divider.height
                            }
                            PathLine {
                                x: divider.width / divider.leftChunkLength - divider.chunkSlant
                                y: divider.height + divider.chunk
                            }
                            PathLine {
                                x: 0
                                y: divider.height + divider.chunk
                            }
                            PathLine {
                                x: 0
                                y: divider.height
                            }
                        }

                        ShapePath {
                            strokeWidth: 0
                            fillColor: "#FFD063"
                            startX: divider.width
                            startY: 0
                            PathLine {
                                x: divider.width - divider.width / divider.rightChunkLength
                                y: 0
                            }
                            PathLine {
                                x: divider.width - divider.width / divider.rightChunkLength + divider.chunkSlant
                                y: -divider.chunk
                            }
                            PathLine {
                                x: divider.width
                                y: -divider.chunk
                            }
                            PathLine {
                                x: divider.width
                                y: 0
                            }
                        }
                    }
                }

                ListView {
                    id: list
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    clip: true
                    model: model.apps
                    currentIndex: win.sel
                    spacing: 3
                    boundsBehavior: Flickable.StopAtBounds

                    delegate: MouseArea {
                        id: appRow
                        required property int index
                        required property var modelData

                        readonly property int shear: 14

                        width: ListView.view.width
                        implicitHeight: 42
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: win.sel = index
                        onClicked: win.run()

                        readonly property bool selected: index === win.sel

                        // Sheared (parallelogram) selection highlight — the
                        // rows are anything but rectangular when active.
                        Shape {
                            id: rowShape
                            anchors.fill: parent
                            visible: appRow.selected
                            preferredRendererType: Shape.CurveRenderer

                            // Body
                            ShapePath {
                                strokeWidth: 0
                                fillColor: "#22262C"
                                startX: appRow.shear
                                startY: 0
                                PathLine {
                                    x: rowShape.width
                                    y: 0
                                }
                                PathLine {
                                    x: rowShape.width - appRow.shear
                                    y: rowShape.height
                                }
                                PathLine {
                                    x: 0
                                    y: rowShape.height
                                }
                                PathLine {
                                    x: appRow.shear
                                    y: 0
                                }
                            }
                            // Left accent edge
                            ShapePath {
                                strokeWidth: 0
                                fillColor: "#FFD063"
                                startX: appRow.shear
                                startY: 0
                                PathLine {
                                    x: appRow.shear + 5
                                    y: 0
                                }
                                PathLine {
                                    x: 5
                                    y: rowShape.height
                                }
                                PathLine {
                                    x: 0
                                    y: rowShape.height
                                }
                                PathLine {
                                    x: appRow.shear
                                    y: 0
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: appRow.shear + 16
                            anchors.rightMargin: 12
                            spacing: 12

                            IconImage {
                                implicitSize: 28
                                source: Quickshell.iconPath(appRow.modelData.icon, "application-x-executable")
                            }

                            Text {
                                text: appRow.modelData.name
                                color: appRow.selected ? "#FFD063" : "#EEEEEE"
                                font.pointSize: 12
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: appRow.modelData.genericName || ""
                                color: "#7A7B7D"
                                font.pointSize: 10
                                elide: Text.ElideRight
                                Layout.maximumWidth: 220
                            }
                        }
                    }
                }
            }
        }
    }
}

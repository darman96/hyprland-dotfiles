pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

// A vertical sidebar carrying the "Slant" (launcher V6) visual language —
// chamfered panel, thick trapezoid bevel accents, an outward bracket, a
// floating triangle cap and a slanted divider. Right-anchored, mirrored.
Scope {
    id: root

    property bool active: true

    function toggle() {
        root.active = !root.active;
    }

    GlobalShortcut {
        name: "sidebar"
        description: "Toggle the Slant sidebar"
        onPressed: root.toggle()
    }

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real maxVolume: 1.5

    PwObjectTracker {
        objects: [root.sink]
    }

    PanelWindow {
        id: win

        visible: root.active

        color: "transparent"

        anchors {
            top: true
            right: true
            bottom: true
        }

        margins {
            top: 8
        }

        // Frame width plus the gutter the outward bracket grows into.
        readonly property int pad: 10
        implicitWidth: 72 + 2 * pad

        Item {
            id: frame

            // Inset so the outward bracket has room in the gutter.
            anchors.fill: parent
            anchors.margins: win.pad

            readonly property int chamfer: 18       // big cut corners (top-right, bottom-left)
            readonly property int smallChamfer: 7   // small bevel (top-left, bottom-right)
            readonly property int bevel: 4          // inward thickness of the trapezoid accents
            readonly property int chunkThick: 7      // outward thickness of the bracket
            readonly property int chunkSlant: 10    // slant of the bracket end pieces
            readonly property int capSize: 10       // floating triangle cap
            readonly property int armSide: 58       // bracket arm down the left edge
            readonly property int armTop: 34        // bracket arm along the top edge

            Shape {
                id: panelShape
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer

                // Panel: big chamfers on top-right & bottom-left, small bevels
                // on top-left & bottom-right (mirror of the left-anchored panel).
                ShapePath {
                    fillColor: "#0F1012"
                    strokeColor: "#FFD063"
                    strokeWidth: 2

                    startX: panelShape.width - frame.chamfer
                    startY: 0
                    PathLine {
                        x: frame.smallChamfer
                        y: 0
                    }
                    PathLine {
                        x: 0
                        y: frame.smallChamfer
                    }
                    PathLine {
                        x: 0
                        y: panelShape.height - frame.chamfer
                    }
                    PathLine {
                        x: frame.chamfer
                        y: panelShape.height
                    }
                    PathLine {
                        x: panelShape.width - frame.smallChamfer
                        y: panelShape.height
                    }
                    PathLine {
                        x: panelShape.width
                        y: panelShape.height - frame.smallChamfer
                    }
                    PathLine {
                        x: panelShape.width
                        y: frame.chamfer
                    }
                    PathLine {
                        x: panelShape.width - frame.chamfer
                        y: 0
                    }
                }

                // Thick top-right bevel accent (trapezoid to the edges).
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    startX: panelShape.width
                    startY: frame.chamfer
                    PathLine {
                        x: panelShape.width - frame.chamfer
                        y: 0
                    }
                    PathLine {
                        x: panelShape.width - frame.chamfer - 2 * frame.bevel
                        y: 0
                    }
                    PathLine {
                        x: panelShape.width
                        y: frame.chamfer + 2 * frame.bevel
                    }
                    PathLine {
                        x: panelShape.width
                        y: frame.chamfer
                    }
                }

                // Thick bottom-left bevel accent.
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    startX: 0
                    startY: panelShape.height - frame.chamfer
                    PathLine {
                        x: frame.chamfer
                        y: panelShape.height
                    }
                    PathLine {
                        x: frame.chamfer + 2 * frame.bevel
                        y: panelShape.height
                    }
                    PathLine {
                        x: 0
                        y: panelShape.height - frame.chamfer - 2 * frame.bevel
                    }
                    PathLine {
                        x: 0
                        y: panelShape.height - frame.chamfer
                    }
                }

                // Floating triangle cap in the bottom-left notch.
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    startX: 0
                    startY: panelShape.height
                    PathLine {
                        x: 0
                        y: panelShape.height - frame.capSize
                    }
                    PathLine {
                        x: frame.capSize
                        y: panelShape.height
                    }
                    PathLine {
                        x: 0
                        y: panelShape.height
                    }
                }

                // Outward bracket wrapping the top-left corner: down the left
                // edge and along the top edge, with slanted ends and a beveled
                // corner following the small chamfer.
                ShapePath {
                    strokeWidth: 0
                    fillColor: "#FFD063"

                    startX: 0
                    startY: frame.armSide
                    PathLine {
                        x: -frame.chunkThick
                        y: frame.armSide - frame.chunkSlant
                    }
                    PathLine {
                        x: -frame.chunkThick
                        y: frame.smallChamfer
                    }
                    PathLine {
                        x: frame.smallChamfer
                        y: -frame.chunkThick
                    }
                    PathLine {
                        x: frame.armTop - frame.chunkSlant
                        y: -frame.chunkThick
                    }
                    PathLine {
                        x: frame.armTop
                        y: 0
                    }
                    PathLine {
                        x: frame.smallChamfer
                        y: 0
                    }
                    PathLine {
                        x: 0
                        y: frame.smallChamfer
                    }
                    PathLine {
                        x: 0
                        y: frame.armSide
                    }
                }
            }

            // ── Content ────────────────────────────────────────────────────
            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 16
                anchors.bottomMargin: 16
                anchors.leftMargin: 10
                anchors.rightMargin: 8
                spacing: 10

                // Clock — Digital-7, hh over mm
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDateTime(clock.date, "hh\nmm")
                    font.family: "Digital-7 Mono"
                    font.pointSize: 22
                    font.letterSpacing: 1
                    color: "#EEEEEE"

                    SystemClock {
                        id: clock
                        precision: SystemClock.Minutes
                    }
                }

                // Date
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDateTime(clock.date, "dd\nMMM").toUpperCase()
                    font.family: "Digital-7 Mono"
                    font.pointSize: 13
                    color: "#FFD063"
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

                Item {
                    Layout.fillHeight: true
                }

                // Volume — vertical meter with a sheared fill and a % readout
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "VOL"
                    font.family: "Digital-7 Mono"
                    font.pointSize: 10
                    color: "#7A7B7D"
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 3

                    // Overflow — three floating slanted segments for volume
                    // pushed above 100%, lit with the same overload color as
                    // the volume OSD.
                    Repeater {
                        model: 3

                        delegate: Item {
                            id: seg
                            required property int index

                            readonly property real segStart: 1 + (2 - index) / 3 * (root.maxVolume - 1)
                            readonly property real segEnd: 1 + (3 - index) / 3 * (root.maxVolume - 1)
                            readonly property real frac: root.muted ? 0 : Math.max(0, Math.min(1, (root.volume - segStart) / (segEnd - segStart)))
                            readonly property int chamfer: 4

                            Layout.alignment: Qt.AlignHCenter
                            implicitWidth: 16
                            implicitHeight: 12

                            // Empty track, chamfered to match the main meter.
                            Shape {
                                anchors.fill: parent
                                preferredRendererType: Shape.CurveRenderer

                                ShapePath {
                                    strokeWidth: 1
                                    strokeColor: "#7A7B7D"
                                    fillColor: "#292C30"

                                    startX: seg.chamfer
                                    startY: 0
                                    PathLine { x: seg.width; y: 0 }
                                    PathLine { x: seg.width; y: seg.height - seg.chamfer }
                                    PathLine { x: seg.width - seg.chamfer; y: seg.height }
                                    PathLine { x: 0; y: seg.height }
                                    PathLine { x: 0; y: seg.chamfer }
                                    PathLine { x: seg.chamfer; y: 0 }
                                }
                            }

                            // Overload fill — reveals a fixed copy of the same
                            // chamfered hexagon from the bottom, so filled and
                            // empty states always share one silhouette.
                            Item {
                                id: segFillClip
                                anchors.left: parent.left
                                anchors.leftMargin: 2
                                anchors.right: parent.right
                                anchors.rightMargin: 2
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 2
                                clip: true
                                height: seg.frac * (seg.height - 4)

                                Shape {
                                    id: segFill
                                    width: seg.width - 4
                                    height: seg.height - 4
                                    y: segFillClip.height - height
                                    preferredRendererType: Shape.CurveRenderer

                                    readonly property int chamfer: seg.chamfer - 2

                                    ShapePath {
                                        strokeWidth: 0
                                        fillColor: "#FF6B4A"
                                        startX: segFill.chamfer
                                        startY: 0
                                        PathLine { x: segFill.width; y: 0 }
                                        PathLine { x: segFill.width; y: segFill.height - segFill.chamfer }
                                        PathLine { x: segFill.width - segFill.chamfer; y: segFill.height }
                                        PathLine { x: 0; y: segFill.height }
                                        PathLine { x: 0; y: segFill.chamfer }
                                        PathLine { x: segFill.chamfer; y: 0 }
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        id: volMeter
                        Layout.alignment: Qt.AlignHCenter
                        implicitWidth: 16
                        implicitHeight: 96

                        readonly property int chamfer: 6

                        // Track — chamfered top-left/bottom-right to match the
                        // panel's slant, so the sheared fill sits in a shape that
                        // agrees with it rather than a plain rectangle.
                        Shape {
                            anchors.fill: parent
                            preferredRendererType: Shape.CurveRenderer

                            ShapePath {
                                strokeWidth: 1
                                strokeColor: "#7A7B7D"
                                fillColor: "#292C30"

                                startX: volMeter.chamfer
                                startY: 0
                                PathLine { x: volMeter.width; y: 0 }
                                PathLine { x: volMeter.width; y: volMeter.height - volMeter.chamfer }
                                PathLine { x: volMeter.width - volMeter.chamfer; y: volMeter.height }
                                PathLine { x: 0; y: volMeter.height }
                                PathLine { x: 0; y: volMeter.chamfer }
                                PathLine { x: volMeter.chamfer; y: 0 }
                            }
                        }

                        // Accent fill — reveals a fixed copy of the same
                        // chamfered hexagon as the track from the bottom, so
                        // the fill and background always share one silhouette.
                        Item {
                            id: fillClip
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            anchors.right: parent.right
                            anchors.rightMargin: 2
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 2
                            clip: true

                            readonly property real frac: root.muted ? 0 : Math.min(root.volume, 1)
                            height: frac * (volMeter.height - 4)

                            Shape {
                                id: vol
                                width: volMeter.width - 4
                                height: volMeter.height - 4
                                y: fillClip.height - height
                                preferredRendererType: Shape.CurveRenderer

                                readonly property int chamfer: volMeter.chamfer - 2

                                ShapePath {
                                    strokeWidth: 0
                                    fillColor: root.muted ? "#7A7B7D" : "#FFD063"
                                    startX: vol.chamfer
                                    startY: 0
                                    PathLine { x: vol.width; y: 0 }
                                    PathLine { x: vol.width; y: vol.height - vol.chamfer }
                                    PathLine { x: vol.width - vol.chamfer; y: vol.height }
                                    PathLine { x: 0; y: vol.height }
                                    PathLine { x: 0; y: vol.chamfer }
                                    PathLine { x: vol.chamfer; y: 0 }
                                }
                            }
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: root.muted ? "--" : Math.round(root.volume * 100)
                    font.family: "Digital-7 Mono"
                    font.pointSize: 14
                    color: root.muted ? "#7A7B7D" : "#EEEEEE"
                }
            }
        }
    }
}

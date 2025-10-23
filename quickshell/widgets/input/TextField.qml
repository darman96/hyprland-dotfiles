import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

import qs.widgets.decoration

WrapperItem {
    RowLayout {
        spacing: 6

        Item {
            id: container

            Layout.fillWidth: true

            implicitHeight: 22

            Shape {
                id: shape
                anchors.fill: container
                preferredRendererType: Shape.CurveRenderer

                ShapePath {
                    strokeWidth: 0
                    fillColor: "#0F1012"

                    startX: 8
                    startY: 0

                    PathLine {
                        x: 12
                        y: 0
                    }

                    PathLine {
                        x: 4
                        y: shape.height
                    }

                    PathLine {
                        x: 0
                        y: shape.height
                    }

                    PathLine {
                        x: 8
                        y: 0
                    }
                }

                ShapePath {
                    strokeWidth: 0
                    fillColor: "#0F1012"

                    startX: 16
                    startY: 0

                    PathLine {
                        x: 20
                        y: 0
                    }

                    PathLine {
                        x: 12
                        y: shape.height
                    }

                    PathLine {
                        x: 8
                        y: shape.height
                    }

                    PathLine {
                        x: 16
                        y: 0
                    }
                }

                ShapePath {
                    startX: 24
                    startY: 0

                    strokeWidth: 0
                    fillColor: "#0F1012"

                    PathLine {
                        x: shape.width
                        y: 0
                    }

                    PathLine {
                        x: shape.width - 8
                        y: shape.height
                    }

                    PathLine {
                        x: 16
                        y: shape.height
                    }

                    PathLine {
                        x: 24
                        y: 0
                    }
                }
            }
        }
    }
}

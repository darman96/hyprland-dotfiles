import QtQuick
import QtQuick.Shapes

Shape {
    preferredRendererType: Shape.CurveRenderer
    ShapePath {
        fillColor: "#FFD063"
        strokeWidth: 0

        startX: 0
        startY: 0

        PathLine {
            x: parent.width
            y: 0
        }

        PathLine {
            x: parent.width - 15
            y: 38
        }

        PathLine {
            x: parent.width - 15
            y: parent.height - 15
        }

        PathLine {
            x: parent.width - 30
            y: parent.height
        }

        PathLine {
            x: 0
            y: parent.height
        }

        PathLine {
            x: 0
            y: 0
        }
    }
}

import QtQuick
import QtQuick.Shapes

Item {
    Shape {
        id: shape

        anchors.fill: parent

        preferredRendererType: Shape.CurveRenderer
        ShapePath {
            strokeWidth: 4
            strokeColor: "black"

            startX: shape.width
            startY: 0

            PathLine {
                x: 0
                y: shape.height
            }
        }
    }
}

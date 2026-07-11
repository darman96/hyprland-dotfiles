import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Shapes

// A single tray icon, chamfered to match the Slant (launcher V6 / SideBar)
// visual language instead of a plain rectangular hit target.
MouseArea {
    id: root

    required property SystemTrayItem modelData

    implicitWidth: 36
    implicitHeight: 36

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            modelData.activate();
        } else if (modelData.hasMenu) {
            const window = root.QsWindow?.window;
            modelData.display(window, window.width, root.mapToItem(null, 0, 0).y);
        }
        event.accepted = true;
    }

    readonly property int chamfer: 6

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: 1
            strokeColor: root.containsMouse ? "#FFD063" : "#7A7B7D"
            fillColor: "#292C30"

            startX: root.chamfer
            startY: 0
            PathLine { x: root.width; y: 0 }
            PathLine { x: root.width; y: root.height - root.chamfer }
            PathLine { x: root.width - root.chamfer; y: root.height }
            PathLine { x: 0; y: root.height }
            PathLine { x: 0; y: root.chamfer }
            PathLine { x: root.chamfer; y: 0 }

            Behavior on strokeColor {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

    Image {
        anchors.centerIn: parent
        source: modelData.icon
        fillMode: Image.PreserveAspectFit
        width: 20
        height: 20
    }
}

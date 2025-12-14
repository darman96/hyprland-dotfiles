import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root

    required property SystemTrayItem modelData

    implicitHeight: 32
    Layout.fillWidth: true

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    cursorShape: Qt.PointingHandCursor

    onClicked: event => {
        if (event.button == Qt.LeftButton) {
            print("Left clicked")
            modelData.activate();
        } else {
            const window = root.QsWindow?.window
            if (modelData.hasMenu) {
                print("Right clicked")
                modelData.display(window, window.width - 20, window.height - 20)
            }
        }
        event.accepted = true
    }

    // Display the icon
    Image {
        anchors.centerIn: parent
        source: modelData.icon // The icon source provided by the application

        // Scale the icon if necessary
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        width: 24
        height: 24
    }
}
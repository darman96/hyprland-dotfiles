import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

WrapperMouseArea {
    default property alias content: inner.data

    hoverEnabled: true

    onEntered: {
        inner.border.color = "#FFD063";
    }
    onExited: {
        inner.border.color = "#7A7B7D";
    }

    Layout.fillWidth: true

    WrapperRectangle {
        id: inner
        border.width: 1
        border.color: "#7A7B7D"
        margin: 8

        color: "#292C30"

        Behavior on border.color {
            ColorAnimation {
                duration: 150
            }
        }
    }
}

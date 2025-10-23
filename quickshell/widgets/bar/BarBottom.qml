pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                bottom: true
                left: true
                right: true
            }

            implicitHeight: wrapper.implicitHeight

            WrapperRectangle {
                id: wrapper

                color: "transparent"

                anchors.fill: parent

                margin: 12
                topMargin: 0

                Rectangle {
                    implicitHeight: 6

                    color: "#FFD063"
                }
            }
        }
    }
}

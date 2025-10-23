pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick

import qs.widgets.launcher

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: topBar

            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: wrapper.implicitHeight

            WrapperRectangle {
                id: wrapper

                color: "transparent"

                anchors.fill: parent

                margin: 12
                bottomMargin: 0

                Rectangle {
                    implicitHeight: 6

                    color: "#FFD063"
                }
            }
        }
    }
}

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

                    // Brightens when the Console launcher (variant 4) opens.
                    color: LauncherState.consoleOpen ? "#FFF3C0" : "#FFD063"

                    Behavior on color {
                        ColorAnimation {
                            duration: 250
                        }
                    }

                    // Gentle "listening" pulse while the console is open.
                    Rectangle {
                        anchors.fill: parent
                        color: "#FFFFFF"
                        opacity: 0
                        visible: LauncherState.consoleOpen

                        SequentialAnimation on opacity {
                            running: LauncherState.consoleOpen
                            loops: Animation.Infinite

                            NumberAnimation {
                                to: 0.4
                                duration: 700
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                to: 0.0
                                duration: 700
                                easing.type: Easing.InOutSine
                            }
                        }
                    }
                }
            }
        }
    }
}

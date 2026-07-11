pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.widgets.launcher

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

                leftMargin: 12
                rightMargin: 12
                bottomMargin: 12

                Rectangle {
                    implicitHeight: 12

                    // Brightens when the Dock launcher (variant 5) opens.
                    color: LauncherState.dockOpen ? "#FFF3C0" : "#FFD063"

                    Behavior on color {
                        ColorAnimation {
                            duration: 250
                        }
                    }

                    // Gentle "listening" pulse while the dock is open.
                    Rectangle {
                        anchors.fill: parent
                        color: "#FFFFFF"
                        opacity: 0
                        visible: LauncherState.dockOpen

                        SequentialAnimation on opacity {
                            running: LauncherState.dockOpen
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

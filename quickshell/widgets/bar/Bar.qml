pragma ComponentBehavior: Bound

import "modules"

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property string time

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                right: true
                bottom: true
            }

            implicitWidth: wrapper.implicitWidth

            WrapperRectangle {
                id: wrapper

                color: "transparent"

                anchors.fill: parent

                margin: 12
                leftMargin: 0

                ColumnLayout {
                    spacing: 0

                    Rectangle {
                        color: "#FFD063"
                        implicitHeight: 5

                        Layout.fillWidth: true
                    }

                    WrapperRectangle {
                        id: innerWrapper

                        margin: 12

                        border.width: 1
                        border.color: "#FFD063"

                        color: "#0F1012"
                        opacity: .9

                        Layout.fillHeight: true

                        ColumnLayout {
                            id: layout

                            spacing: 12

                            Date {}
                            Clock {}

                            Rectangle {
                                color: "#FFD063"
                                implicitHeight: 3

                                Layout.fillWidth: true
                            }

                            Rectangle {
                                color: "#FFD063"
                                implicitHeight: 3

                                Layout.fillWidth: true
                            }

                            Volume {}

                            Item {
                                Layout.fillHeight: true
                            }

                            Rectangle {
                                color: "#FFD063"
                                implicitHeight: 3

                                Layout.fillWidth: true
                            }

                            Rectangle {
                                color: "#FFD063"
                                implicitHeight: 3

                                Layout.fillWidth: true
                            }

                            Rectangle {
                                color: "#FFD063"
                                implicitHeight: 3

                                Layout.fillWidth: true
                            }
                        }
                    }

                    Rectangle {
                        color: "#FFD063"
                        implicitHeight: 5

                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}

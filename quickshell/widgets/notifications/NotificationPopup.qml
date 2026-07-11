import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property Notification modelData

    spacing: 0
    Layout.fillWidth: true

    Rectangle {
        color: "#FFD063"
        implicitHeight: 5

        Layout.fillWidth: true
    }

    WrapperRectangle {
        Layout.fillWidth: true

        margin: 12
        border.width: 1
        border.color: "#FFD063"
        color: "#0F1012"
        opacity: .9

        ColumnLayout {
            spacing: 4

            Layout.fillWidth: true

            RowLayout {
                spacing: 8

                Layout.fillWidth: true

                IconImage {
                    visible: root.modelData.appIcon !== ""
                    source: root.modelData.appIcon
                    implicitSize: 20
                }

                Text {
                    text: root.modelData.summary
                    color: "#EEEEEE"
                    font.pointSize: 14
                    font.bold: true
                    elide: Text.ElideRight

                    Layout.fillWidth: true
                }

                Text {
                    id: dismissButton

                    text: "×"
                    color: "#FFD063"
                    font.pointSize: 18

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.modelData.dismiss()
                    }
                }
            }

            Text {
                visible: root.modelData.body !== ""
                text: root.modelData.body
                color: "#EEEEEE"
                font.pointSize: 12
                wrapMode: Text.Wrap

                Layout.fillWidth: true
            }

            RowLayout {
                visible: root.modelData.actions.length > 0
                spacing: 6

                Layout.fillWidth: true

                Repeater {
                    model: root.modelData.actions

                    Rectangle {
                        id: actionButton

                        required property NotificationAction modelData

                        color: "#292C30"
                        border.width: 1
                        border.color: "#FFD063"
                        implicitHeight: 28
                        implicitWidth: actionText.implicitWidth + 16

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: actionButton.modelData.text
                            color: "#EEEEEE"
                            font.pointSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: actionButton.modelData.invoke()
                        }
                    }
                }
            }
        }
    }
}

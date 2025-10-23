import Quickshell.Widgets
import QtQuick
import QtQuick.Shapes

import qs.widgets.decoration

TopLeftPanelShape {
    id: shape

    property alias margin: container.margin
    property alias topMargin: container.topMargin
    property alias bottomMargin: container.bottomMargin
    property alias leftMargin: container.leftMargin
    property alias rightMargin: container.rightMargin

    default property alias contents: container.data

    WrapperItem {
        id: container
        anchors.fill: parent
    }
}

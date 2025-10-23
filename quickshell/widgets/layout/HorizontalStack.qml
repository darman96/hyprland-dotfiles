import QtQuick
import QtQuick.Layouts

RowLayout {
    id: outerLayout
    default property alias content: innerLayout.data

    RowLayout {
        id: innerLayout
        spacing: outerLayout.spacing
    }

    Item {
        Layout.fillWidth: true
    }
}

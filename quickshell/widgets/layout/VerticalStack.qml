import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: outerLayout
    default property alias content: innerLayout.data

    ColumnLayout {
        id: innerLayout
        spacing: outerLayout.spacing
    }

    Item {
        Layout.fillHeight: true
    }
}

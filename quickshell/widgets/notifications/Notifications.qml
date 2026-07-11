import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    NotificationServer {
        id: server

        keepOnReload: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        actionsSupported: true
        actionIconsSupported: true

        onNotification: notification => {
            notification.tracked = true;

            const timeout = notification.expireTimeout === 0 ? 0 : notification.expireTimeout > 0 ? notification.expireTimeout : (notification.urgency === NotificationUrgency.Critical ? 0 : 5000);

            if (timeout <= 0)
                return;

            let closed = false;
            notification.closed.connect(() => {
                closed = true;
            });

            const timer = expiryTimerComponent.createObject(root, {
                interval: timeout
            });
            timer.triggered.connect(() => {
                if (!closed)
                    notification.expire();
                timer.destroy();
            });
        }
    }

    Component {
        id: expiryTimerComponent

        Timer {
            running: true
        }
    }

    PanelWindow {
        screen: Quickshell.screens.find(s => s.name === "DP-2")

        color: "transparent"

        anchors {
            top: true
            right: true
        }

        margins.top: 12
        margins.right: 12

        implicitWidth: 340
        implicitHeight: column.implicitHeight

        ColumnLayout {
            id: column
            anchors.fill: parent
            spacing: 8

            Repeater {
                model: server.trackedNotifications

                NotificationPopup {}
            }
        }
    }
}

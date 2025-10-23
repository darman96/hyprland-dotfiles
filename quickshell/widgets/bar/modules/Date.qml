import Quickshell
import QtQuick

BarWidget {
    Text {
        text: {
            Qt.formatDateTime(clock.date, "dd.\nMMM");
        }

        horizontalAlignment: Text.AlignHCenter

        font.family: "Digital-7 Mono"
        font.pointSize: 18
        color: "#EEEEEE"

        SystemClock {
            id: clock
            precision: SystemClock.Hours
        }
    }
}

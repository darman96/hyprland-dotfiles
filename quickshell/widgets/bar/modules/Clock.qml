import Quickshell
import QtQuick

BarWidget {
    Text {
        text: {
            Qt.formatDateTime(clock.date, "hh\nmm");
        }

        horizontalAlignment: Text.AlignHCenter

        font.family: "Digital-7 Mono"
        font.pointSize: 20
        font.letterSpacing: 2
        color: "#EEEEEE"

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }
    }
}

import QtQuick
import Quickshell.Io

Item {
    id: root

    property bool available: false
    property int percentage: 0
    property string state: "unknown"
    readonly property bool charging: state.toLowerCase().includes("charging")
    readonly property string icon: !available ? "󰂑" :
        charging ? "󰂄" :
        percentage >= 90 ? "󰁹" :
        percentage >= 70 ? "󰂁" :
        percentage >= 50 ? "󰁿" :
        percentage >= 30 ? "󰁽" :
        percentage >= 10 ? "󰁻" : "󰂎"
    readonly property string label: available ? `${percentage}%` : "AC"

    function refresh() {
        readBattery.exec(["bash", "-lc", "bat=$(upower -e 2>/dev/null | grep -m1 BAT || true); [ -n \"$bat\" ] && upower -i \"$bat\" || true"])
    }

    Timer {
        interval: 8000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()

    Process {
        id: readBattery

        stdout: StdioCollector {
            id: batteryOutput

            onStreamFinished: {
                const raw = batteryOutput.text
                root.available = raw.length > 0
                const pct = raw.match(/percentage:\s+(\d+)%/)
                const st = raw.match(/state:\s+([^\n]+)/)
                root.percentage = pct ? Number(pct[1]) : 0
                root.state = st ? st[1].trim() : "unknown"
            }
        }
    }
}

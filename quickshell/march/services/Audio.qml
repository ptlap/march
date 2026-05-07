import QtQuick
import Quickshell.Io

Item {
    id: root

    property int volume: 0
    property bool muted: false
    readonly property string icon: muted ? "󰝟" : (volume >= 60 ? "󰕾" : (volume > 0 ? "󰖀" : "󰕿"))
    readonly property string label: muted ? "MUT" : `${volume}%`

    function refresh() {
        readVolume.exec(["bash", "-lc", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || true"])
    }

    Timer {
        interval: 2500
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()

    Process {
        id: readVolume

        stdout: StdioCollector {
            id: volumeOutput

            onStreamFinished: {
                const raw = volumeOutput.text.trim()
                const match = raw.match(/Volume:\s+([0-9.]+)/)
                root.volume = match ? Math.round(Number(match[1]) * 100) : 0
                root.muted = raw.includes("[MUTED]")
            }
        }
    }
}

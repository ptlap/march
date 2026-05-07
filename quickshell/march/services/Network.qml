import QtQuick
import Quickshell.Io

Item {
    id: root

    property string kind: "none"
    property string name: "offline"
    property bool wifiEnabled: false
    readonly property bool connected: kind !== "none"
    readonly property string icon: kind === "wifi" ? "󰖩" : (kind === "ethernet" ? "󰈀" : (wifiEnabled ? "󰖪" : "󰖭"))
    readonly property string label: connected ? name : (wifiEnabled ? "offline" : "off")

    function refresh() {
        readNetwork.exec(["bash", "-lc", `
            printf 'wifi=%s\\n' "$(nmcli -t -f WIFI general 2>/dev/null)"
            nmcli -t -f TYPE,STATE,CONNECTION dev status 2>/dev/null
        `])
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()

    Process {
        id: readNetwork

        stdout: StdioCollector {
            id: networkOutput

            onStreamFinished: {
                const lines = networkOutput.text.trim().split(/\n+/).filter(line => line.length > 0)
                const radioLine = lines.find(line => line.startsWith("wifi=")) || "wifi=disabled"
                root.wifiEnabled = radioLine.slice(5).trim() === "enabled"

                const connectedLine = lines.find(line => {
                    const parts = line.split(":")
                    return (parts[0] === "wifi" || parts[0] === "ethernet") && parts[1] === "connected"
                })

                if (connectedLine) {
                    const parts = connectedLine.split(":")
                    root.kind = parts[0]
                    root.name = parts.slice(2).join(":") || root.kind
                } else {
                    root.kind = "none"
                    root.name = "offline"
                }
            }
        }
    }
}

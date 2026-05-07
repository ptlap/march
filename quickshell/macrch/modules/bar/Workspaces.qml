import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

RowLayout {
    id: root

    required property QtObject theme

    readonly property int activeWorkspace: Hyprland.focusedMonitor && Hyprland.focusedMonitor.activeWorkspace
        ? Hyprland.focusedMonitor.activeWorkspace.id : 1
    property var workspaceApps: ({})

    spacing: 3

    Repeater {
        model: 5

        Rectangle {
            id: button

            readonly property int workspaceId: index + 1
            readonly property bool active: workspaceId === root.activeWorkspace
            readonly property string appIcon: root.workspaceApps[workspaceId] || ""
            readonly property bool occupied: appIcon.length > 0 || Hyprland.workspaces.values.some(ws => ws.id === workspaceId)

            Layout.preferredWidth: active ? 32 : 26
            Layout.preferredHeight: 24
            radius: 12
            color: active ? root.theme.barActive : (mouse.containsMouse ? root.theme.barHover : (occupied ? "#14ffffff" : "transparent"))
            border.width: active ? 1 : (occupied ? 1 : 0)
            border.color: active ? root.theme.accent : root.theme.glassBorder
            antialiasing: true

            Text {
                anchors.centerIn: parent
                text: button.occupied && button.appIcon.length > 0 ? button.appIcon : button.workspaceId
                color: button.active ? root.theme.text : (button.occupied ? root.theme.textMuted : root.theme.textDim)
                font.family: button.occupied && button.appIcon.length > 0 ? root.theme.iconFont : root.theme.uiFont
                font.pixelSize: button.occupied && button.appIcon.length > 0 ? 13 : 11
                font.weight: button.active ? Font.DemiBold : Font.Medium
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                id: mouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`workspace ${button.workspaceId}`)
            }

            Behavior on Layout.preferredWidth {
                NumberAnimation { duration: root.theme.animationFast; easing.type: Easing.OutCubic }
            }

            Behavior on color {
                ColorAnimation { duration: root.theme.animationFast }
            }
        }
    }

    function refreshClients() {
        readClients.exec(["bash", "-lc", "hyprctl clients -j 2>/dev/null || true"])
    }

    function iconForClient(client) {
        const key = `${client.class || client.initialClass || client.title || ""}`.toLowerCase()

        if (key.includes("firefox")) return "󰈹"
        if (key.includes("chrom") || key.includes("brave") || key.includes("edge")) return "󰊯"
        if (key.includes("kitty") || key.includes("terminal") || key.includes("alacritty")) return "󰆍"
        if (key.includes("code") || key.includes("codium")) return "󰨞"
        if (key.includes("discord")) return "󰙯"
        if (key.includes("telegram")) return "󰔁"
        if (key.includes("spotify")) return "󰓇"
        if (key.includes("steam")) return "󰓓"
        if (key.includes("file") || key.includes("nautilus") || key.includes("thunar")) return "󰉋"

        return "󰣆"
    }

    Component.onCompleted: refreshClients()

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (["openwindow", "closewindow", "movewindow", "workspace", "activewindow"].includes(event.name)) {
                root.refreshClients()
            }
        }
    }

    Process {
        id: readClients

        stdout: StdioCollector {
            id: clientsOutput

            onStreamFinished: {
                const raw = clientsOutput.text.trim()
                if (!raw) {
                    root.workspaceApps = ({})
                    return
                }

                try {
                    const clients = JSON.parse(raw)
                    const next = {}
                    for (const client of clients) {
                        const workspaceId = client.workspace ? client.workspace.id : undefined
                        if (typeof workspaceId === "number" && workspaceId > 0 && workspaceId <= 5 && !next[workspaceId]) {
                            next[workspaceId] = root.iconForClient(client)
                        }
                    }
                    root.workspaceApps = next
                } catch (error) {
                    root.workspaceApps = ({})
                }
            }
        }
    }
}

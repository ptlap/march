import QtQuick
import Quickshell.Hyprland
import Quickshell.Io

Item {
    id: root

    readonly property int maxWorkspace: 10
    property var clients: []
    property var monitors: []
    property var workspaces: []
    property var clientsByAddress: ({})
    property var workspacesById: ({})
    property var activeWorkspace: ({ "id": 1 })
    property bool refreshQueued: false

    function refresh() {
        refreshQueued = false
        clientsProcess.exec(["hyprctl", "-j", "clients"])
        monitorsProcess.exec(["hyprctl", "-j", "monitors"])
        workspacesProcess.exec(["hyprctl", "-j", "workspaces"])
        activeWorkspaceProcess.exec(["hyprctl", "-j", "activeworkspace"])
    }

    function queueRefresh() {
        if (refreshQueued) return
        refreshQueued = true
        refreshTimer.restart()
    }

    function clientForAddress(address) {
        if (!address) return null
        const normalized = `${address}`.startsWith("0x") ? `${address}` : `0x${address}`
        return root.clientsByAddress[normalized] || root.clientsByAddress[normalized.toLowerCase()] || null
    }

    function clientForToplevel(toplevel) {
        if (!toplevel || !toplevel.HyprlandToplevel) return null
        return root.clientForAddress(`0x${toplevel.HyprlandToplevel.address}`)
    }

    function clientsForWorkspace(workspaceId) {
        return root.clients.filter(client => {
            const id = client.workspace ? client.workspace.id : -1
            return id === workspaceId
        })
    }

    function parseJson(text, fallback) {
        const raw = text.trim()
        if (!raw) return fallback

        try {
            return JSON.parse(raw)
        } catch (error) {
            return fallback
        }
    }

    function rebuildClientIndex() {
        const next = {}
        for (const client of root.clients) {
            if (client.address) {
                next[client.address] = client
                next[`${client.address}`.toLowerCase()] = client
            }
        }
        root.clientsByAddress = next
    }

    function rebuildWorkspaceIndex() {
        const next = {}
        for (const workspace of root.workspaces) {
            if (typeof workspace.id === "number") next[workspace.id] = workspace
        }
        root.workspacesById = next
    }

    Component.onCompleted: refresh()

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (!event || !event.name) return
            if (["openlayer", "closelayer", "screencast", "mouse"].includes(event.name)) return
            root.queueRefresh()
        }
    }

    Timer {
        id: refreshTimer

        interval: 120
        repeat: false
        onTriggered: root.refresh()
    }

    Process {
        id: clientsProcess

        stdout: StdioCollector {
            id: clientsOutput

            onStreamFinished: {
                root.clients = root.parseJson(clientsOutput.text, [])
                root.rebuildClientIndex()
            }
        }
    }

    Process {
        id: monitorsProcess

        stdout: StdioCollector {
            id: monitorsOutput

            onStreamFinished: root.monitors = root.parseJson(monitorsOutput.text, [])
        }
    }

    Process {
        id: workspacesProcess

        stdout: StdioCollector {
            id: workspacesOutput

            onStreamFinished: {
                root.workspaces = root.parseJson(workspacesOutput.text, [])
                root.rebuildWorkspaceIndex()
            }
        }
    }

    Process {
        id: activeWorkspaceProcess

        stdout: StdioCollector {
            id: activeWorkspaceOutput

            onStreamFinished: root.activeWorkspace = root.parseJson(activeWorkspaceOutput.text, ({ "id": 1 }))
        }
    }
}

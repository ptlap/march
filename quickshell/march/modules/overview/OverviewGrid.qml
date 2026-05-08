import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import "../../components" as Components

Item {
    id: root

    required property QtObject theme
    required property QtObject hyprlandData
    required property bool overviewOpen

    readonly property int maxWorkspace: 10
    readonly property var visibleWorkspaces: buildVisibleWorkspaces()
    readonly property int workspaceCount: Math.max(1, visibleWorkspaces.length)
    readonly property int rows: workspaceCount <= 3 ? 1 : 2
    readonly property int columns: Math.ceil(workspaceCount / rows)
    readonly property real cellGap: 14
    readonly property var primaryMonitor: hyprlandData.monitors.length > 0 ? hyprlandData.monitors[0] : ({ "width": 1920, "height": 1080, "reserved": [0, 44, 0, 0], "scale": 1 })
    readonly property var primaryReserved: primaryMonitor.reserved || [0, 0, 0, 0]
    readonly property real monitorUsableWidth: Math.max(1, numberOr(primaryMonitor.width, 1920) / Math.max(0.1, numberOr(primaryMonitor.scale, 1)) - numberOr(primaryReserved[0], 0) - numberOr(primaryReserved[2], 0))
    readonly property real monitorUsableHeight: Math.max(1, numberOr(primaryMonitor.height, 1080) / Math.max(0.1, numberOr(primaryMonitor.scale, 1)) - numberOr(primaryReserved[1], 0) - numberOr(primaryReserved[3], 0))
    readonly property real workspaceAspect: Math.max(1.25, Math.min(2.2, monitorUsableWidth / monitorUsableHeight))
    readonly property real availableCellWidth: (workspaceGrid.width - cellGap * (columns - 1)) / columns
    readonly property real availableCellHeight: (workspaceGrid.height - cellGap * (rows - 1)) / rows
    readonly property real cellWidth: availableCellWidth / availableCellHeight > workspaceAspect
        ? availableCellHeight * workspaceAspect
        : availableCellWidth
    readonly property real cellHeight: cellWidth / workspaceAspect
    readonly property real actualGridWidth: columns * cellWidth + Math.max(0, columns - 1) * cellGap
    readonly property real actualGridHeight: rows * cellHeight + Math.max(0, rows - 1) * cellGap
    readonly property real gridOffsetX: Math.max(0, (workspaceGrid.width - actualGridWidth) / 2)
    readonly property real gridOffsetY: Math.max(0, (workspaceGrid.height - actualGridHeight) / 2)
    readonly property int activeWorkspace: hyprlandData.activeWorkspace && hyprlandData.activeWorkspace.id
        ? Math.max(1, Math.min(maxWorkspace, hyprlandData.activeWorkspace.id)) : 1

    property int draggingFromWorkspace: -1
    property int draggingTargetWorkspace: -1

    signal closeRequested()

    function numberOr(value, fallback) {
        return typeof value === "number" && isFinite(value) ? value : fallback
    }

    function buildVisibleWorkspaces() {
        const ids = new Set()
        const active = Math.max(1, Math.min(root.maxWorkspace, root.activeWorkspace))

        ids.add(active)

        for (const client of root.hyprlandData.clients) {
            const id = client.workspace ? client.workspace.id : -1
            if (id >= 1 && id <= root.maxWorkspace) ids.add(id)
        }

        for (const workspace of root.hyprlandData.workspaces) {
            if (workspace.id >= 1 && workspace.id <= root.maxWorkspace && workspace.windows > 0) {
                ids.add(workspace.id)
            }
        }

        ids.add(Math.max(1, active - 1))
        ids.add(Math.min(root.maxWorkspace, active + 1))

        return Array.from(ids).sort((a, b) => a - b).slice(0, root.maxWorkspace)
    }

    function workspaceVisualIndex(workspaceId) {
        const index = root.visibleWorkspaces.indexOf(workspaceId)
        return index >= 0 ? index : 0
    }

    function workspaceClients(workspaceId) {
        return root.hyprlandData.clientsForWorkspace(workspaceId)
    }

    function clientWorkspaceIndex(client) {
        if (!client || !client.workspace) return 0

        const clients = root.workspaceClients(client.workspace.id)
        for (let i = 0; i < clients.length; i++) {
            if (clients[i].address === client.address) return i
        }

        return 0
    }

    function monitorForClient(client) {
        if (!client) return root.hyprlandData.monitors.length > 0 ? root.hyprlandData.monitors[0] : ({})

        for (const monitor of root.hyprlandData.monitors) {
            if (monitor.id === client.monitor || monitor.name === client.monitor) return monitor
        }

        return root.hyprlandData.monitors.length > 0 ? root.hyprlandData.monitors[0] : ({})
    }

    function visibleToplevels() {
        return ToplevelManager.toplevels.values.filter(toplevel => {
            const client = root.hyprlandData.clientForToplevel(toplevel)
            const id = client && client.workspace ? client.workspace.id : -1
            return id >= 1 && id <= root.maxWorkspace
        })
    }

    Components.GlassIsland {
        anchors.fill: parent
        theme: root.theme
        color: root.theme.glassBg
        border.color: root.theme.glassBorder
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 10
        }
        spacing: 0

        Item {
            id: workspaceGrid

            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: root.visibleWorkspaces

                Rectangle {
                    id: workspaceCell

                    readonly property int workspaceId: modelData
                    readonly property int row: Math.floor(index / root.columns)
                    readonly property int column: index % root.columns
                    readonly property bool active: workspaceId === root.activeWorkspace
                    readonly property bool target: root.draggingTargetWorkspace === workspaceId
                    readonly property var clients: root.workspaceClients(workspaceId)

                    x: root.gridOffsetX + column * (root.cellWidth + root.cellGap)
                    y: root.gridOffsetY + row * (root.cellHeight + root.cellGap)
                    width: root.cellWidth
                    height: root.cellHeight
                    radius: 18
                    color: target ? root.theme.barActive : (active ? "#228aadf4" : "#14ffffff")
                    border.width: active || target ? 2 : 1
                    border.color: target ? root.theme.accent : (active ? root.theme.accent2 : root.theme.glassBorder)
                    antialiasing: true

                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            leftMargin: 14
                            rightMargin: 14
                            topMargin: 1
                        }
                        height: 1
                        radius: 1
                        color: root.theme.glassHighlight
                        opacity: workspaceCell.active || workspaceCell.target ? 0.55 : 0.28
                    }

                    Text {
                        anchors {
                            left: parent.left
                            top: parent.top
                            leftMargin: 12
                            topMargin: 8
                        }
                        text: workspaceCell.workspaceId
                        color: workspaceCell.active ? root.theme.text : root.theme.textMuted
                        font.family: root.theme.uiFont
                        font.pixelSize: 17
                        font.weight: Font.DemiBold
                        opacity: workspaceCell.clients.length > 0 ? 0.55 : 0.42
                        z: 8
                    }

                    Rectangle {
                        anchors {
                            right: parent.right
                            top: parent.top
                            rightMargin: 10
                            topMargin: 10
                        }
                        width: 7
                        height: 7
                        radius: 4
                        visible: workspaceCell.active
                        color: root.theme.accent
                        z: 8
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: workspaceCell.clients.length === 0
                        text: workspaceCell.workspaceId
                        color: root.theme.textDim
                        font.family: root.theme.uiFont
                        font.pixelSize: 42
                        font.weight: Font.DemiBold
                        opacity: 0.16
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton
                        onClicked: {
                            if (root.draggingFromWorkspace !== -1) return
                            Hyprland.dispatch(`workspace ${workspaceCell.workspaceId}`)
                            root.closeRequested()
                        }
                    }

                    DropArea {
                        anchors.fill: parent

                        onEntered: root.draggingTargetWorkspace = workspaceCell.workspaceId
                        onExited: {
                            if (root.draggingTargetWorkspace === workspaceCell.workspaceId) {
                                root.draggingTargetWorkspace = -1
                            }
                        }
                    }

                    Behavior on color {
                        ColorAnimation { duration: 140 }
                    }

                    Behavior on border.color {
                        ColorAnimation { duration: 140 }
                    }
                }
            }

            Repeater {
                model: root.visibleToplevels()

                OverviewWindow {
                    id: windowItem

                    required property var modelData

                    toplevel: modelData
                    client: root.hyprlandData.clientForToplevel(modelData)
                    theme: root.theme
                    cellWidth: root.cellWidth
                    cellHeight: root.cellHeight
                    cellGap: root.cellGap
                    columns: root.columns
                    workspaceIndex: root.workspaceVisualIndex(windowItem.workspaceId)
                    gridOffsetX: root.gridOffsetX
                    gridOffsetY: root.gridOffsetY
                    monitorData: root.monitorForClient(windowItem.client)
                    overviewOpen: root.overviewOpen
                    z: dragArea.drag.active ? 20 : 4

                    Drag.active: dragArea.drag.active
                    Drag.source: windowItem
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2

                    MouseArea {
                        id: dragArea

                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                        drag.target: parent
                        cursorShape: Qt.PointingHandCursor

                        onEntered: windowItem.hovered = true
                        onExited: windowItem.hovered = false
                        onPressed: mouse => {
                            const workspaceId = windowItem.workspaceId
                            root.draggingFromWorkspace = workspaceId
                            root.draggingTargetWorkspace = workspaceId
                            windowItem.pressed = true
                        }

                        onReleased: mouse => {
                            const targetWorkspace = root.draggingTargetWorkspace
                            const sourceWorkspace = windowItem.workspaceId
                            root.draggingFromWorkspace = -1
                            root.draggingTargetWorkspace = -1
                            windowItem.pressed = false

                            if (targetWorkspace > 0 && targetWorkspace !== sourceWorkspace) {
                                Hyprland.dispatch(`movetoworkspacesilent ${targetWorkspace}, address:${windowItem.client.address}`)
                                root.hyprlandData.refresh()
                            } else {
                                windowItem.resetPosition()
                            }
                        }

                        onClicked: mouse => {
                            if (mouse.button === Qt.MiddleButton) {
                                Hyprland.dispatch(`closewindow address:${windowItem.client.address}`)
                                root.closeRequested()
                                return
                            }

                            Hyprland.dispatch(`focuswindow address:${windowItem.client.address}`)
                            root.closeRequested()
                        }
                    }
                }
            }
        }
    }
}

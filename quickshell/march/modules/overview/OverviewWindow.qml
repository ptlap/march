import QtQuick
import Quickshell
import Quickshell.Wayland

Rectangle {
    id: root

    required property var toplevel
    required property var client
    required property QtObject theme
    required property real cellWidth
    required property real cellHeight
    required property real cellGap
    required property int columns
    required property int workspaceIndex
    required property real gridOffsetX
    required property real gridOffsetY
    required property var monitorData
    required property bool overviewOpen

    readonly property int workspaceId: client.workspace ? client.workspace.id : 1
    readonly property int workspaceRow: Math.floor(workspaceIndex / columns)
    readonly property int workspaceColumn: workspaceIndex % columns
    readonly property real workspaceX: gridOffsetX + workspaceColumn * (cellWidth + cellGap)
    readonly property real workspaceY: gridOffsetY + workspaceRow * (cellHeight + cellGap)
    readonly property real topInset: 0
    readonly property real sideInset: 0
    readonly property real previewWidth: Math.max(1, cellWidth - sideInset * 2)
    readonly property real previewHeight: Math.max(1, cellHeight - topInset - sideInset)
    readonly property real monitorX: numberOr(monitorData.x, 0)
    readonly property real monitorY: numberOr(monitorData.y, 0)
    readonly property real monitorWidth: Math.max(1, numberOr(monitorData.width, 1920) / Math.max(0.1, numberOr(monitorData.scale, 1)))
    readonly property real monitorHeight: Math.max(1, numberOr(monitorData.height, 1080) / Math.max(0.1, numberOr(monitorData.scale, 1)))
    readonly property var reserved: monitorData.reserved || [0, 0, 0, 0]
    readonly property real usableX: monitorX + numberOr(reserved[0], 0)
    readonly property real usableY: monitorY + numberOr(reserved[1], 0)
    readonly property real usableWidth: Math.max(1, monitorWidth - numberOr(reserved[0], 0) - numberOr(reserved[2], 0))
    readonly property real usableHeight: Math.max(1, monitorHeight - numberOr(reserved[1], 0) - numberOr(reserved[3], 0))
    readonly property real clientX: client.at && client.at.length > 0 ? client.at[0] : usableX
    readonly property real clientY: client.at && client.at.length > 1 ? client.at[1] : usableY
    readonly property real clientWidth: client.size && client.size.length > 0 ? client.size[0] : usableWidth
    readonly property real clientHeight: client.size && client.size.length > 1 ? client.size[1] : usableHeight
    readonly property string windowClass: client.class || client.initialClass || ""
    readonly property string windowTitle: client.title || windowClass || "Window"
    property bool hovered: false
    property bool pressed: false

    width: Math.max(88, Math.min(previewWidth, clientWidth / usableWidth * previewWidth))
    height: Math.max(54, Math.min(previewHeight, clientHeight / usableHeight * previewHeight))
    x: workspaceX + sideInset + Math.max(0, Math.min(previewWidth - width, (clientX - usableX) / usableWidth * previewWidth))
    y: workspaceY + topInset + Math.max(0, Math.min(previewHeight - height, (clientY - usableY) / usableHeight * previewHeight))
    radius: 12
    color: "#00000000"
    border.width: 1
    border.color: pressed ? theme.accent : (hovered ? theme.glassHighlight : theme.glassBorder)
    antialiasing: true
    clip: true
    opacity: overviewOpen ? 1 : 0
    scale: pressed ? 0.985 : (hovered ? 1.018 : 1)

    function resetPosition() {
        root.x = Qt.binding(() => root.workspaceX + root.sideInset + Math.max(0, Math.min(root.previewWidth - root.width, (root.clientX - root.usableX) / root.usableWidth * root.previewWidth)))
        root.y = Qt.binding(() => root.workspaceY + root.topInset + Math.max(0, Math.min(root.previewHeight - root.height, (root.clientY - root.usableY) / root.usableHeight * root.previewHeight)))
    }

    function numberOr(value, fallback) {
        return typeof value === "number" && isFinite(value) ? value : fallback
    }

    Rectangle {
        anchors {
            fill: parent
        }
        radius: parent.radius - 1
        color: "#2011141c"
    }

    ScreencopyView {
        id: preview
        anchors.fill: parent
        captureSource: root.overviewOpen ? root.toplevel : null
        live: true
    }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: root.pressed ? "#428aadf4" : (root.hovered ? "#22ffffff" : "#12000000")
        border.width: 1
        border.color: root.border.color
    }

    Image {
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: Math.max(5, Math.min(10, parent.width * 0.04))
            topMargin: Math.max(5, Math.min(10, parent.height * 0.04))
        }
        width: Math.max(18, Math.min(34, Math.min(root.width, root.height) * 0.18))
        height: width
        source: Quickshell.iconPath(root.iconName(root.windowClass), "application-x-executable")
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Behavior on y { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }
    Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
    Behavior on border.color { ColorAnimation { duration: 120 } }

    function iconName(appClass) {
        const key = `${appClass || ""}`.toLowerCase()
        if (key.includes("firefox")) return "firefox"
        if (key.includes("chrom")) return "google-chrome"
        if (key.includes("brave")) return "brave-browser"
        if (key.includes("kitty")) return "kitty"
        if (key.includes("code")) return "code"
        if (key.includes("discord")) return "discord"
        if (key.includes("telegram")) return "telegram"
        if (key.includes("spotify")) return "spotify"
        if (key.includes("steam")) return "steam"
        if (key.includes("dolphin")) return "org.kde.dolphin"
        return appClass || "application-x-executable"
    }
}

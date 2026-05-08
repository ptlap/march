import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root

    required property QtObject theme

    implicitWidth: 40
    implicitHeight: 24

    property bool loading: false

    Process {
        id: wallpaperMenu

        command: ["bash", "-lc", "~/macrch/scripts/wallpaper.sh --wallpaper-menu"]
        running: false
        onExited: {
            running = false
            root.loading = false
            loadingTimeout.stop()
        }
    }

    Timer {
        id: loadingTimeout

        interval: 8000
        repeat: false
        onTriggered: root.loading = false
    }

    Rectangle {
        id: hitbox

        anchors.fill: parent
        radius: 12
        color: mouse.containsMouse ? root.theme.barHover : "transparent"
        border.width: mouse.containsMouse ? 1 : 0
        border.color: root.theme.glassBorder
        antialiasing: true

        RowLayout {
            anchors.centerIn: parent
            spacing: 4

            Text {
                text: root.loading ? "..." : "󰸉"
                color: root.loading ? root.theme.accent2 : root.theme.accent
                font.family: root.theme.iconFont
                font.pixelSize: root.loading ? 9 : 14
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                Layout.preferredWidth: 5
                Layout.preferredHeight: 5
                radius: 3
                color: root.theme.accent3
                opacity: root.loading ? 1 : 0.85

                SequentialAnimation on opacity {
                    running: root.loading
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.35; to: 1.0; duration: 350 }
                    NumberAnimation { from: 1.0; to: 0.35; duration: 350 }
                }
            }
        }

        Behavior on color {
            ColorAnimation { duration: root.theme.animationFast }
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!wallpaperMenu.running) {
                root.loading = true
                loadingTimeout.restart()
                wallpaperMenu.running = true
            }
        }
    }
}

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root

    required property QtObject theme
    required property QtObject hyprlandData

    property bool open: false
    property bool superReleaseMightTrigger: true

    PanelWindow {
        id: panel

        visible: root.open
        color: "transparent"
        exclusiveZone: 0
        WlrLayershell.namespace: "quickshell:march:overview"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: root.open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Item {
            anchors.fill: parent
            focus: root.open

            Rectangle {
                anchors.fill: parent
                color: "#6405070d"

                Rectangle {
                    anchors.fill: parent
                    opacity: 0.26
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#2e8aadf4" }
                        GradientStop { position: 0.45; color: "#120b0d12" }
                        GradientStop { position: 1; color: "#3a000000" }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.open = false
                }
            }

            OverviewGrid {
                id: grid

                anchors.centerIn: parent
                width: Math.min(parent.width - 40, 1540)
                height: Math.min(parent.height - 72, 900)
                theme: root.theme
                hyprlandData: root.hyprlandData
                overviewOpen: root.open
                opacity: root.open ? 1 : 0
                scale: root.open ? 1 : 0.965

                onCloseRequested: root.open = false

                Behavior on opacity {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }

                Behavior on scale {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }
            }

            Keys.onEscapePressed: root.open = false
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Left) {
                    Hyprland.dispatch("workspace r-1")
                    event.accepted = true
                } else if (event.key === Qt.Key_Right) {
                    Hyprland.dispatch("workspace r+1")
                    event.accepted = true
                }
            }
        }
    }

    IpcHandler {
        target: "overview"

        function toggle(): void {
            root.open = !root.open
        }

        function open(): void {
            root.open = true
        }

        function close(): void {
            root.open = false
        }
    }

    GlobalShortcut {
        name: "marchOverviewToggleRelease"
        description: "Toggle march overview when Super is released"

        onPressed: root.superReleaseMightTrigger = true
        onReleased: {
            if (!root.superReleaseMightTrigger) return
            root.open = !root.open
        }
    }

    GlobalShortcut {
        name: "marchOverviewInterrupt"
        description: "Cancel march overview Super release"

        onPressed: root.superReleaseMightTrigger = false
    }
}

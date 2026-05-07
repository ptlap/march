import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "../../components" as Components

Item {
    id: root

    required property QtObject theme
    required property QtObject audio
    required property QtObject battery
    required property QtObject network

    readonly property var activeToplevel: ToplevelManager.activeToplevel
    readonly property int activeWorkspace: Hyprland.focusedMonitor && Hyprland.focusedMonitor.activeWorkspace
        ? Hyprland.focusedMonitor.activeWorkspace.id : 1
    readonly property string activeTitle: activeToplevel && activeToplevel.title
        ? activeToplevel.title : `Workspace ${activeWorkspace}`

    RowLayout {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 6
            leftMargin: 10
            rightMargin: 10
        }
        height: root.theme.barHeight
        spacing: 10

        Components.GlassIsland {
            Layout.preferredHeight: root.theme.barHeight
            Layout.preferredWidth: Math.min(560, Math.max(360, leftContent.implicitWidth + 22))
            theme: root.theme

            RowLayout {
                id: leftContent

                anchors {
                    fill: parent
                    leftMargin: 10
                    rightMargin: 12
                }
                spacing: 8

                Text {
                    text: "󰣇"
                    color: root.theme.accent
                    font.family: root.theme.iconFont
                    font.pixelSize: 17
                    verticalAlignment: Text.AlignVCenter
                    Layout.preferredWidth: 20
                    Layout.alignment: Qt.AlignVCenter
                }

                Workspaces {
                    theme: root.theme
                    Layout.preferredHeight: 26
                    Layout.alignment: Qt.AlignVCenter
                }

                Rectangle {
                    Layout.preferredWidth: 1
                    Layout.preferredHeight: 16
                    radius: 1
                    color: root.theme.glassBorder
                    opacity: 0.8
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: root.activeTitle
                    color: root.theme.textMuted
                    font.family: root.theme.uiFont
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    Layout.fillWidth: true
                    Layout.maximumWidth: 230
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Components.GlassIsland {
            Layout.preferredHeight: root.theme.barHeight
            Layout.preferredWidth: 150
            theme: root.theme

            Clock {
                anchors.centerIn: parent
                theme: root.theme
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Components.GlassIsland {
            Layout.preferredHeight: root.theme.barHeight
            Layout.preferredWidth: Math.max(250, rightContent.implicitWidth + 24)
            theme: root.theme

            RowLayout {
                id: rightContent

                anchors {
                    fill: parent
                    leftMargin: 12
                    rightMargin: 12
                }
                spacing: 10

                Components.StatusPill {
                    theme: root.theme
                    icon: root.network.icon
                    label: root.network.label
                    Layout.alignment: Qt.AlignVCenter
                }

                Components.StatusPill {
                    theme: root.theme
                    icon: root.audio.icon
                    label: root.audio.label
                    Layout.alignment: Qt.AlignVCenter
                }

                Components.StatusPill {
                    theme: root.theme
                    icon: root.battery.icon
                    label: root.battery.label
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }
}

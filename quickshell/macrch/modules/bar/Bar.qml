import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    required property QtObject theme
    required property QtObject audio
    required property QtObject battery
    required property QtObject network

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: barWindow

            required property ShellScreen modelData

            screen: modelData
            color: "transparent"
            implicitHeight: root.theme.barWindowHeight
            exclusiveZone: root.theme.barWindowHeight
            exclusionMode: ExclusionMode.Normal
            WlrLayershell.namespace: "quickshell:macrch:bar"
            WlrLayershell.layer: WlrLayer.Top

            anchors {
                top: true
                left: true
                right: true
            }

            BarContent {
                anchors.fill: parent
                theme: root.theme
                audio: root.audio
                battery: root.battery
                network: root.network
            }
        }
    }
}

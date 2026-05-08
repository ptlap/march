import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    required property QtObject theme
    required property QtObject wallpaper

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: backgroundWindow

            required property ShellScreen modelData

            screen: modelData
            color: root.theme.bg
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "quickshell:march:background"
            WlrLayershell.layer: WlrLayer.Bottom

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                color: root.theme.bg
            }

            Image {
                anchors.fill: parent
                source: root.wallpaper.url
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: false
                smooth: true
                visible: source.toString().length > 0 && status === Image.Ready
            }

            Rectangle {
                anchors.fill: parent
                color: "#330B0D12"
                visible: root.wallpaper.url.length > 0
            }
        }
    }
}

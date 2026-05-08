import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    readonly property string generatedThemePath: `${Quickshell.env("HOME")}/macrch/themes/generated/march-colors.json`
    property var generated: ({})

    function color(name, fallback) {
        return root.generated && root.generated[name] ? root.generated[name] : fallback
    }

    readonly property string bg: color("bg", "#0B0D12")
    readonly property string bgSoft: color("bgSoft", "#11141B")
    readonly property string surface: color("surface", "#85181b24")
    readonly property string surfaceStrong: color("surfaceStrong", "#ad1e222d")

    readonly property string glassBg: color("glassBg", "#7512151c")
    readonly property string glassBorder: color("glassBorder", "#24ffffff")
    readonly property string glassHighlight: color("glassHighlight", "#38ffffff")
    readonly property string glassShadow: color("glassShadow", "#59000000")

    readonly property string text: color("text", "#F2F4F8")
    readonly property string textMuted: color("textMuted", "#A8B0C0")
    readonly property string textDim: color("textDim", "#6F7787")

    readonly property string accent: color("accent", "#8AADF4")
    readonly property string accent2: color("accent2", "#C6A0F6")
    readonly property string accent3: color("accent3", "#91D7E3")

    readonly property string success: color("success", "#A6DA95")
    readonly property string warning: color("warning", "#EED49F")
    readonly property string error: color("error", "#ED8796")

    readonly property string barBg: color("barBg", "#9411141c")
    readonly property string barBorder: color("barBorder", "#21ffffff")
    readonly property string barActive: color("barActive", "#388aadf4")
    readonly property string barHover: color("barHover", "#1affffff")

    readonly property string uiFont: "Inter"
    readonly property string fallbackFont: "Noto Sans"
    readonly property string monoFont: "JetBrainsMono Nerd Font"
    readonly property string iconFont: "Symbols Nerd Font"

    readonly property int barHeight: 32
    readonly property int barWindowHeight: 44
    readonly property int radius: 16
    readonly property int animationFast: 140

    Component.onCompleted: generatedTheme.reload()

    FileView {
        id: generatedTheme

        path: root.generatedThemePath
        watchChanges: true
        onFileChanged: generatedTheme.reload()
        onLoaded: {
            try {
                root.generated = JSON.parse(generatedTheme.text())
            } catch (error) {
                root.generated = ({})
            }
        }
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) {
                root.generated = ({})
            }
        }
    }
}

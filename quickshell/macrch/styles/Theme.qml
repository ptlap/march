import QtQuick

QtObject {
    readonly property string bg: "#0B0D12"
    readonly property string bgSoft: "#11141B"
    readonly property string surface: "#85181b24"
    readonly property string surfaceStrong: "#ad1e222d"

    readonly property string glassBg: "#7512151c"
    readonly property string glassBorder: "#24ffffff"
    readonly property string glassHighlight: "#38ffffff"
    readonly property string glassShadow: "#59000000"

    readonly property string text: "#F2F4F8"
    readonly property string textMuted: "#A8B0C0"
    readonly property string textDim: "#6F7787"

    readonly property string accent: "#8AADF4"
    readonly property string accent2: "#C6A0F6"
    readonly property string accent3: "#91D7E3"

    readonly property string success: "#A6DA95"
    readonly property string warning: "#EED49F"
    readonly property string error: "#ED8796"

    readonly property string barBg: "#9411141c"
    readonly property string barBorder: "#21ffffff"
    readonly property string barActive: "#388aadf4"
    readonly property string barHover: "#1affffff"

    readonly property string uiFont: "Inter"
    readonly property string fallbackFont: "Noto Sans"
    readonly property string monoFont: "JetBrainsMono Nerd Font"
    readonly property string iconFont: "Symbols Nerd Font"

    readonly property int barHeight: 32
    readonly property int barWindowHeight: 44
    readonly property int radius: 16
    readonly property int animationFast: 140
}

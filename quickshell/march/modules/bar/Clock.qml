import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    required property QtObject theme

    property date now: new Date()

    spacing: 8

    Text {
        text: Qt.formatDateTime(root.now, "ddd")
        color: root.theme.textMuted
        font.family: root.theme.uiFont
        font.pixelSize: 12
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        text: Qt.formatDateTime(root.now, "HH:mm")
        color: root.theme.text
        font.family: root.theme.uiFont
        font.pixelSize: 13
        font.weight: Font.DemiBold
        verticalAlignment: Text.AlignVCenter
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }
}

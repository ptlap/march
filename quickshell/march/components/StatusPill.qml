import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    required property QtObject theme
    property string icon: ""
    property string label: ""

    spacing: 5
    implicitHeight: 22

    Text {
        text: root.icon
        color: root.theme.accent3
        font.family: root.theme.iconFont
        font.pixelSize: 13
        verticalAlignment: Text.AlignVCenter
        Layout.alignment: Qt.AlignVCenter
    }

    Text {
        text: root.label
        color: root.theme.textMuted
        font.family: root.theme.uiFont
        font.pixelSize: 11
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        Layout.maximumWidth: 88
        Layout.alignment: Qt.AlignVCenter
    }
}

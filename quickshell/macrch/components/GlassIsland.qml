import QtQuick

Rectangle {
    id: root

    required property QtObject theme

    radius: theme.radius
    color: theme.barBg
    border.width: 1
    border.color: theme.barBorder
    antialiasing: true

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: 12
            rightMargin: 12
            topMargin: 1
        }
        height: 1
        radius: 1
        color: root.theme.glassHighlight
        opacity: 0.45
    }
}

import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    readonly property string statePath: `${Quickshell.env("HOME")}/macrch/state/current-wallpaper`
    property string path: ""
    readonly property string url: path.length > 0 ? Qt.resolvedUrl(path) : ""

    function reload() {
        currentWallpaperFile.reload()
    }

    Component.onCompleted: root.reload()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.reload()
    }

    FileView {
        id: currentWallpaperFile

        path: root.statePath
        watchChanges: true
        onFileChanged: root.reload()
        onLoaded: {
            root.path = currentWallpaperFile.text().trim()
        }
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) {
                root.path = ""
            }
        }
    }
}

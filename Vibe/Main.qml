import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import "./" as Local

ApplicationWindow {
    id: window
    visible: true
    width: 1000
    height: 800
    title: "Vibe Media Player"
    color: "#121212"

    Actions {
        id: actions
    }

    AboutDialog {
        id: aboutDialog
    }

    Connections {
        target: actions.open
        function onTriggered() { fileDialog.open() }
    }

    Connections {
        target: actions.about
        function onTriggered() { aboutDialog.open() }
    }

    Local.Content {
        id: content
    }

    FileDialog {
        id: fileDialog
        title: "打开媒体文件"
        nameFilters: [
            "媒体文件 (*.mp4 *.mkv *.avi *.mov *.wmv *.flv *.webm *.mp3 *.wav *.flac *.aac *.ogg *.m4a *.wma)",
            "所有文件 (*)"
        ]
        onAccepted: content.player.source = selectedFile
    }

    DisplayArea {
        anchors.fill: parent
        mediaPlayer: content.player
        audioOutput: content.audioOutput
        window: window
        fileName: content.fileName
        actions: actions
    }
}
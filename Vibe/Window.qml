
//// This is the application's main window应用主窗口
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtMultimedia



ApplicationWindow {
    id: window
    visible: true
    width: 1000
    height: 800


    title: Qt.application.name.length > 0 ? Qt.application.name : qsTr("Vibe Media Player")
    color: "#000000"

    readonly property bool isFullscreen: visibility === Window.FullScreen

    function toggleFullscreen() {
        visibility = isFullscreen ? Window.Windowed : Window.FullScreen
    }

    Actions {
        id: actions
    }

    Dialogs {
        id: dialogs
    }

    header: TopMenuBar {
        actions: actions
        currentTitle: content.fileName
    }

    Connections {
        target: actions.open
        function onTriggered() { dialogs.fileOpen.open() }
    }

    Connections {
        target: actions.newAction
        function onTriggered() { appController.openNewWindow() }
    }

    Connections {
        target: actions.quit
        function onTriggered() { appController.quitApplication() }
    }

    Connections {
        target: actions.about
        function onTriggered() { dialogs.about.open() }
    }

    Shortcut {
        sequence: "Escape"
        enabled: window.isFullscreen
        onActivated: window.visibility = Window.Windowed
    }

    Connections {
        target: dialogs
        function onMediaFileAccepted(selectedFile) { appController.openMediaFile(selectedFile) }
    }

    Rectangle {
        anchors.fill: parent

        color: "#000000"
        border.color: window.isFullscreen ? "transparent" : "#ffffff"
        border.width: window.isFullscreen ? 0 : 1

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: window.isFullscreen ? 0 : 8 * 1.5
            anchors.rightMargin: window.isFullscreen ? 0 : 8 * 1.5
            anchors.topMargin: window.isFullscreen ? 0 : 10 * 1.5
            anchors.bottomMargin: window.isFullscreen ? 0 : 10 * 1.5
            spacing: 0

            Content {
                id: content
                anchors.fill: parent
                // Layout.fillWidth: true
                // Layout.fillHeight: true
                player: playerController
                window: window
            }

        }
    }
}

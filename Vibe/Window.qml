import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import "musicplayer.js" as Controller

ApplicationWindow {
    id: window
    width: 1000
    height: 800
    visible: true
    title: "Vibe Media Player"
    color: "#121212"

    menuBar: MenuBar {
        palette.window: "#1a1a1a"
        palette.windowText: "#ffffff"
        palette.button: "#1a1a1a"
        palette.buttonText: "#ffffff"
        palette.highlight: "#404040"
        palette.highlightedText: "#ffffff"

        background: Rectangle {
            color: "#1a1a1a"
        }

        Menu {
            title: qsTr("文件(&F)")
            MenuItem { action: actions.open }
            MenuItem { action: actions.newAction }
            MenuItem { action: actions.quit }
        }
        Menu {
            title: qsTr("帮助(&H)")
            MenuItem { action: actions.about }
        }
    }

    header: ToolBar {
        palette.window: "#1a1a1a"
        palette.windowText: "#ffffff"

        background: Rectangle {
            color: "#1a1a1a"
        }

        RowLayout {
            ToolButton {
                action: actions.open
            }
            ToolButton {
                action: actions.newAction
            }
            ToolButton {
                action: actions.quit
            }
        }
    }

    Actions {
        id: actions
        open.onTriggered: Controller.open()
        about.onTriggered: content.dialogs.about.open()
    }

    Content {
        id: content
        anchors.fill: parent
    }

    Component.onCompleted: {
        Controller.initial();
    }
}
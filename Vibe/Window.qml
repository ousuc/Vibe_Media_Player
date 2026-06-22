import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
import QtMultimedia
import "./" as Local

ApplicationWindow {
    id: window
    visible: true
    width: 1000
    height: 800
    title: "Vibe Media Player"
    color: "#000000"

    readonly property bool isFullscreen: visibility === Window.FullScreen

    function toggleFullscreen() {
        visibility = isFullscreen ? Window.Windowed : Window.FullScreen
    }

    Shortcut {
        sequence: "Escape"
        enabled: window.isFullscreen
        onActivated: window.visibility = Window.Windowed
    }

    // 使用本地 shim（真实逻辑由 C++ 提供）
    Local.PlayerController {
        id: playerController
    }

    FileDialog {
        id: openMediaDialog
        title: "选择一个媒体文件"
        nameFilters: ["媒体文件 (*.mp4 *.mkv *.avi *.mov *.wmv *.mp3 *.wav *.flac)", "所有文件 (*)"]
        onAccepted: {
            playerController.probeFile(selectedFile)
            playerController.loadFile(selectedFile)
            playerController.play()
        }
    }

    // 播放器主体背景
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        border.color: window.isFullscreen ? "transparent" : "#ffffff"
        border.width: window.isFullscreen ? 0 : 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: window.isFullscreen ? 0 : 16
            spacing: 0

            TopTitleBar {
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                visible: !window.isFullscreen
                currentTitle: playerController.currentFileName === "" ? "视频播放" : playerController.currentFileName
                onOpenFileRequested: openMediaDialog.open()
                onNewWindowRequested: playerController.openNewWindow()
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#000000"
                border.color: window.isFullscreen ? "transparent" : "#ffffff"
                border.width: window.isFullscreen ? 0 : 1

                VideoOutput {
                    id: videoOutput
                    anchors.fill: parent
                    fillMode: VideoOutput.PreserveAspectFit
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onDoubleClicked: window.toggleFullscreen()
                }

                Component.onCompleted: playerController.setVideoOutput(videoOutput)
            }

            BottomControlBar {
                Layout.fillWidth: true
                spacing: 20
                visible: !window.isFullscreen
                player: playerController
                window: window
            }

            Label {
                Layout.fillWidth: true
                visible: !window.isFullscreen
                color: "#d0d0d0"
                elide: Label.ElideRight
                text: playerController.lastError === ""
                      ? (playerController.mediaInfoJson === "" ? "FFmpeg 解析结果：等待文件..." : "FFmpeg 解析结果已更新（JSON 长度: " + playerController.mediaInfoJson.length + "）")
                      : ("FFmpeg 解析失败: " + playerController.lastError)
            }
        }
    }
}

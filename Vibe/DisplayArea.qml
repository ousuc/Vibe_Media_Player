import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtMultimedia 5.15

Rectangle {
    id: root

    required property MediaPlayer mediaPlayer
    property var audioOutput
    property var window

    property string fileName: "未打开文件"
    property Actions actions: null
    signal openFile()

    color: "#000000"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopMenuBar {
            Layout.preferredHeight: 30
            Layout.fillWidth: true
            actions: root.actions
            currentTitle: root.fileName
            onOpenFileRequested: root.openFile()
        }

        Rectangle {
            id: videoArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#1a1a1a"

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectFit
                visible: root.mediaPlayer.hasVideo

                Component.onCompleted: root.mediaPlayer.videoOutput = videoOutput

                Component.onDestruction: {
                    if (root.mediaPlayer.videoOutput === videoOutput)
                        root.mediaPlayer.videoOutput = null
                }
            }

            Label {
                anchors.centerIn: parent
                visible: !root.mediaPlayer.hasVideo
                       && root.mediaPlayer.source.toString() !== ""
                       && root.mediaPlayer.playbackState !== MediaPlayer.StoppedState
                text: "🎵 正在播放音频"
                color: "#FFFFFF"
                font.pixelSize: 24
            }

            Label {
                anchors.centerIn: parent
                visible: root.mediaPlayer.source.toString() === ""
                text: "请打开媒体文件"
                color: "#888888"
                font.pixelSize: 18
            }

            MouseArea {
                id: playAreaMouse
                anchors.fill: parent
                z: 1
                hoverEnabled: true
                enabled: root.mediaPlayer.source.toString() !== ""
                onClicked: {
                    if (root.mediaPlayer.playbackState === MediaPlayer.PlayingState)
                        root.mediaPlayer.pause()
                    else
                        root.mediaPlayer.play()
                }
            }

            Item {
                anchors.centerIn: parent
                visible: playAreaMouse.containsMouse
                width: 72
                height: 72

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: "#80000000"
                }

                Text {
                    anchors.centerIn: parent
                    text: root.mediaPlayer.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
                    color: "white"
                    font.pixelSize: 36
                }
            }
        }

        BottomControlBar {
            Layout.fillWidth: true
            mediaPlayer: root.mediaPlayer
            audioOutput: root.audioOutput
            window: root.window
        }
    }
}
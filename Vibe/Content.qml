import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root
    anchors.fill: parent

    required property var player
    required property var window

    readonly property string fileName: root.player.currentFileName === ""
                                     ? qsTr("未选择音视频文件")
                                     : qsTr("正在播放：") + root.player.currentFileName

    Component.onCompleted: Qt.callLater(function() { videoArea.forceActiveFocus() })

    Rectangle {

        anchors.fill: parent
        color: "black"

        ColumnLayout {
            anchors.fill: parent

            spacing: 6

            Rectangle {
                id: videoArea
                Layout.fillWidth: true
                Layout.fillHeight: true

                color: "#363636"
                border.width: 0
                radius: 4
                clip: true
                focus: true

                VideoOutput {
                    id: videoOutput
                    anchors.fill: parent
                    anchors.margins: 0
                    fillMode: VideoOutput.PreserveAspectFit
                }

                // MouseArea {
                //     anchors.fill: parent
                //     acceptedButtons: Qt.LeftButton
                //     onDoubleClicked: root.window.toggleFullscreen()
                // }
                // 删除MouseArea
                TapHandler {
                    onDoubleTapped: root.window.toggleFullscreen()
                }

                Component.onCompleted: root.player.setVideoOutput(videoOutput)
            }

            BottomControlBar {
                Layout.fillWidth: true
                spacing: 10
                visible: !root.window.isFullscreen
                player: root.player
                window: root.window
            }

            // 删除无意义的Json解析
            // Label {
            //     Layout.fillWidth: true
            //     visible: !root.window.isFullscreen
            //     color: "#d0d0d0"
            //     elide: Text.ElideMiddle
            //     text: root.player.lastError === ""
            //           ? (root.player.mediaInfoJson === ""
            //              ? qsTr("FFmpeg 解析结果：等待文件...")
            //              : qsTr("FFmpeg 解析结果已更新（JSON 长度: %1）").arg(root.player.mediaInfoJson.length))
            //           : qsTr("FFmpeg 解析失败: %1").arg(root.player.lastError)
            // }
        }
    }
}

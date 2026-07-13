//组件：音量控制条

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtMultimedia 5.15


Item {
    id: volumeSlider

    required property var player

    // 这个对应的是按钮的大小按钮，可以做个绑定
    implicitWidth:  36
    implicitHeight:  34

    Slider {
        id: vSlider

        width: 36  // 和按钮的大小一致，可以做个绑定
        height: 150

        orientation: Qt.Vertical

        anchors.bottom: root.top
        anchors.horizontalCenter: root.horizontalCenter

        z: 100

        from: 0
        to: 100

        value: player ? player.volume : 0

        onValueChanged: {
            if (player)
                player.volume = value
        }
    }

    ColumnLayout {
        id: root

        property var player: volumeSlider.player

        // // 新增紧凑模式：嵌入底部单行控制栏时使用
        // property bool compact: false
        // 删除紧凑模式
        property real savedVolume: 70


        spacing: 8

        Connections {
            target: player

            function onVolumeChanged() {
                // 强制 UI 刷新（避免某些 backend 不触发 binding）
                volumeButton.text = (player && player.volume > 0) ? "🔉" : "🔇"
            }
        }

        //音量按钮
        Button {
            id: volumeButton

            // implicitWidth: 36
            // implicitHeight: 32

            padding: 8
            palette.buttonText: "#FFFFFF"

            text: (player && player.volume > 0) ? "🔉" : "🔇"

            contentItem: Text {
                text: volumeButton.text
                color: "#FFFFFF"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                radius: 4
                color: volumeButton.down ? "#55FFFFFF"
                                         : (volumeButton.hovered ? "#30FFFFFF" : "#20FFFFFF")
                border.color: volumeButton.hovered || volumeButton.down ? "#90FFFFFF" : "#45FFFFFF"
                border.width: 1
            }

            // onClicked: {
            //     // 更改单击逻辑为显示隐藏Slider
            //     vSlider.visible = !vSlider.visible
            // }

            TapHandler {
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onTapped:(eventPoint, button) => {
                    if (button === Qt.RightButton) {
                        if (player && typeof player.volume !== "undefined") {
                            if (player.volume > 0) {
                                root.savedVolume = player.volume
                                player.volume = 0
                            } else {
                                player.volume = root.savedVolume > 0 ? root.savedVolume : 70
                            }
                        }

                    } else {
                        vSlider.visible = !vSlider.visible
                    }
                }

                // onDoubleTapped: {
                //     if (player && typeof player.volume !== "undefined") {
                //         if (player.volume > 0) {
                //             root.savedVolume = player.volume
                //             player.volume = 0
                //         } else {
                //             player.volume = root.savedVolume > 0 ? root.savedVolume : 70
                //         }
                //     }
                // }
            }
        }

        // 删除紧凑模式逻辑
        // // 紧凑模式下隐藏百分比文字，节省横向空间
        // Label {
        //     visible: !root.compact
        //     text: player && typeof player.volume !== 'undefined' ? Math.round(player.volume) + "%" : "0%"
        //     color: "white"
        //     font.family: "monospace"
        //     font.pixelSize: 12
        //     Layout.preferredWidth: 40
        //     horizontalAlignment: Text.AlignHCenter
        // }

        // 填充物
        Item {
            Layout.fillWidth: true

            Rectangle {
                anchors.fill: parent   // 让矩形充满整个 Item
            }
        }
    }

    //
    Component.onCompleted: {
        // 加载完成隐藏Slider的显示
        vSlider.visible = false
    }
}
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1000
    height: 800
    title: "Vibe Media Player"
    color: "#121212"

    // 播放器主体背景
    Rectangle {
        anchors.fill: parent
        anchors.margins: 0
        color: "#5E4B75"
        border.color: "#ffffff"
        border.width: 1
        // 整体布局
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 0

            // 顶部标题栏
            RowLayout {
                Layout.preferredHeight: 50
                Layout.fillWidth: true

                //todo  将这个提升到垂直区域，并且设置为工具栏，内部包含文件打开功能
                Button {
                    text: "<"
                    background: Rectangle { color: "transparent" }
                }

                // todo 将这个标签删除， 或者将这个标签显示为当前文件名字
                Label {
                    Layout.fillWidth: true
                    text: "视频播放"
                    color: "white"
                    horizontalAlignment: Qt.AlignHCenter
                }
                // 提供相应的功能接口，可以预留用作装饰
                Button {
                    text: "⋮"
                    background: Rectangle { color: "transparent" }
                }
            }

            // // 分割线
            // Rectangle {
            //     Layout.fillWidth: true
            //     Layout.preferredHeight: 1
            //     color: "#ffffff"
            // }

            // 视频显示区域
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#000000"
                border.color: "#ffffff"
                border.width: 1

                // 意义不明可以删除
                Label {
                    anchors.centerIn: parent
                    text: "视频播放区域"
                    color: "#666666"
                }
            }

            // // 分割线
            // Rectangle {
            //     Layout.fillWidth: true
            //     Layout.preferredHeight: 1
            //     color: "#ffffff"
            // }

            // 底部控制栏
            ColumnLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 90
                spacing: 12
                anchors.margins: 8

                // 播放控制行
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    // 播放功能
                    Button {
                        text: "▶"
                        background: Rectangle { color: "transparent" }
                    }

                    // 设置当前播放进度， 可以删除，因为滑动条更加直观
                    Label {
                        text: "00:00"
                        color: "white"
                    }

                    // 设置当前播放进度对应上的滑动条，和上方的label可能需要做关联
                    Slider {
                        Layout.fillWidth: true
                        value: 0.3
                    }

                    // 显示当前播放进度
                    Label {
                        text: "04:20"
                        color: "white"
                    }

                    // 这个是全屏按钮功能，提供 点击事件 需要优化全屏功能
                    Button {
                        text: "⛶"
                        background: Rectangle { color: "transparent" }
                        onClicked: {
                               // 切换全屏 / 退出全屏
                               if (visibility === Window.FullScreen) {
                                   visibility = Window.Windowed;  // 退出全屏
                               } else {
                                   visibility = Window.FullScreen; // 进入全屏
                               }
                        }
                    }
                }

                // 音量控制行
                //   组成是 ： 按钮，滑动条，以及一个普通的Item用作填充物
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Button {
                        text: "🔊"
                        background: Rectangle { color: "transparent" }
                    }

                    Slider {
                        Layout.preferredWidth: 200
                        value: 0.7
                    }

                    Item {
                        Layout.fillWidth: true
                        Rectangle {
                                anchors.fill: parent   // 让矩形充满整个 Item
                                color: "red"
                        }
                    }
                }
            }
        }
    }
}

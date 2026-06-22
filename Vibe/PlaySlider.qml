import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
RowLayout {
    property var player
    property var window

    // 播放功能
    Button {
        text: player && player.isPlaying ? "⏸" : "▶"
        background: Rectangle { color: "transparent" }
        onClicked: {
            if (player) {
                player.playPause()
            }
        }
    }

    // 设置当前播放进度， 可以删除，因为滑动条更加直观
    Label {
        text: player ? player.positionString : "00:00"
        color: "white"
    }

    // 设置当前播放进度对应上的滑动条，和上方的label可能需要做关联
    Slider {
        Layout.fillWidth: true
        from: 0
        to: 100
        value: player ? player.positionPercent : 0
        onMoved: {
            if (player) {
                player.positionPercent = Math.round(value)
            }
        }
    }

    // 显示当前播放进度
    Label {
        text: player ? player.durationString : "00:00"
        color: "white"
    }

    Button {
        text: "-10s"
        background: Rectangle { color: "transparent" }
        onClicked: if (player) player.rewind(10000)
    }

    Button {
        text: "+10s"
        background: Rectangle { color: "transparent" }
        onClicked: if (player) player.fastForward(10000)
    }

    Button {
        text: "⛶"
        background: Rectangle { color: "transparent" }
        onClicked: {
            if (window && typeof window.toggleFullscreen === "function")
                window.toggleFullscreen()
            else if (window)
                window.visibility = window.visibility === Window.FullScreen ? Window.Windowed : Window.FullScreen
        }
    }
}

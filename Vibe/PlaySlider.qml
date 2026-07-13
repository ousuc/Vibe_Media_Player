
//组件：播放控制条
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    property var player
    property var window

    component ControlButton: Button {
        implicitWidth: Math.max(contentItem.implicitWidth + leftPadding + rightPadding, 36)
        implicitHeight: 32
        padding: 8
        palette.buttonText: "#FFFFFF"

        contentItem: Text {
            text: parent.text
            font: parent.font
            color: "#FFFFFF"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            radius: 4
            color: parent.down ? "#55FFFFFF"
                               : (parent.hovered ? "#30FFFFFF" : "#20FFFFFF")
            border.color: parent.hovered || parent.down ? "#90FFFFFF" : "#45FFFFFF"
            border.width: 1
        }
    }

    ControlButton {
        text: player && player.isPlaying ? "⏸" : "▶"
        onClicked: {
            if (player)
                player.playPause()
        }
    }

    Label {
        text: player ? player.positionString : "00:00"
        color: "white"
    }

    Slider {
        Layout.fillWidth: true
        from: 0
        to: 100
        value: player ? player.positionPercent : 0
        onMoved: {
            if (player)
                player.positionPercent = Math.round(value)
        }
    }

    Label {
        text: player ? player.durationString : "00:00"
        color: "white"
    }

    ControlButton {
        text: "-10s"
        onClicked: if (player) player.rewind(10000)
    }

    ControlButton {
        text: "+10s"
        onClicked: if (player) player.fastForward(10000)
    }

    ControlButton {
        text: "⛶"
        onClicked: {
            if (window && typeof window.toggleFullscreen === "function")
                window.toggleFullscreen()
            else if (window)
                window.visibility = window.visibility === Window.FullScreen
                                    ? Window.Windowed : Window.FullScreen
        }
    }
}

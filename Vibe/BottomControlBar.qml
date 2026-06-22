import QtQuick.Controls 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtMultimedia 5.15


// 底部控制栏BcakControlBar
ColumnLayout {
    // 支持两种模式：传入 controller (`player`) 或直接传入 `mediaPlayer`
    property var player
    property var mediaPlayer
    property var audioOutput
    property var window
    spacing: 8

    // 简单的 shim：当没有 `player` 时，用 mediaPlayer 封装出 controller-like 接口
    // 关于shim的概念，参考doc中的terms文档
    // 这里用于填补逻辑
    QtObject {
        id: playerShim
        property var mediaPlayerRef: mediaPlayer
        function formatTime(ms) {
            if (!ms || ms <= 0) return "00:00"
            var total = Math.floor(ms / 1000)
            var m = Math.floor(total / 60)
            var s = total % 60
            return (m<10?"0":"") + m + ":" + (s<10?"0":"") + s
        }
        property bool isPlaying: mediaPlayerRef ? (mediaPlayerRef.playbackState === MediaPlayer.PlayingState) : false
        function playPause() { if (!mediaPlayerRef) return; if (mediaPlayerRef.playbackState === MediaPlayer.PlayingState) mediaPlayerRef.pause(); else mediaPlayerRef.play(); }
        property int positionPercent: mediaPlayerRef && mediaPlayerRef.duration ? Math.round(mediaPlayerRef.position * 100 / mediaPlayerRef.duration) : 0
        function setPositionPercent(pct) { if (mediaPlayerRef && mediaPlayerRef.duration) mediaPlayerRef.setPosition(Math.round(mediaPlayerRef.duration * pct / 100)) }
        property string positionString: mediaPlayerRef ? formatTime(mediaPlayerRef.position) : "00:00"
        property string durationString: mediaPlayerRef ? formatTime(mediaPlayerRef.duration) : "00:00"
        function rewind(ms) { if (mediaPlayerRef) mediaPlayerRef.setPosition(Math.max(0, mediaPlayerRef.position - ms)) }
        function fastForward(ms) { if (mediaPlayerRef) mediaPlayerRef.setPosition(mediaPlayerRef.position + ms) }
        function stop() { if (mediaPlayerRef) mediaPlayerRef.stop() }
    }

    PlaySlider {
        player: parent.player ? parent.player : playerShim
        window: parent.window
    }
    // 音量控制行  should be extraceted as a document
    VolumeSlider {
        player: parent.player ? parent.player : playerShim
        audioOutput: parent.audioOutput
    }
}
/*
// 【修改】底部控制栏：由双行 ColumnLayout 合并为单行 RowLayout
RowLayout {
    id: root

    required property MediaPlayer mediaPlayer
    required property AudioOutput audioOutput
    required property Window window

    spacing: 0

    PlaySlider {
        Layout.fillWidth: true
        mediaPlayer: root.mediaPlayer
        audioOutput: root.audioOutput
        window: root.window
    }
}*/

//TopTitleBar

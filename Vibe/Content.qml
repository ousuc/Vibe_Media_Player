import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia

Item {
    id: content
    anchors.fill: parent

    property alias dialogs: _dialogs
    property alias player: _player
    property alias songMetaData: _metaData

    TextField {
        id: _metaData
        property url songUrl
        visible: false
        TapHandler {
            onTapped: {
                _player.play()
            }
        }
    }

    Dialogs {
        id: _dialogs
        fileOpen.onRejected: {
            return;
        }
        fileOpen {
            onAccepted: {
                let filePath = _dialogs.fileOpen.selectedFile;
                _player.source = filePath;
                _metaData.songUrl = filePath;
                console.log("Media path: ", _metaData.songUrl)
            }
        }
    }

    Player {
        id: _player
        onMediaStatusChanged: {
            if (_player.mediaStatus === MediaPlayer.LoadedMedia) {
                console.log("Media loaded successfully")
                _metaData.text = _player.metaData.value("Title")
            } else if (_player.mediaStatus === MediaPlayer.InvalidMedia) {
                console.log("Failed to load media:", _player.errorString)
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Label {
            text: _metaData.text || (_player.source.toString() ? _player.source.toString().split("/").pop() : "请打开媒体文件")
            color: "#FFFFFF"
            font.pixelSize: 18
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            padding: 10
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
                visible: _player.hasVideo

                Component.onCompleted: _player.videoOutput = videoOutput

                Component.onDestruction: {
                    if (_player.videoOutput === videoOutput)
                        _player.videoOutput = null
                }
            }

            Label {
                anchors.centerIn: parent
                visible: !_player.hasVideo && _player.source.toString() !== "" && _player.playbackState !== MediaPlayer.StoppedState
                text: "🎵 正在播放音频"
                color: "#FFFFFF"
                font.pixelSize: 24
            }

            Label {
                anchors.centerIn: parent
                visible: _player.source.toString() === ""
                text: "请打开媒体文件"
                color: "#888888"
                font.pixelSize: 18
            }

            MouseArea {
                id: playAreaMouse
                anchors.fill: parent
                z: 1
                hoverEnabled: true
                enabled: _player.source.toString() !== ""
                onClicked: {
                    if (_player.playbackState === MediaPlayer.PlayingState)
                        _player.pause()
                    else
                        _player.play()
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
                    text: _player.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
                    color: "white"
                    font.pixelSize: 36
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                spacing: 8
                Layout.margins: 10

                Button {
                    text: _player.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
                    onClicked: {
                        if (_player.playbackState === MediaPlayer.PlayingState)
                            _player.pause()
                        else
                            _player.play()
                    }
                    background: Rectangle {
                        color: "#333333"
                        radius: 4
                    }
                    contentItem: Text {
                        color: "#FFFFFF"
                        text: parent.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    text: formatTime(_player.position)
                    color: "#FFFFFF"
                    font.pixelSize: 14
                }

                Slider {
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: _player.duration > 0 ? (_player.position * 100) / _player.duration : 0
                    onMoved: {
                        if (_player.duration > 0)
                            _player.position = (value * _player.duration) / 100
                    }
                }

                Label {
                    text: formatTime(_player.duration)
                    color: "#FFFFFF"
                    font.pixelSize: 14
                }

                Button {
                    text: "-10s"
                    onClicked: _player.position = Math.max(0, _player.position - 10000)
                    background: Rectangle {
                        color: "#333333"
                        radius: 4
                    }
                    contentItem: Text {
                        color: "#FFFFFF"
                        text: parent.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    text: "+10s"
                    onClicked: _player.position = Math.min(_player.duration, _player.position + 10000)
                    background: Rectangle {
                        color: "#333333"
                        radius: 4
                    }
                    contentItem: Text {
                        color: "#FFFFFF"
                        text: parent.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            RowLayout {
                spacing: 8
                Layout.margins: 10

                Slider {
                    Layout.preferredWidth: 200
                    from: 0
                    to: 100
                    value: _player.audioOutput ? _player.audioOutput.volume * 100 : 70
                    onMoved: {
                        if (_player.audioOutput)
                            _player.audioOutput.volume = value / 100
                    }
                }

                Button {
                    text: _player.audioOutput && _player.audioOutput.volume > 0 ? "🔉" : "🔇"
                    onClicked: {
                        if (_player.audioOutput) {
                            if (_player.audioOutput.volume > 0)
                                _player.audioOutput.volume = 0
                            else
                                _player.audioOutput.volume = 0.7
                        }
                    }
                    background: Rectangle {
                        color: "#333333"
                        radius: 4
                    }
                    contentItem: Text {
                        color: "#FFFFFF"
                        text: parent.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    text: _player.audioOutput ? Math.round(_player.audioOutput.volume * 100) + "%" : "70%"
                    color: "#FFFFFF"
                    font.pixelSize: 14
                }
            }
        }
    }

    function formatTime(ms) {
        if (!ms || ms <= 0) return "00:00"
        var total = Math.floor(ms / 1000)
        var m = Math.floor(total / 60)
        var s = total % 60
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s
    }
}
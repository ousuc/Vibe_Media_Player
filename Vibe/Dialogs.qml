import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

Item {
    property alias fileOpen: _fileOpen
    property alias fileSave: _fileSave
    property alias failToSave: _failToSave
    property alias about: _about

    FileDialog {
        id: _fileOpen
        title: "打开媒体文件"
        currentFolder: StandardPaths.standardLocations
                       (StandardPaths.DocumentsLocation)[0]
        fileMode: FileDialog.OpenFile
        nameFilters: [
            "媒体文件 (*.mp4 *.mkv *.avi *.mov *.wmv *.flv *.webm *.mp3 *.wav *.flac *.aac *.ogg *.m4a *.wma)",
            "所有文件 (*)"
        ]
    }

    FileDialog {
        id: _fileSave
        title: "保存文件"
        modality: Qt.ApplicationModal
        currentFolder: StandardPaths.writableLocation
                       (StandardPaths.DocumentsLocation)
        fileMode: FileDialog.SaveFile
        nameFilters: [
            "媒体文件 (*.mp4 *.mkv *.avi *.mov *.wmv *.flv *.webm *.mp3 *.wav *.flac *.aac *.ogg *.m4a *.wma)",
            "所有文件 (*)"
        ]
    }

    MessageDialog {
        id: _failToSave
        modality: Qt.WindowModal
        buttons: MessageDialog.Ok
        text: "保存失败！"
    }

    Dialog {
        id: _about
        modal: true
        focus: true
        padding: 20
        standardButtons: Dialog.Ok
        title: qsTr("关于 %1").arg(appName)

        readonly property string appName: Qt.application.name.length > 0
                                          ? Qt.application.name
                                          : "Vibe Media Player"

        onAccepted: close()
        onRejected: close()

        contentItem: ColumnLayout {
            spacing: 14
            implicitWidth: 400

            RowLayout {
                spacing: 16
                Layout.fillWidth: true

                Rectangle {
                    width: 64
                    height: 64
                    radius: 8
                    color: "#333333"
                    Layout.alignment: Qt.AlignTop

                    Canvas {
                        anchors.fill: parent
                        anchors.margins: 8

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()

                            ctx.fillStyle = "#FF5722"
                            ctx.beginPath()
                            ctx.arc(width / 2, height / 2, Math.min(width, height) / 2, 0, 2 * Math.PI)
                            ctx.fill()

                            ctx.fillStyle = "#FFFFFF"
                            ctx.beginPath()
                            ctx.moveTo(width * 0.35, height * 0.25)
                            ctx.lineTo(width * 0.35, height * 0.75)
                            ctx.lineTo(width * 0.75, height * 0.5)
                            ctx.closePath()
                            ctx.fill()
                        }
                    }
                }

                ColumnLayout {
                    spacing: 6
                    Layout.fillWidth: true

                    Label {
                        text: _about.appName
                        font.bold: true
                        font.pixelSize: 18
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Label {
                        text: qsTr("版本 %1").arg(
                                  Qt.application.version.length > 0
                                  ? Qt.application.version
                                  : "0.1")
                        opacity: 0.85
                    }

                    Label {
                        text: qsTr("基于 Qt 开发的轻量级音视频播放器。")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        opacity: 0.85
                    }
                }
            }

            Label {
                text: qsTr("支持多种常见音视频格式，提供流畅的播放体验。")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                opacity: 0.75
                font.pixelSize: 12
            }

            Label {
                text: qsTr("Created By 张迅福、林健华、吴永超")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                opacity: 0.65
                font.pixelSize: 11
            }

            Label {
                text: qsTr("基于 GNU Lesser General Public License v2.1 许可发布。")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                opacity: 0.65
                font.pixelSize: 11
            }
        }
    }
}
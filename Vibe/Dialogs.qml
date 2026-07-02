import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    id: root

    signal mediaFileAccepted(var selectedFile)

    property alias fileOpen: _fileOpen
    property alias about: _about

    FileDialog {
        id: _fileOpen
        title: qsTr("打开媒体文件")
        nameFilters: [
            qsTr("媒体文件 (*.mp4 *.mkv *.avi *.mov *.wmv *.mp3 *.wav *.flac *.aac *.ogg *.m4a *.wma)"),
            qsTr("所有文件 (*)")
        ]

        onAccepted: root.mediaFileAccepted(selectedFile)
    }

    AboutDialog {
        implicitWidth: 400
        id: _about
    }
}

//该文件汇集了所有的aciton
import QtQuick.Controls
import QtQuick


Item {
    id: root

    property alias open: _open
    property alias newAction: _new
    property alias quit: _quit
    property alias about: _about

    readonly property bool isLinux: Qt.platform.os === "linux"

    Action {
        id: _open
        text: qsTr("打开(&O)...")
        icon.name: "document-open"
        shortcut: StandardKey.Open
    }

    Action {
        id: _new
        text: qsTr("新建窗口(&N)")
        icon.name: "window-new"
        shortcut: "Ctrl+N"
    }

    Action {
        id: _quit
        text: root.isLinux ? qsTr("退出(&Q)") : qsTr("退出(&X)")
        shortcut: StandardKey.Quit
        icon.name: "application-exit"
    }

    Action {
        id: _about
        text: qsTr("关于 %1(&A)").arg(Qt.application.name.length > 0
                                    ? Qt.application.name
                                    : "Vibe Media Player")
        icon.name: "help-about"
    }

}

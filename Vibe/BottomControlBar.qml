

// 组件：底部控制栏BcakControlBar

import QtQuick.Controls 2.15
import QtQuick 2.15
import QtQuick.Layouts
import QtMultimedia





RowLayout {
    required property var player
    property var window
    spacing: 12

    PlaySlider {
        player: parent.player
        window: parent.window
    }

    VolumeSlider {
        player: parent.player
    }

}


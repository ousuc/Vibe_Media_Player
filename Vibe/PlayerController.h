#ifndef PLAYERCONTROLLER_H
#define PLAYERCONTROLLER_H

#include <QObject>
#include <QtQuick>
#include <QString>
// 定义核心类： 音视频播放控制器
class PlayerController : public QObject{
        Q_OBJECT
        QML_ELEMENT
        // 是否正在播放
        Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY playingChanged)
        // 持续时间 ms
        Q_PROPERTY(int duration READ duration)
        // 持续时间 字符串 mm:ss
        Q_PROPERTY(QString durationString READ durationString)
        // 当前文件名字
        Q_PROPERTY(QString currentFileName READ currentFileName NOTIFY mediaLoaded)
        // 媒体文件是否加载
        Q_PROPERTY(bool isMediaLoaded READ isMediaLoaded NOTIFY mediaLoaded)
        // 当前位置(时间) ms
        Q_PROPERTY(int position READ position NOTIFY positionChanged)
        // 位置字符串(时间) mm:ss
        Q_PROPERTY(QString postionString READ positionString NOTIFY positionChanged)
        // 位置百分比
        Q_PROPERTY(int positionPercent READ positionPercent NOTIFY positionChanged)
        // 音量
        Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
public:
protected:
private:
};



#endif // PLAYERCONTROLLER_H

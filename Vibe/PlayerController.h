#ifndef PLAYERCONTROLLER_H
#define PLAYERCONTROLLER_H


#include <QtQml>
class QObject;
class QString;
class QUrl;
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
        Q_PROPERTY(int position READ position WRITE setPosition NOTIFY positionChanged)
        // 位置字符串(时间) mm:ss
        Q_PROPERTY(QString postionString READ positionString  NOTIFY positionChanged)
        // 位置百分比
        Q_PROPERTY(int positionPercent READ positionPercent WRITE setPositionPercent NOTIFY positionChanged)
        // 音量
        Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
signals:
        // 属性信号， 给QML用。
        void playingChanged();
        void mediaLoaded();
        void positionChanged();
        void volumeChanged();
public:
        // 构造函数
        PlayerController(QObject *parent);
        // 属性读取接口
        bool isPlaying();
        int duration();
        QString durationString();
        QString currentFileName();
        bool isMediaLoaded();
        int position();
        QString positionString();
        int positionPercent();
        int volume();
        // 属性设置接口
        //    设置音量
        void setVolume(int volume);
        //    跳转到指定位置
        void setPosition(int position);
        //    设置位置百分比,百分比跳转
        void setPositionPercent(int positionPercent);

        // 音视频播放主要接口
        //    加载音频文件
        void loadFile(QUrl url);
        //    播放
        void play();
        //    暂停
        void pause();
        //    停止
        void stop();
        //    播放暂停
        void playpause();

protected:
private:
};



#endif // PLAYERCONTROLLER_H

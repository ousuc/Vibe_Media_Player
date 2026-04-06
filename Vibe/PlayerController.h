#pragma once


#include <QtQml>
#include <QMediaPlayer>//用到了 Qt 元对象系统（Q_OBJECT 宏），必须看到完整类定义，前置声明不够
class QAudioOutput;
class QObject;
class QString;
class QUrl;
// 定义核心类： 音视频播放控制器
class PlayerController : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    // 是否正在播放
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY playingChanged)
    // 持续时间 ms
    Q_PROPERTY(int duration READ duration NOTIFY durationChanged) // 虽然文档写 undefined，但必须有通知，否则QML无法刷新
    // 持续时间 字符串 mm:ss
    Q_PROPERTY(QString durationString READ durationString NOTIFY durationChanged)
    // 当前文件名字
    Q_PROPERTY(QString currentFileName READ currentFileName NOTIFY mediaLoaded)
    // 媒体文件是否加载
    Q_PROPERTY(bool isMediaLoaded READ isMediaLoaded NOTIFY mediaLoaded)
    // 当前位置(时间) ms
    Q_PROPERTY(int position READ position WRITE setPosition NOTIFY positionChanged)
    // 位置字符串(时间) mm:ss
    Q_PROPERTY(QString positionString READ positionString NOTIFY positionChanged)
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
    void durationChanged(); // 补充的信号
public:
    // 构造函数
    explicit PlayerController(QObject *parent = nullptr);
    // 属性读取接口
    bool isPlaying() const;
    int duration() const;
    QString durationString() const;
    QString currentFileName() const;
    bool isMediaLoaded() const;
    int position() const;
    QString positionString() const;
    int positionPercent() const;
    int volume() const;
    // 属性设置接口
    //    设置音量
    Q_INVOKABLE void setVolume(int vol);
    //    跳转到指定位置
    Q_INVOKABLE void setPosition(int ms);
    //    设置位置百分比,百分比跳转
    Q_INVOKABLE void setPositionPercent(int pct);
    // 音视频播放主要接口
    //    加载音频文件
    Q_INVOKABLE void loadFile(const QUrl &url);
    //    播放
    Q_INVOKABLE void play();
    //    暂停
    Q_INVOKABLE void pause();
    //    停止
    Q_INVOKABLE void stop();
    //    播放暂停
    Q_INVOKABLE void playPause();

    // 【新增】提供给 QML，用来接收前端的视频画布
    Q_INVOKABLE void setVideoOutput(QObject *output);


private slots:
    // 处理 QMediaPlayer 内部状态改变的槽函数
    void onPlaybackStateChanged(QMediaPlayer::PlaybackState state);
    void onPositionChanged(qint64 position);
    void onDurationChanged(qint64 duration);

private:
    // 内部工具函数：将毫秒转换为 mm:ss 格式
    QString formatTime(int ms) const;

    // 核心多媒体组件
    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;

    // 内部状态保存
    bool m_isMediaLoaded;
    QString m_currentFileName;
};

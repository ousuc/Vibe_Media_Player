#pragma once

#include <QObject>
#include <QQmlEngine>     // 提供 QML_ELEMENT 宏
#include <QMediaPlayer>   // 核心播放器类
#include <QAudioOutput>   // 音频输出类
#include <QUrl>

class PlayerController : public QObject
{
    Q_OBJECT
    QML_ELEMENT // 使得 QML 前端可以直接引用此类

    // === UML表中定义的属性 (Properties) ===
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY playingChanged)
    Q_PROPERTY(int duration READ duration NOTIFY durationChanged) // 虽然文档写 undefined，但必须有通知，否则QML无法刷新
    Q_PROPERTY(QString durationString READ durationString NOTIFY durationChanged)
    Q_PROPERTY(QString currentFileName READ currentFileName NOTIFY mediaLoaded)
    Q_PROPERTY(bool isMediaLoaded READ isMediaLoaded NOTIFY mediaLoaded)
    Q_PROPERTY(int position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(QString positionString READ positionString NOTIFY positionChanged)
    Q_PROPERTY(int positionPercent READ positionPercent WRITE setPositionPercent NOTIFY positionChanged)
    Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)

public:
    explicit PlayerController(QObject *parent = nullptr);

    // --- 属性的 Getter 方法 ---
    bool isPlaying() const;
    int duration() const;
    QString durationString() const;
    QString currentFileName() const;
    bool isMediaLoaded() const;
    int position() const;
    QString positionString() const;
    int positionPercent() const;
    int volume() const;

    // === UML表中定义的方法 (Q_INVOKABLE) ===
    Q_INVOKABLE void loadFile(const QUrl &url);
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void playPause();
    Q_INVOKABLE void setPosition(int ms);
    Q_INVOKABLE void setPositionPercent(int pct);
    Q_INVOKABLE void setVolume(int vol);

signals:
    // === UML表中定义的更新信号 ===
    void playingChanged();
    void durationChanged(); // 补充的信号
    void mediaLoaded();
    void positionChanged();
    void volumeChanged();

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

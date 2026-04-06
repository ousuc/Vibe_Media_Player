#include "playercontroller.h"
#include <QFileInfo>
#include <QAudioOutput>
#include <QObject>
#include <QString>
#include <QUrl>
// 构造函数
PlayerController::PlayerController(QObject *parent)
    : QObject{parent}
    , m_player(new QMediaPlayer(this))
    , m_audioOutput(new QAudioOutput(this))
    , m_isMediaLoaded(false)
{
    // 将音频输出组件绑定到播放器
    m_player->setAudioOutput(m_audioOutput);
    // 默认音量设置 (Qt6 中音量是 0.0 到 1.0 的浮点数)
    m_audioOutput->setVolume(0.5f); // 对应 UML 中的 50

    // 连接 QMediaPlayer 的原生信号到我们的自定义处理槽
    connect(m_player, &QMediaPlayer::playbackStateChanged, this, &PlayerController::onPlaybackStateChanged);
    connect(m_player, &QMediaPlayer::positionChanged, this, &PlayerController::onPositionChanged);
    connect(m_player, &QMediaPlayer::durationChanged, this, &PlayerController::onDurationChanged);
}

// ==========================================
// Q_PROPERTY 读接口
// ==========================================
bool PlayerController::isPlaying() const {
    return m_player->playbackState() == QMediaPlayer::PlayingState;
}

int PlayerController::duration() const {
    return m_player->duration();
}

QString PlayerController::durationString() const {
    return formatTime(m_player->duration());
}

QString PlayerController::currentFileName() const {
    return m_currentFileName;
}

bool PlayerController::isMediaLoaded() const {
    return m_isMediaLoaded;
}

int PlayerController::position() const {
    return m_player->position();
}

QString PlayerController::positionString() const {
    return formatTime(m_player->position());
}

int PlayerController::positionPercent() const {
    int dur = m_player->duration();
    if (dur <= 0) return 0;
    return (m_player->position() * 100) / dur;
}

int PlayerController::volume() const {
    // 将 0.0 - 1.0 的浮点数转换为 0 - 100 的整数
    return qRound(m_audioOutput->volume() * 100);
}

// ==========================================
// Q_INVOKABLE 方法实现 (供 QML 调用)
// ==========================================
void PlayerController::loadFile(const QUrl &url) {
    if (url.isEmpty()) return;

    m_player->setSource(url);

    // 更新当前文件名
    m_currentFileName = url.fileName();
    if (m_currentFileName.isEmpty()) {
        m_currentFileName = "未知文件";
    }

    m_isMediaLoaded = true;

    // 发送媒体已加载信号，QML 绑定的文件名和布尔值会自动更新
    emit mediaLoaded();
}

void PlayerController::play() {
    if (m_isMediaLoaded) m_player->play();
}

void PlayerController::pause() {
    m_player->pause();
}

void PlayerController::stop() {
    m_player->stop();
}

void PlayerController::playPause() {
    if (isPlaying()) {
        pause();
    } else {
        play();
    }
}

void PlayerController::setPosition(int ms) {
    m_player->setPosition(ms);
    // positionChanged 信号会由 m_player 的原生信号触发
}

void PlayerController::setPositionPercent(int pct) {
    int dur = m_player->duration();
    if (dur > 0) {
        // 百分比计算转换回毫秒
        int targetMs = (pct * dur) / 100;
        m_player->setPosition(targetMs);
    }
}

void PlayerController::setVolume(int vol) {
    // 限制范围在 0-100
    vol = qBound(0, vol, 100);
    // 转换为 0.0-1.0 发送给底层
    m_audioOutput->setVolume(vol / 100.0f);
    emit volumeChanged();
}

void PlayerController::setVideoOutput(QObject *output) {
    // 直接把前端传进来的 VideoOutput 交给底层的 QMediaPlayer
    m_player->setVideoOutput(output);
}

// ==========================================
// 私有槽函数与辅助工具
// ==========================================
void PlayerController::onPlaybackStateChanged(QMediaPlayer::PlaybackState state) {
    Q_UNUSED(state);
    emit playingChanged(); // 通知 isPlaying 改变
}

void PlayerController::onPositionChanged(qint64 position) {
    Q_UNUSED(position);
    // 通知 position, positionString, positionPercent 改变
    emit positionChanged();
}

void PlayerController::onDurationChanged(qint64 duration) {
    Q_UNUSED(duration);
    // 通知 duration, durationString 改变
    emit durationChanged();
}

// 将毫秒转换为 mm:ss
QString PlayerController::formatTime(int ms) const {
    if (ms <= 0) return "00:00";

    int seconds = ms / 1000;
    int minutes = seconds / 60;
    seconds = seconds % 60;

    // 使用 QString::asprintf 或者 .arg 补齐两位数 (例如 05:09)
    return QString("%1:%2")
        .arg(minutes, 2, 10, QChar('0'))
        .arg(seconds, 2, 10, QChar('0'));
}
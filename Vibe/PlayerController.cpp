#include "PlayerController.h"
#include <QString>
#include <QObject>
#include <QUrl>
// 构造函数
PlayerController::PlayerController(QObject *parent)
        : QObject(parent)
{
}

// -----------------------------------------------------------------------------
// Q_PROPERTY 读接口
// -----------------------------------------------------------------------------

bool PlayerController::isPlaying()
{
        return false;
}

int PlayerController::duration()
{
        return 0;
}

QString PlayerController::durationString()
{
        return "00:00";
}

QString PlayerController::currentFileName()
{
        return QString();
}

bool PlayerController::isMediaLoaded()
{
        return false;
}

int PlayerController::position()
{
        return 0;
}

QString PlayerController::positionString()
{
        return "00:00";
}

int PlayerController::positionPercent()
{
        return 0;
}

int PlayerController::volume()
{
        return 100;
}

// -----------------------------------------------------------------------------
// Q_PROPERTY 写接口
// -----------------------------------------------------------------------------

void PlayerController::setVolume(int volume)
{
        // 以后写真实逻辑
        emit volumeChanged();
}

// -----------------------------------------------------------------------------
// 播放控制方法
// -----------------------------------------------------------------------------

void PlayerController::loadFile(QUrl url)
{
        emit mediaLoaded();
}

void PlayerController::play()
{
        emit playingChanged();
}

void PlayerController::pause()
{
        emit playingChanged();
}

void PlayerController::stop()
{
        emit playingChanged();
}

void PlayerController::playpause()
{
        emit playingChanged();
}

void PlayerController::setPosition(int position)
{
        emit positionChanged();
}

void PlayerController::setPositionPercent(int positionPercent)
{
        emit positionChanged();
}

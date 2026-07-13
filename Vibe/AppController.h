#pragma once

#include <QObject>

class QUrl;

class QGuiApplication;
class MediaProbeService;
class PlayerController;
class QQmlApplicationEngine;

class AppController : public QObject
{
    Q_OBJECT

public:
    explicit AppController(QGuiApplication &app, QObject *parent = nullptr);

    Q_INVOKABLE void openNewWindow();
    Q_INVOKABLE void openMediaFile(const QUrl &url);
    Q_INVOKABLE void quitApplication();

private:
    void initializeApplicationMetadata();
    void initializeQmlEngine();

private:
    QGuiApplication &m_app;
    QQmlApplicationEngine *m_engine;
    MediaProbeService *m_probeService;
    PlayerController *m_playerController;
};
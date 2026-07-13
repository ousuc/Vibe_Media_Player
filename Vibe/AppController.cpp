#include "AppController.h"

#include "MediaProbeService.h"
#include "PlayerController.h"

#include <QCoreApplication>
#include <QGuiApplication>
#include <QIcon>
#include <QProcess>
#include <QUrl>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

AppController::AppController(QGuiApplication &app, QObject *parent)
    : QObject(parent)
    , m_app(app)
    , m_engine(new QQmlApplicationEngine(this))
    , m_probeService(new MediaProbeService(this))
    , m_playerController(new PlayerController(this))
{
    m_playerController->setProbeService(m_probeService);
    initializeApplicationMetadata();
    initializeQmlEngine();
}

void AppController::initializeApplicationMetadata()
{
//注意tr()只用在给用户看的文案，像资源路径这种内部标识得用 QStringLiteral()避免被乱翻译
    QCoreApplication::setApplicationName(QStringLiteral("Vibe Media Player"));
    QCoreApplication::setApplicationVersion(QStringLiteral("0.1"));
    QCoreApplication::setOrganizationName(QStringLiteral("Vibe"));
    QCoreApplication::setOrganizationDomain(QStringLiteral("vibe.player"));
    m_app.setWindowIcon(QIcon(QStringLiteral(":/res/icons/logo_higher_res.png")));
}

void AppController::initializeQmlEngine()
{
    m_engine->rootContext()->setContextProperty(QStringLiteral("playerController"), m_playerController);
    m_engine->rootContext()->setContextProperty(QStringLiteral("appController"), this);
    m_engine->loadFromModule("Vibe", "Window");

    if (m_engine->rootObjects().isEmpty()) {
        qCritical() << "Failed to load QML root component from module Vibe";
        m_app.exit(-1);
    }
}

void AppController::openNewWindow()
{
    QProcess::startDetached(QCoreApplication::applicationFilePath());
}

void AppController::openMediaFile(const QUrl &url)
{
    if (!m_playerController) {
        return;
    }

    m_playerController->probeFile(url);
    m_playerController->loadFile(url);
    m_playerController->play();
}

void AppController::quitApplication()
{
    m_app.quit();
}
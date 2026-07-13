
#include "MediaProbeService.h"

#include <QUrl>

MediaProbeService::MediaProbeService(QObject *parent)
    : QObject(parent)
    , m_probeProgram(QStringLiteral("ffprobe"))
    , m_probeProcess(new QProcess(this))
{
    connect(m_probeProcess,
            qOverload<int, QProcess::ExitStatus>(&QProcess::finished),
            this,
            &MediaProbeService::onProbeFinished);
    connect(m_probeProcess,
            &QProcess::errorOccurred,
            this,
            &MediaProbeService::onProbeErrorOccurred);
}

void MediaProbeService::probeFile(const QUrl &url)
{
    if (url.isEmpty()) {
        emit probeError(tr("未选择文件"));
        return;
    }

    const QString localPath = url.isLocalFile() ? url.toLocalFile() : url.toString();
    if (localPath.isEmpty()) {
        emit probeError(tr("文件路径无效"));
        return;
    }

    if (m_probeProcess->state() != QProcess::NotRunning) {
        m_probeProcess->kill();
        m_probeProcess->waitForFinished(1000);
    }

    const QStringList args = {
        QStringLiteral("-v"), QStringLiteral("quiet"),
        QStringLiteral("-print_format"), QStringLiteral("json"),
        QStringLiteral("-show_format"),
        QStringLiteral("-show_streams"),
        localPath
    };

    m_probeProcess->start(m_probeProgram, args);
}

void MediaProbeService::setProbeProgram(const QString &program)
{
    const QString trimmed = program.trimmed();
    if (!trimmed.isEmpty()) {
        m_probeProgram = trimmed;
    }
}

void MediaProbeService::onProbeFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    const QString stdOut = QString::fromUtf8(m_probeProcess->readAllStandardOutput());
    const QString stdErr = QString::fromUtf8(m_probeProcess->readAllStandardError());

    if (exitStatus == QProcess::NormalExit && exitCode == 0) {
        emit mediaInfoReady(stdOut);
        return;
    }

    emit probeError(stdErr.isEmpty()
                        ? tr("ffprobe 执行失败，请检查是否已安装并加入 PATH")
                        : stdErr.trimmed());
}

void MediaProbeService::onProbeErrorOccurred(QProcess::ProcessError error)
{
    QString message;
    switch (error) {
    case QProcess::FailedToStart:
        message = tr("ffprobe 启动失败：请检查 ffprobe 是否存在且已加入 PATH");
        break;
    case QProcess::Crashed:
        message = tr("ffprobe 运行过程中崩溃");
        break;
    case QProcess::Timedout:
        message = tr("ffprobe 执行超时");
        break;
    case QProcess::ReadError:
        message = tr("ffprobe 读取输出失败");
        break;
    case QProcess::WriteError:
        message = tr("ffprobe 写入输入失败");
        break;
    case QProcess::UnknownError:
    default:
        message = tr("ffprobe 发生未知错误");
        break;
    }

    emit probeError(message);
}
#pragma once

#include <QObject>
#include <QProcess>
#include <QString>

class QUrl;

class MediaProbeService : public QObject
{
    Q_OBJECT

public:
    explicit MediaProbeService(QObject *parent = nullptr);

    Q_INVOKABLE void probeFile(const QUrl &url);
    Q_INVOKABLE void setProbeProgram(const QString &program);

signals:
    void mediaInfoReady(const QString &json);
    void probeError(const QString &message);

private slots:
    void onProbeFinished(int exitCode, QProcess::ExitStatus exitStatus);
    void onProbeErrorOccurred(QProcess::ProcessError error);

private:
    QString m_probeProgram;
    QProcess *m_probeProcess;
};
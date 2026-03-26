#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
        // 设置环境变量，启动虚拟键盘
        qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

        // 管理整个程序的生命周期
        QGuiApplication app(argc, argv);

        // 声明一个引擎，管理qml
        QQmlApplicationEngine engine;

        // 如果创建引擎失败会发生什么？
        QObject::connect(
                &engine,
                &QQmlApplicationEngine::objectCreationFailed,
                &app,
                []() { QCoreApplication::exit(-1); },
                Qt::QueuedConnection);
        // 这个就是从URI中加载这个qml文件进行渲染
        engine.loadFromModule("Vibe", "Main");

        return app.exec();
}

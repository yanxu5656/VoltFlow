#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QFile>
#include "TaskManager.h"

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");
    QGuiApplication app(argc, argv);
    TaskManager taskManager;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("taskManager", &taskManager);
    app.setWindowIcon(QIcon(":/qt/qml/VoltFlow/image/logo.ico"));
    QIcon icon(":/qt/qml/VoltFlow/image/logo.png");
    //qDebug() << "图标是否加载成功：" << !icon.isNull();
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("VoltFlow", "Main");
    return QGuiApplication::exec();
}
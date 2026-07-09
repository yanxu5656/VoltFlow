// 主程序入口：注册并挂载 TaskManager 实例到 QML 上下文
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "TaskManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    TaskManager taskManager;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("taskManager", &taskManager);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("VoltFlow", "Main");

    return QGuiApplication::exec();
}
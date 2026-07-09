#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "TaskManager.h"

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");
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
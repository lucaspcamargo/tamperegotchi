#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>

#include "types.h"
#include "tgameroot.h"

#include <cstdlib>
#include <ctime>

int main(int argc, char *argv[])
{
    registerTypes();
    std::srand(std::time(0));

    QGuiApplication::setOrganizationName("UTA");
    QGuiApplication::setOrganizationDomain("sis.uta.fi");
    QGuiApplication::setApplicationDisplayName(("TampereGotchi"));
    QGuiApplication::setApplicationName("TampereGotchi");

    QGuiApplication app(argc, argv);

    TGameRoot gameRoot;
    gameRoot.connect(&app, SIGNAL(aboutToQuit()), SLOT(savePets()));

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("gameRoot", &gameRoot);
    engine.rootContext()->setContextProperty("cwd", "file:///" + QDir::current().absolutePath());

    engine.load(QUrl(QStringLiteral("qrc:/ui/main.qml")));

    return app.exec();
}

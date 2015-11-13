#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/TamagotchiHelloWorld/main.qml"));
#ifdef ANDROID
    viewer.showFullScreen();
#else
    viewer.showExpanded();
#endif
    return app.exec();
}

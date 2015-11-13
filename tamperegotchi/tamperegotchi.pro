TEMPLATE = app

QT += qml quick multimedia testlib bluetooth

SOURCES += \
    src/main.cpp \
    src/tgameroot.cpp \
    src/pet.cpp \
    src/tpetgraphics.cpp \
    src/types.cpp \
    src/tsimulationstepper.cpp \
    src/tgamesettings.cpp \
    src/tpetstats.cpp

lupdate_only{
    SOURCES += ui/*.qml
}

TRANSLATIONS += l10n/tamperegotchi_fi.ts \
                l10n/tamperegotchi_pt.ts

RESOURCES += ui.qrc


SUBDIRS += tests

!android{
#   not using qrc anymore
#    RESOURCES += res/res.qrc
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    src/tgameroot.h \
    src/pet.h \
    src/tpetgraphics.h \
    src/types.h \
    src/tsimulationstepper.h \
    src/tgamesettings.h \
    src/tpetstats.h

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    ui/MinigameJanKenPo.qml \
    res/worlds/mgamebg.jpg

DISTFILES += \
    ui/MinigameMenu.qml

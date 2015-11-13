#-------------------------------------------------
#
# Project created by QtCreator 2014-11-07T12:54:48
#
#-------------------------------------------------

QT       += testlib

QT       -= gui

TARGET = tst_statstest
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES += tst_statstest.cpp \
    ../../src/pet.cpp \
    ../../src/tpetgraphics.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"

HEADERS += \
    ../../src/pet.h \
    ../../src/tpetgraphics.h

OTHER_FILES +=

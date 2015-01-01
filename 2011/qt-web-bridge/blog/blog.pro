#-------------------------------------------------
#
# Project created by QtCreator 2011-08-07T17:47:33
#
#-------------------------------------------------

QT       += core

QT       -= gui

TARGET = blog
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += \
    Entry.cpp \
    Main.cpp \
    ParameterMap.cpp

HEADERS += \
    Entry.h \
    ParameterMap.h

LIBS += -L$$PWD/../../qjson/lib/ -lqjson

INCLUDEPATH += $$PWD/../../qjson/src
DEPENDPATH += $$PWD/../../qjson/src

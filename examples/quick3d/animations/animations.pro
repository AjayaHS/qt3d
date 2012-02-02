TEMPLATE = app
TARGET = animations_qml
QT += declarative quick
CONFIG += qt warn_on

SOURCES += main.cpp

ICON_FILE = ../icon.png

QML_FILES = \
    qml/Animations.qml \
    qml/desktop.qml

QML_INFRA_FILES = \
    $$QML_FILES \
    qml/qtlogo.png \
    qml/cube_rotated.dae \
    qml/stonewal.jpg

CATEGORY = examples
include(../../../pkg.pri)

INSTALL_DIRS = qml
mt: INSTALL_FILES = mt.qml

OTHER_FILES += \
    animations_qml.rc \
    $$QML_INFRA_FILES

RC_FILE = animations_qml.rc
QT += quick

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        imagedatabase.cpp \
        imagemetadata.cpp \
        main.cpp \
        presentationtimer.cpp

LIBS += /usr/lib/x86_64-linux-gnu/libexiv2.so.14

RESOURCES += qml.qrc

TRANSLATIONS += \
    workswell_imageViewer_en_US.ts


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    imagedatabase.h \
    imagemetadata.h \
    presentationtimer.h

DISTFILES +=

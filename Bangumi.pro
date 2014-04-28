TEMPLATE = app

VERSION = 1.0.0
DEFINES += VER=\\\"$$VERSION\\\"

QT += network webkit

INCLUDEPATH += src

HEADERS += \
    nativefunc.h \
    bnetworkcookiejar.h

SOURCES += main.cpp \
    nativefunc.cpp \
    bnetworkcookiejar.cpp

TRANSLATIONS += i18n/Bangumi_zh.ts
RESOURCES += Bangumi-res.qrc

folder_symbian3.source = qml/Bangumi
folder_symbian3.target = qml

folder_js.source = qml/js
folder_js.target = qml

DEPLOYMENTFOLDERS = folder_js

symbian {
    contains(QT_VERSION, 4.7.3){
        DEFINES += Q_OS_S60V5
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/epoc32/include/middleware
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/include/Qt
    } else {
        CONFIG += qt-components
        DEPLOYMENTFOLDERS += folder_symbian3
    }

    CONFIG += localize_deployment
    TARGET.UID3 = 0xA006DFFA
    TARGET.CAPABILITY += \
        NetworkServices \
        ReadUserData \
        WriteUserData

    TARGET.EPOCHEAPSIZE = 0x40000 0x4000000

    vendorinfo = "%{\"Yeatse\"}" ":\"Yeatse\""
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT += my_deployment

    # Symbian have a different syntax
    DEFINES -= VER=\\\"$$VERSION\\\"
    DEFINES += VER=\"$$VERSION\"
}

include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

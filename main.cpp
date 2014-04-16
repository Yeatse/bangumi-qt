#include <QtGui/QApplication>
#include <QtGui/QSplashScreen>
#include <QtDeclarative/QDeclarativeContext>
#include <QtWebKit/QWebSettings>
#include <QtNetwork/QNetworkProxy>
#include <QtCore/QLibraryInfo>
#include <QtCore/QTranslator>
#include "qmlapplicationviewer.h"
#include "nativefunc.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

#ifdef Q_OS_SYMBIAN
    QSplashScreen *splash = new QSplashScreen(QPixmap("qml/Bangumi/gfx/splash.jpg"));
    splash->setWindowFlags(Qt::WindowStaysOnTopHint);
    splash->show();
#endif

    app->setApplicationName("Bangumi");
    app->setOrganizationName("Yeatse");
    app->setApplicationVersion(VER);

    QString locale = QLocale::system().name();
    QTranslator qtTranslator;
    if (qtTranslator.load("qt_"+locale, QLibraryInfo::location(QLibraryInfo::TranslationsPath)))
        app->installTranslator(&qtTranslator);
    QTranslator translator;
    if (translator.load(app->applicationName()+"_"+locale, ":/i18n/"))
        app->installTranslator(&translator);

#if 1
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::HttpProxy);
    proxy.setHostName("192.168.1.64");
    proxy.setPort(8888);
    QNetworkProxy::setApplicationProxy(proxy);
#endif

    QmlApplicationViewer viewer;

    NativeFunc nativeFunc;
    viewer.rootContext()->setContextProperty("utility", &nativeFunc);

    QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("qml/js/theme.css"));

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/Bangumi/main.qml"));
    viewer.showExpanded();

#ifdef Q_OS_SYMBIAN
    splash->finish(&viewer);
    splash->deleteLater();
#endif

    return app->exec();
}

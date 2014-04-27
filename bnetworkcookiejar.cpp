#include "bnetworkcookiejar.h"
#include <QtCore/QSettings>

BNetworkCookieJar::BNetworkCookieJar(QObject *parent) :
    QNetworkCookieJar(parent)
{
    load();
}

BNetworkCookieJar::~BNetworkCookieJar()
{
    save();
}

QList<QNetworkCookie> BNetworkCookieJar::cookiesForUrl(const QUrl &url) const
{
    QMutexLocker lock(&mutex);
    return QNetworkCookieJar::cookiesForUrl(url);
}

bool BNetworkCookieJar::setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url)
{
    QMutexLocker lock(&mutex);
    return QNetworkCookieJar::setCookiesFromUrl(cookieList, url);
}

void BNetworkCookieJar::save()
{
    QMutexLocker lock(&mutex);
    QList<QNetworkCookie> list = allCookies();
    QByteArray data;
    foreach (QNetworkCookie cookie, list) {
        if (cookie.domain().endsWith("bgm.tv")){
            data.append(cookie.toRawForm());
            data.append("\n");
        }
    }
    QSettings().setValue("cookies", data);
}

void BNetworkCookieJar::load()
{
    QMutexLocker lock(&mutex);
    QByteArray data = QSettings().value("cookies").toByteArray();
    setAllCookies(QNetworkCookie::parseCookies(data));
}

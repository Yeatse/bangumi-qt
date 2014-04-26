#ifndef BNETWORKCOOKIEJAR_H
#define BNETWORKCOOKIEJAR_H

#include <QtCore/QMutex>
#include <QtNetwork/QNetworkCookieJar>

class BNetworkCookieJar : public QNetworkCookieJar
{
    Q_OBJECT

public:
    explicit BNetworkCookieJar(QObject *parent = 0);
    ~BNetworkCookieJar();

    virtual QList<QNetworkCookie> cookiesForUrl(const QUrl &url) const;
    virtual bool setCookiesFromUrl(const QList<QNetworkCookie> &cookieList, const QUrl &url);

private:
    void save();
    void load();
    mutable QMutex mutex;
};

#endif // BNETWORKCOOKIEJAR_H

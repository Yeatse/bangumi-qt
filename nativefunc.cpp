#include "nativefunc.h"
#include <QDateTime>
#include <QStringList>

NativeFunc::NativeFunc(QObject *parent) :
    QObject(parent),
    mSettings(0)
{
    mSettings = new QSettings(this);
}

int NativeFunc::qtVersion() const
{
    QString qtver(qVersion());
    QStringList vlist = qtver.split(".");
    if (vlist.length() >= 3){
        int major = vlist.at(0).toInt();
        int minor = vlist.at(1).toInt();
        int patch = vlist.at(2).toInt();
        return (major << 16) + (minor << 8) + patch;
    } else {
        return 0;
    }
}

void NativeFunc::setSetting(const QString &key, const QVariant &value)
{
    mSettings->setValue(key, value);
}

QVariant NativeFunc::getSetting(const QString &key, const QVariant &defaultValue) const
{
    return mSettings->value(key, defaultValue);
}

void NativeFunc::clearSettings()
{
    mSettings->clear();
}

QString NativeFunc::easyDate(const QDateTime &date)
{
    if (formats.length() == 0)
        initializeLangFormats();

    QDateTime now = QDateTime::currentDateTime();
    int secsDiff = date.secsTo(now);

    QString token;
    if (secsDiff < 0){
        secsDiff = abs(secsDiff);
        token = lang["from"];
    } else {
        token = lang["ago"];
    }

    QString result;
    foreach (QVariantList format, formats) {
        if (secsDiff < format.at(0).toInt()){
            if (format == formats.at(0)){
                result = format.at(1).toString();
            } else {
                int val = ceil((double)(normalize(secsDiff, format.at(3).toInt())) / format.at(3).toInt());
                result = tr("%1 %2 %3", "e.g. %1 is number value such as 2, %2 is mins, %3 is ago")
                        .arg(QString::number(val)).arg(val != 1 ? format.at(2).toString() : format.at(1).toString()).arg(token);
            }
            break;
        }
    }
    return result;
}

void NativeFunc::initializeLangFormats()
{
    lang["ago"] = tr("ago");
    lang["from"] = tr("From Now");
    lang["now"] = tr("just now");
    lang["minute"] = tr("min");
    lang["minutes"] = tr("mins");
    lang["hour"] = tr("hr");
    lang["hours"] = tr("hrs");
    lang["day"] = tr("day");
    lang["days"] = tr("days");
    lang["week"] = tr("wk");
    lang["weeks"] = tr("wks");
    lang["month"] = tr("mth");
    lang["months"] = tr("mths");
    lang["year"] = tr("yr");
    lang["years"] = tr("yrs");

    QVariantList l1;
    l1 << 60 << lang["now"];
    QVariantList l2;
    l2 << 3600 << lang["minute"] << lang["minutes"] << 60;
    QVariantList l3;
    l3 << 86400 << lang["hour"] << lang["hours"] << 3600;
    QVariantList l4;
    l4 << 604800 << lang["day"] << lang["days"] << 86400;
    QVariantList l5;
    l5 << 2628000 << lang["week"] << lang["weeks"] << 604800;
    QVariantList l6;
    l6 << 31536000 << lang["month"] << lang["months"] << 2628000;
    QVariantList l7;
    l7 << INT_MAX << lang["year"] << lang["years"] << 31536000;

    formats << l1 << l2 << l3 << l4 << l5 << l6 << l7;
}

int NativeFunc::normalize(int val, int single)
{
    int margin = 0.1;
    if (val >= single && val <= single*(1+margin))
        return single;
    return val;
}

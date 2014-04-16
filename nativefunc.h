#ifndef NATIVEFUNC_H
#define NATIVEFUNC_H

#include <QObject>
#include <QSettings>

class NativeFunc : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int qtVersion READ qtVersion CONSTANT FINAL)

public:
    explicit NativeFunc(QObject *parent = 0);
    int qtVersion() const;

    Q_INVOKABLE void setSetting(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant getSetting(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE void clearSettings();
    Q_INVOKABLE QString easyDate(const QDateTime &date);

private:
    void initializeLangFormats();
    int normalize(int val, int single);
    QHash<QString, QString> lang;
    QList<QVariantList> formats;
    QSettings* mSettings;
};

#endif // NATIVEFUNC_H

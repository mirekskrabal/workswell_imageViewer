#ifndef IMAGELOADER_H
#define IMAGELOADER_H

#include <QObject>
#include <QQmlListProperty>
#include <QMetaType>
#include <unordered_map>

class ImageLoader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<QString> images READ images)
public:
    explicit ImageLoader(QObject *parent = nullptr);
    QQmlListProperty<QString> images();
signals:
    void foo();
private:
    void appendImage(QQmlListProperty<QString *> *, QString *item);
    QString *imageAt(QQmlListProperty<QString *> *, int index);
    void clearImages(QQmlListProperty<QString *> *);
    int countImages(QQmlListProperty<QString *> *);
    void removeLastImage(QQmlListProperty<QString *> *);
    void replaceImage(QQmlListProperty<QString *> *, int index, QString *item);
    QList<QString *> m_images;
};

#endif // IMAGELOADER_H

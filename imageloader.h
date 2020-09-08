#ifndef IMAGELOADER_H
#define IMAGELOADER_H

#include <QObject>
#include <QQmlListProperty>
#include <QMetaType>
#include <QUrl>

class ImageLoader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<QString> images READ images NOTIFY imagesChanged)
public:
    explicit ImageLoader(QObject *parent = nullptr);
    QQmlListProperty<QString> images();

signals:
    void imagesChanged();

public slots:
    void appendImage(QList<QUrl> files);

private:
    QString *imageAt(QQmlListProperty<QString *> *, int index);
    void clearImages(QQmlListProperty<QString *> *);
    int countImages(QQmlListProperty<QString *> *);
    void removeLastImage(QQmlListProperty<QString *> *);
    void replaceImage(QQmlListProperty<QString *> *, int index, QString *item);
    QList<QString *> m_images;
};

#endif // IMAGELOADER_H

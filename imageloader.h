#ifndef IMAGELOADER_H
#define IMAGELOADER_H

#include <QObject>
#include <QQmlListProperty>
#include <unordered_map>

class ImageLoader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<QString> images READ images)
public:
    explicit ImageLoader(QObject *parent = nullptr);
    QQmlListProperty<QString> images();
signals:
private:
    void appendImage(QString*);
    int imageCount();
    QString *image(int);
    void clearImages();
    void replaceImage(int, QString*);
    void removeLastImage();

    QList<QString *> m_images;
};

#endif // IMAGELOADER_H

#ifndef IMAGELOADER_H
#define IMAGELOADER_H

#include <QObject>
#include <QQmlListProperty>
#include <QMetaType>
#include <QUrl>
#include <QImage>
#include "imagemetadata.h"

class ImageDatabase : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<ImageMetaData> images READ images NOTIFY imagesChanged)
public:
    explicit ImageDatabase(QObject *parent = nullptr);
    QQmlListProperty<ImageMetaData> images();

signals:
    void imagesChanged();
    void sendImage(QImage &image);

public slots:
    //creates imagemetadata objects from given urls in list and appends to m_images
    void appendImage(QList<QUrl> files);
    //searches folder for jpg files, creaes imagemetadata object from found files and append to m_images
    void searchFolder(QUrl path);
    //deletes imagemetadata object from list by given index
    void deleteImage(int index);
    //clears whole m_images lis
    void clearImages();
    //creates qimage and emits sendImage signal
    void createImage(int index);
private:
    QImage m_img;
    QList<ImageMetaData *> m_images;
};

#endif // IMAGELOADER_H

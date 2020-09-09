#ifndef IMAGELOADER_H
#define IMAGELOADER_H

#include <QObject>
#include <QQmlListProperty>
#include <QMetaType>
#include <QUrl>
#include <QQuickImageProvider>
#include <QImage>
#include "imagemetadata.h"

class ImageDatabase : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<ImageMetaData> images READ images NOTIFY imagesChanged)
    QImage m_img;
    QList<ImageMetaData *> m_images;
    int listIndex;
    int imgWidth;
    int imgHeight;
public:
    explicit ImageDatabase(QObject *parent = nullptr);
    QQmlListProperty<ImageMetaData> images();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
signals:
    //emited when new image files are added to the list
    void imagesChanged();
    //emited when button to view an image was clicked
    void indexChanged();

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
    void setIndex(int index);
};

#endif // IMAGELOADER_H

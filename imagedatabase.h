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
    QImage m_placeHolder;
    QList<ImageMetaData *> m_images;
    //stores index of image which should be displayed
    int listIndex;
    /*checks if image was transformed, so provider provides currently created qimage
    doesn't create new one*/
    bool m_wasTransformed;
    //transform for ratating images by 90 degrees
    QTransform m_rightRotation;
    //transform for ratating images by -90 degrees
    QTransform m_leftRotation;

public:
    explicit ImageDatabase(QObject *parent = nullptr);
    ~ImageDatabase();
    QQmlListProperty<ImageMetaData> images();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
signals:
    //emited when new image files are added to the list
    void imagesChanged();
    //emited when button to view an image was clicked
    void indexChanged(int index);

public slots:
    //creates imagemetadata objects from given urls in list and appends to m_images
    void appendImage(QList<QUrl> files);
    //searches folder for jpg files, creaes imagemetadata object from found files and append to m_images
    void searchFolder(QUrl path);
    //deletes imagemetadata object from list by given index
    void deleteImage(int index);
    //clears whole m_images list
    void clearImages();
    //sets index of image which should be displayed
    void setIndex(int index);
    //rotates currently viewed image right
    void rotateRight();
    //rotates currently viewed image right
    void rotateLeft();
};

#endif // IMAGELOADER_H

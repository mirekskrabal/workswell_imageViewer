#include <qdebug.h>
#include <qdiriterator.h>
#include "imagedatabase.h"

ImageDatabase::ImageDatabase(QObject *parent) : QObject(parent), m_images(QList<ImageMetaData *>()){}

QQmlListProperty<ImageMetaData> ImageDatabase::images()
{
    return QQmlListProperty<ImageMetaData>(this, m_images);
}

void ImageDatabase::appendImage(QList<QUrl> files)
{
    ImageMetaData *tmpData;
    QList<QUrl>::iterator i;
    for (i = files.begin(); i != files.end(); ++i){
        tmpData = new ImageMetaData(*i);
        m_images.append(tmpData);
    }
    emit imagesChanged();
}

void ImageDatabase::searchFolder(QUrl path)
{
    QStringList nameFilter("*.jpg");
    QDirIterator dirIt(path.path(), nameFilter);
    while (dirIt.hasNext()){
        dirIt.next();
        m_images.append(new ImageMetaData((QUrl(dirIt.filePath()))));
    }
    emit imagesChanged();
}

void ImageDatabase::deleteImage(int index)
{
    m_images.removeAt(index);
    emit imagesChanged();
}

void ImageDatabase::clearImages()
{
    m_images.clear();
    emit imagesChanged();
}

void ImageDatabase::createImage(int index)
{
    qDebug() << "creating image on index: " << index;
    m_img = QImage(m_images.at(index)->url().path(), ".jpg");
    emit sendImage(m_img);
}


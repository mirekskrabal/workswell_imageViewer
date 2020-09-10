#include <qdebug.h>
#include <qdiriterator.h>
#include <qsize.h>
#include "imagedatabase.h"

ImageDatabase::ImageDatabase(QObject *parent) : QObject(parent),
                                                QQuickImageProvider(QQuickImageProvider::Image),
                                                m_images(QList<ImageMetaData *>()),
                                                m_wasTransformed(false),
                                                m_rightRotation(0,1,0,-1,0,0,0,0,1),
                                                m_leftRotation(0,-1,0,1,0,0,0,0,1){}

QQmlListProperty<ImageMetaData> ImageDatabase::images()
{
    return QQmlListProperty<ImageMetaData>(this, m_images);
}

QImage ImageDatabase::requestImage(const QString &, QSize *, const QSize &requested)
{
    if (!m_wasTransformed && listIndex < m_images.length() && listIndex >= 0 && !m_images.empty()){
        m_img = QImage(m_images.at(listIndex)->url().path(), ".jpg");
    }
    m_wasTransformed = false;
    qDebug() << "returning image";
    return m_img;
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

void ImageDatabase::setIndex(int index)
{
    listIndex = index;
    emit indexChanged(index);
}

void ImageDatabase::rotateRight()
{
    m_wasTransformed = true;
    m_img = m_img.transformed(m_rightRotation);
    qDebug() << "transforming";
}

void ImageDatabase::rotateLeft()
{
    m_wasTransformed = true;
    m_img = m_img.transformed(m_leftRotation);
}


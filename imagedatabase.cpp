#include <qdebug.h>
#include <qdiriterator.h>
#include <qsize.h>
#include "imagedatabase.h"

ImageDatabase::ImageDatabase(QObject *parent) : QObject(parent),
                                                QQuickImageProvider(QQuickImageProvider::Image),
                                                m_images(QList<ImageMetaData *>()),
                                                m_wasTransformed(false),
                                                m_rightRotation(0,1,0,-1,0,0,0,0,1),
                                                m_leftRotation(0,-1,0,1,0,0,0,0,1)
{
    //to have a valid placeholder image while no images are beeing displayed
    QPixmap tmp = QPixmap(1,1);
    tmp.fill(Qt::black);
    m_placeHolder = tmp.toImage();
    m_img = m_placeHolder;
}

QQmlListProperty<ImageMetaData> ImageDatabase::images()
{
    return QQmlListProperty<ImageMetaData>(this, m_images);
}

QImage ImageDatabase::requestImage(const QString &, QSize *, const QSize &)
{
    if (!m_wasTransformed && listIndex < m_images.length() && listIndex >= 0 && !m_images.empty()){
        m_img = QImage(m_images.at(listIndex)->url().path(), ".jpg");
    }
    m_wasTransformed = false;
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
    //removed picture was the one which was currently beeing displayed -> needed to reload
    if (index == listIndex) {
        //no other pictures to load
        if (m_images.empty()){
            m_img = m_placeHolder;
        }
        //image directly below in the table view will be displayed
        else {
            //currently displayed image was the first one in the list
            if (listIndex - 1 < 0) {
                listIndex = m_images.length() - 1;
            }
            else {
                --listIndex;
            }
            m_img = QImage(m_images.at(listIndex)->url().path(), ".jpg");
        }
        emit indexChanged(0);
    }
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
}

void ImageDatabase::rotateLeft()
{
    m_wasTransformed = true;
    m_img = m_img.transformed(m_leftRotation);
}


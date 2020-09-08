#include <qdebug.h>
#include <qdiriterator.h>
#include "imageloader.h"

ImageLoader::ImageLoader(QObject *parent) : QObject(parent) {}

QQmlListProperty<ImageMetaData> ImageLoader::images()
{
//    qDebug() << "returninaklsjf ";
    return QQmlListProperty<ImageMetaData>(this, m_images);
    //return {this, m_images};
}

void ImageLoader::appendImage(QList<QUrl> files)
{
    ImageMetaData *tmpData;
    QList<QUrl>::iterator i;
    for (i = files.begin(); i != files.end(); ++i){
        tmpData = new ImageMetaData(*i);
        m_images.append(tmpData);
    }
    emit imagesChanged();
}

void ImageLoader::searchFolder(QUrl path)
{
    QStringList nameFilter("*.jpg");
    QDirIterator dirIt(path.path(), nameFilter);
    while (dirIt.hasNext()){
        dirIt.next();
        m_images.append(new ImageMetaData((QUrl(dirIt.filePath()))));
        qDebug() << "test" << path.path();
        qDebug() << dirIt.filePath();
    }
    emit imagesChanged();
}

/*
int ImageLoader::countImages(QQmlListProperty<QString *> *)
{
    return m_images.count();
}

QString *ImageLoader::imageAt(QQmlListProperty<QString *> *, int index)
{
    return m_images.at(index);
}

void ImageLoader::clearImages(QQmlListProperty<QString *> *)
{
    m_images.clear();
}

void ImageLoader::replaceImage(QQmlListProperty<QString *> *, int index, QString *item)
{
    m_images[index] = item;
}

void ImageLoader::removeLastImage(QQmlListProperty<QString *> *)
{
    m_images.pop_back();
}*/

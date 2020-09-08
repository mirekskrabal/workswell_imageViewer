#include "imageloader.h"
#include <qdebug.h>

ImageLoader::ImageLoader(QObject *parent) : QObject(parent) {}

QQmlListProperty<ImageMetaData> ImageLoader::images()
{
//    qDebug() << "returninaklsjf ";
    return QQmlListProperty<ImageMetaData>(this, m_images);
    //return {this, m_images};
}

void ImageLoader::appendImage(QList<QUrl> files)
{
//    QString *tmpStr;
    ImageMetaData *tmpData;
    QList<QUrl>::iterator i;
    for (i = files.begin(); i != files.end(); ++i){
        tmpData = new ImageMetaData((*i).toString());
//        tmpData = new ImageMetaData(tmpStr);
        m_images.append(tmpData);
        qDebug() << *i;
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

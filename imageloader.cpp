#include "imageloader.h"
#include <qdebug.h>

ImageLoader::ImageLoader(QObject *parent) : QObject(parent) {}

QQmlListProperty<QString> ImageLoader::images()
{
    return {this, m_images};
}

void ImageLoader::appendImage(QList<QUrl> files)
{
    QString *tmp;
    QList<QUrl>::iterator i;
    for (i = files.begin(); i != files.end(); ++i){
        tmp = new QString((*i).toString());
        m_images.append(tmp);
        qDebug() << "i was signaled" << *i;
    }
//    emit imagesChanged();
}

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
}

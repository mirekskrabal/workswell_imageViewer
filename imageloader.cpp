#include "imageloader.h"

ImageLoader::ImageLoader(QObject *parent) : QObject(parent) {
    QString *test1 = new QString("test1");
    QString *test2 = new QString("test3");
    QString *test3 = new QString("test2");
    m_images.push_back(test1);
    m_images.push_back(test2);
    m_images.push_back(test3);
}

QQmlListProperty<QString> ImageLoader::images()
{
    return {this, m_images};
}

void ImageLoader::appendImage(QQmlListProperty<QString *> *, QString *item)
{
    m_images.push_back(item);
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

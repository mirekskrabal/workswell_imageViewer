#include "imageloader.h"

ImageLoader::ImageLoader(QObject *parent) : QObject(parent) {}

QQmlListProperty<QString> ImageLoader::images()
{
    return {this, this,
                 &ImageLoader::appendImage,
                 &ImageLoader::imageCount,
                 &ImageLoader::images,
                 &ImageLoader::clearImages,
                 &ImageLoader::replaceImage,
                 &ImageLoader::removeLastImage};
}

void ImageLoader::appendImage(QString *)
{
    m_images.append()
}

int ImageLoader::imageCount(QQmlListProperty<QString> *)
{

}

QString *ImageLoader::image(QQmlListProperty<QString> *, int)
{

}

void ImageLoader::clearImages(QQmlListProperty<QString> *)
{

}

void ImageLoader::replaceImage(QQmlListProperty<QString> *, int, QString *)
{

}

void ImageLoader::removeLastImage(QQmlListProperty<QString> *)
{

}

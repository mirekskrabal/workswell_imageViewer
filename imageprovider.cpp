#include <QtDebug>
#include "imageprovider.h"

ImageProvider::ImageProvider(QObject *parent) : QObject(parent), QQuickImageProvider(QQuickImageProvider::Image){}

void ImageProvider::recvImg(QImage &image)
{
    m_image = image;
    emit imageUpdated();
}

QImage ImageProvider::requestImage(const QString &, QSize *, const QSize &)
{
    return m_image;
}

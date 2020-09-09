#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QImage>
#include <QUrl>

class ImageProvider : public QQuickImageProvider
{
    QImage m_image;
public:
    ImageProvider();
public slots:
    void recvImg(QImage &&image);
};

#endif // IMAGEPROVIDER_H

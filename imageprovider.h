#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QImage>
#include <QObject>
#include <QUrl>

class ImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    QImage m_image;
public:
    explicit ImageProvider(QObject *parent = nullptr);
    virtual ~ImageProvider() {};
public slots:
    void recvImg(QImage &image);
};

#endif // IMAGEPROVIDER_H

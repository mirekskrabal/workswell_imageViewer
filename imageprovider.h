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
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
signals:
    void imageUpdated();
public slots:
    void recvImg(QImage &image);
};

#endif // IMAGEPROVIDER_H

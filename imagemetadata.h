#ifndef IMAGEMETADATA_H
#define IMAGEMETADATA_H

#include <QObject>

class ImageMetaData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString str READ str)
    QString m_path;
public:
    QString str() {return m_path;}
    explicit ImageMetaData(QObject *parent = nullptr);
    ImageMetaData(QString path) : m_path(path){}
};

#endif // IMAGEMETADATA_H

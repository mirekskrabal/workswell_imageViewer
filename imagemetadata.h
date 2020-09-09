#ifndef IMAGEMETADATA_H
#define IMAGEMETADATA_H

#include <QObject>
#include <QUrl>

class ImageMetaData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    QUrl m_path;
    QString m_name;
signals:
    void nameChanged();
public:
    explicit ImageMetaData(QObject *parent = nullptr);
    ImageMetaData(QUrl &path) : m_path(path), m_name(path.fileName()){}
    ImageMetaData(QUrl &&path) : m_path(path), m_name(path.fileName()){}

    QString name() {return m_name;}
    QUrl &url() {return m_path;}
};

#endif // IMAGEMETADATA_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <imagedatabase.h>
#include "imageprovider.h"

int main(int argc, char *argv[])
{

    //qRegisterMetaType<ImageMetaData>("ms",1,0,"ImageMetaData");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("workswell");
    app.setOrganizationDomain("workswell");

    QQmlApplicationEngine engine;

    QQmlContext* context(engine.rootContext());

    ImageDatabase imgDb;// = new ImageDatabase();
    ImageProvider imgProv;// = new ImageProvider();

    context->setContextProperty("imgDatabase", &imgDb);

    //add custom image provider
    engine.addImageProvider(QLatin1String("provider"), &imgProv);

    //connect image databse and image provider
    QObject::connect(&imgDb, &ImageDatabase::sendImage,
                     &imgProv, &ImageProvider::recvImg);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    qmlRegisterType<ImageMetaData>("ms",1,0,"ImageMetaData");

    engine.load(url);

    return app.exec();
}

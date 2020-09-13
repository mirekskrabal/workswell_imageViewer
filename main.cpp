#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include "imagedatabase.h"
#include "presentationtimer.h"
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("workswell");
    app.setOrganizationDomain("workswell");

    QQmlApplicationEngine engine;

    QQmlContext* context(engine.rootContext());

    ImageDatabase imgDb;// = new ImageDatabase();
    PresentationTimer timer;

    context->setContextProperty("imgDatabase", &imgDb);
    context->setContextProperty("timer", &timer);

    QObject::connect(&imgDb, &ImageDatabase::indexChanged,
                     &timer, &PresentationTimer::onIndexChanged);

    QObject::connect(timer.m_timer, &QTimer::timeout,
                     &timer, &PresentationTimer::onNotified);

    QObject::connect(&timer, &PresentationTimer::displayAnotherImg,
                     &imgDb, &ImageDatabase::setIndex);

    //add custom image provider
    engine.addImageProvider(QLatin1String("provider"), &imgDb);

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

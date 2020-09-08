#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <imageloader.h>
//#include <QQmlListProperty>

int main(int argc, char *argv[])
{

    //qRegisterMetaType<ImageMetaData>("ms",1,0,"ImageMetaData");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setOrganizationName("workswell");
    app.setOrganizationDomain("workswell");

    QQmlApplicationEngine engine;

    QQmlContext* context(engine.rootContext());
    context->setContextProperty("imgLoader", new ImageLoader());

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

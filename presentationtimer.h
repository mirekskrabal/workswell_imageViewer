#ifndef PRESENTATIONTIMER_H
#define PRESENTATIONTIMER_H

#include <QObject>
#include <QTimer>

class PresentationTimer : public QObject
{
    Q_OBJECT
    //index of currently displayed image in m_images in imagedatabase - presentation will start on this img
    int m_index;
    //when prestimer is created isRunning is false, then it is switched on and off by clicking
    //on Presentation button
    bool m_isRunning;
public:
    explicit PresentationTimer(QObject *parent = nullptr);
    QTimer m_timer;
signals:
    //notifies database about which img should be displayed
    void displayAnotherImg(int index);
public slots:
    //to be able to continue with next image to the one which is currently beeing displayed
    void onIndexChanged(int index);
    void startTimer(int items = 0, int sec = 5);
    //toggle timer off
    void toggleIsRunning();
    //notified by timer to change an image
    void onNotified();
};

#endif // PRESENTATIONTIMER_H

#include "presentationtimer.h"
#include <qdebug.h>

PresentationTimer::PresentationTimer(QObject *parent) : QObject(parent), m_timer(new QTimer(this))
{

}

void PresentationTimer::onIndexChanged(int index)
{
    m_index = index;
}

void PresentationTimer::startTimer(int items, int sec)
{
    qDebug() << "second: " << sec;
    if (!m_isRunning) {
        m_numOfItems = items;
        m_imageStay = sec * 1000;
        m_timer->setInterval(sec * 1000);
        m_timer->start();
        m_isRunning = true;
    }

    //timer was stopped -> set to single shot and interval to the time remaining
    if (m_wasStopped){
        m_timer->setSingleShot(true);
        m_timer->setInterval(m_timeRemaining);
        m_timer->start();
    }
}

void PresentationTimer::toggleIsRunning()
{
    m_isRunning = false;
    m_timer->stop();
}

void PresentationTimer::onNotified()
{
    //time remaining (after stop was clicked) passed -> single shot off and set the original interval
    if (m_wasStopped){
        m_timer->setSingleShot(false);
        m_timer->setInterval(m_imageStay);
        m_timer->start();
        m_wasStopped = false;
    }
    if (m_index == m_numOfItems - 1){
        m_index = 0;
    }
    else {
        ++m_index;
    }
    emit displayAnotherImg(m_index);
}

void PresentationTimer::pauseTimer()
{
    m_timeRemaining = m_timer->remainingTime();
    m_timer->stop();
    m_wasStopped = true;
}

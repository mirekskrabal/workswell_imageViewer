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
        m_timer->setInterval(sec * 1000);
        m_timer->start();
        m_isRunning = true;
    }
}

void PresentationTimer::toggleIsRunning()
{
    m_timer->stop();
}

void PresentationTimer::onNotified()
{
    if (m_index == m_numOfItems - 1){
        m_index = 0;
    }
    else {
        ++m_index;
    }
    emit displayAnotherImg(m_index);
}

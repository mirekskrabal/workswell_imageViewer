#include "presentationtimer.h"
#include <qdebug.h>

PresentationTimer::PresentationTimer(QObject *parent) : QObject(parent)
{

}

void PresentationTimer::onIndexChanged(int index)
{
    m_index = index;
}

void PresentationTimer::startTimer(int items, int sec)
{

}

void PresentationTimer::toggleIsRunning()
{
    m_isRunning = !m_isRunning;
}

void PresentationTimer::onNotified()
{
    //logic of shifting index
    emit displayAnotherImg(m_index);
}

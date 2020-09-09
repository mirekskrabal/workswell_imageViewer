#include "imageprovider.h"

ImageProvider::ImageProvider()
{

}

void ImageProvider::recvImgUrl(QImage &&image)
{
    m_image = image;
}

#include "pet.h"

#include <QUuid>
#include <QBuffer>
#include <QDataStream>
#include "tpetgraphics.h"

Pet::Pet(QVariantMap * map, QObject *parent) :
    QObject(parent), _data(map)
{
    Q_ASSERT(_data);

    _graphics = new TPetGraphics(this);
}

Pet::~Pet()
{

}

QObject * Pet::getGraphics()
{
    return _graphics;
}

QString Pet::dataString()
{
    QBuffer buf;
    buf.open(QBuffer::ReadWrite);

    QDataStream stream(&buf);

    stream << QVariant(*_data);

    QByteArray compressed = buf.data();//qCompress(buf.data(), 9);
    QByteArray base64 = compressed.toBase64(QByteArray::Base64UrlEncoding);
    return QString(base64);
}

Pet * Pet::fromDataString(QString str)
{
    QByteArray un64data = QByteArray::fromBase64(str.toLocal8Bit(), QByteArray::Base64UrlEncoding);
    QByteArray originalData = un64data;//qUncompress(un64data);
    qDebug(QString("DECODED %1 BYTES").arg(originalData.length()).toLocal8Bit());
    qDebug("DUMP:");
    qDebug(originalData);
    QBuffer buf;
    buf.setBuffer(&originalData);
    buf.open(QBuffer::ReadOnly);
    QDataStream stream(&buf);
    QVariantMap * petData = new QVariantMap();
    QVariant variant;
    stream >> (variant);
    qDebug("V2S:");
    qDebug(variant.toString().toLocal8Bit());
    (*petData) = variant.toMap();
    qDebug(QString("RECEIVED %1 FIELDS").arg(petData->count()).toLocal8Bit());
    return new Pet(petData);
}

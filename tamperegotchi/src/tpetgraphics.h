#ifndef TPETGRAPHICS_H
#define TPETGRAPHICS_H

#include <QObject>
#include "pet.h"

class TPetGraphics : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int spriteWidth MEMBER _spriteWidth NOTIFY propertiesChanged)
    Q_PROPERTY(int spriteHeight MEMBER _spriteHeight NOTIFY propertiesChanged)
public:
    explicit TPetGraphics(Pet *parent = 0);
    virtual ~TPetGraphics();
signals:
    void propertiesChanged();

public slots:

    void refreshProperties();
    QString getPetTypeName();
    QString getFileForAnimation(QString animation);
    int getOffsetForAnimation(QString animation);
    int getSpeedForAnimation(QString animation);
    int getFrameCountForAnimation(QString animation);

private:
    Pet * _pet;

    int _spriteWidth;
    int _spriteHeight;
};

#endif // TPETGRAPHICS_H

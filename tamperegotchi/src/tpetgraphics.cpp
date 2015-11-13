#include "tpetgraphics.h"
#include <QVariant>

TPetGraphics::TPetGraphics(Pet *parent) :
    QObject(parent),
    _pet(parent)
{
    refreshProperties();
}

TPetGraphics::~TPetGraphics()
{

}

void TPetGraphics::refreshProperties()
{
    const int SIZES[] = {0, 16, 24, 27};
    _spriteWidth = _pet->stage()? SIZES[_pet->stage()] : 16;
    _spriteHeight = _spriteWidth;
}

QString TPetGraphics::getPetTypeName()
{
    switch (_pet->type()) {

    case 1:
        return "devil";

    case 2:
        return "cat";

    case 3:
        return "snake";

    case 4:
        return "bunny";

    case 5:
        return "bear";

    case 6:
        return "alien";

    case 7:
        return "creature";

    case 8:
        return "bat";

    default:
        return "generic";
    }
}


QString TPetGraphics::getFileForAnimation(QString animation)
{
    switch (_pet->type()) {
    case 0:
        //generic
        return animation;

        // any other
    default:
        if(_pet->stage() == 1) return "baby";
        if(_pet->stage() == 2) return "child";
        return "adult";
    }

}

int TPetGraphics::getOffsetForAnimation(QString animation)
{
    if(animation=="sleep") return _spriteWidth * 2;
    if(animation=="feed") return _spriteWidth * 5;
    if(animation=="sick") return _spriteWidth * 7;
    if(animation=="embarrassed") return _spriteWidth * 9;

    return 0;
}

int TPetGraphics::getSpeedForAnimation(QString animation)
{
    if(animation=="feed") return 500;
    if(animation=="sleep") return 1600;

    return 1250;
}

int TPetGraphics::getFrameCountForAnimation(QString animation)
{
    if(animation=="sleep") return 3;

    return 2;
}

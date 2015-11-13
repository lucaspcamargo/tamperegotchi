#include "types.h"
#include "QMetaType"
#include "pet.h"

Q_DECLARE_METATYPE(Pet*)

void registerTypes()
{
    qRegisterMetaType<Pet*>("Pet*");
}

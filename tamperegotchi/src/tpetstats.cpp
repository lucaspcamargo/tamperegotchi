#include "tpetstats.h"
#include "pet.h"

TPetStats::TPetStats(QObject *parent) :
    QObject(parent),
    _pet( 0 )
{
}

float TPetStats::getHappinessRate()
{
    switch (_pet->stage()) {
    case 0:
        return 0;
        break;
    case 1: // baby
        return hourlyRate(0.05);
    case 2: // child
        return hourlyRate(0.07);
    default: // adult
        return hourlyRate(0.10);
    }
}

float TPetStats::getHungerRate()
{
    switch (_pet->stage()) {
    case 0:
        return 0;
        break;
    case 1: // baby
        return hourlyRate(0.1);
    case 2: // child
        return hourlyRate(0.05);
    default: // adult
        return hourlyRate(0.1);
    }
}

float TPetStats::getCleanRate()
{
    return hourlyRate(0.03);
}

float TPetStats::getEnergyRate()
{
    {
        switch (_pet->stage()) {
        case 0:
            return 0;
            break;
        case 1: // baby
            return hourlyRate(0.05);
        case 2: // child
            return hourlyRate(0.10);
        default: // adult
            return hourlyRate(0.05);
        }
    }
}

float TPetStats::getEnergyRecoverRate()
{
    {
        switch (_pet->stage()) {
        case 0:
            return 0;
            break;
        case 1: // baby
            return hourlyRate(0.2);
        case 2: // child
            return hourlyRate(0.15);
        default: // adult
            return hourlyRate(0.10);
        }
    }
}


float TPetStats::getPoopChance()
{
    return inverseHourlyRate(2)*(_pet->statFood());
}

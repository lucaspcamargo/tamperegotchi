#ifndef TPETSTATS_H
#define TPETSTATS_H

#include <QObject>

class Pet;

class TPetStats : public QObject
{
    Q_OBJECT
public:
    explicit TPetStats(QObject *parent = 0);

signals:

public slots:
    Pet * pet() { return _pet; }
    void setPet(Pet *pet) { _pet = pet; }

    float getHungerRate();
    float getHappinessRate();
    float getEnergyRate();
    float getCleanRate();

    float getEnergyRecoverRate();

    float getPoopChance();

public:
    float inverseHourlyRate(float hoursToOne) const{ return 1.0f/(hoursToOne*3600); }
    float hourlyRate(float amountPerHour) const{ return amountPerHour/(3600); }

    Pet * _pet;


};

#endif // TPETSTATS_H

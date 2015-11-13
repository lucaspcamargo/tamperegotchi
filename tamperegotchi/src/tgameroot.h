#ifndef TGAMEROOT_H
#define TGAMEROOT_H

#include <QObject>
#include <QList>
#include "pet.h"
#include "tsimulationstepper.h"
#include "tgamesettings.h"

class TGameRoot : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject* currentPet READ currentPet NOTIFY currentPetChanged)
    Q_PROPERTY(int numPets READ numPets NOTIFY numPetsChanged)
    Q_PROPERTY(QObject* simulationStepper READ simulationStepper CONSTANT)
    Q_PROPERTY(QObject* gameSettings READ gameSettings CONSTANT)
public:
    explicit TGameRoot(QObject *parent = 0);


signals:
    void currentPetChanged(QObject*);
    void numPetsChanged(int);

public slots:
    QObject * currentPet(){ return _currentPet; }
    void setCurrentPet(int index)
    {
        if(index < 0 || index >= numPets())
            _currentPet = 0;
        else
            _currentPet = _pets[index];
        emit currentPetChanged(_currentPet);
    }

    QObject * pet(int index){ if(index >= 0 && index < _pets.length()) return _pets[index]; else return 0; }
    int numPets() { return _pets.size(); }
    int currentPetIndex(){ return (_currentPet ? _pets.indexOf(_currentPet) : -1); }

    void deletePet(int index) { _pets.removeAt(index); emit numPetsChanged(numPets()); }

    QObject * simulationStepper() { return _stepper; }

    QObject * gameSettings() { return _gameSettings; }

    Pet * createPet( QString name );
    void addDownloadedPet( QString data );

    void savePets();
    void restorePets();
    void resetPets();

private:

    TSimulationStepper * _stepper;

    QList<Pet*> _pets;
    Pet * _currentPet;

    TGameSettings * _gameSettings;
};

#endif // TGAMEROOT_H

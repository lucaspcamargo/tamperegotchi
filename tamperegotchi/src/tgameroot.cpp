#include "tgameroot.h"
#include "pet.h"
#include "tsimulationstepper.h"
#include "QUuid"
#include <QSettings>
#include <cmath>

TGameRoot::TGameRoot(QObject *parent) :
    QObject(parent),
    _currentPet(0),
    _stepper(0)
{
    restorePets();

    _gameSettings = new TGameSettings(this);

    _stepper = new TSimulationStepper(this);

}

Pet *TGameRoot::createPet( QString name )
{
    QVariantMap * petData = new QVariantMap();

    (*petData)["petName"] = name;
    (*petData)["uuid"] = QUuid::createUuid().toString();
    (*petData)["stage"] = std::rand() % 3 + 1;
    (*petData)["age"] = (int) 0;
    (*petData)["type"] = std::rand() % 8 + 1;


    (*petData)["hue1"] = std::fmod((std::rand()*0.001f), 1.0f);
    (*petData)["hue2"] = std::fmod((std::rand()*0.001f), 1.0f);


    (*petData)["statFood"] = 1;
    (*petData)["statEnergy"] = 1;
    (*petData)["statHappy"] = 0.5;
    (*petData)["statClean"] = 1;

    Pet * pet = new Pet(petData, this);
    _pets.append(pet);

    emit numPetsChanged(numPets());

    return pet;
}

void TGameRoot::savePets()
{
    QSettings settings;
    QVariantList petData;

    foreach(Pet * pet, _pets)
    {
        petData.append(*pet->data());
    }

    settings.setValue("pets", petData);
    settings.setValue("currentPetIndex", currentPetIndex());
    settings.sync();
}

void TGameRoot::restorePets()
{
    QSettings settings;
    QVariantList petDataList;

    petDataList = settings.value("pets").toList();
    foreach( QVariant var, petDataList )
    {
        QVariantMap * petDataCopy = new QVariantMap(var.toMap());
        Pet * pet = new Pet(petDataCopy, this);
        _pets.append(pet);
    }

    int index = settings.value("currentPetIndex", -1).toInt();
    _currentPet = index >= 0? _pets[index] : 0;

    emit numPetsChanged(numPets());
    emit currentPetChanged(_currentPet);
}

void TGameRoot::resetPets()
{

}

void TGameRoot::addDownloadedPet(QString data)
{
    Pet * newPet = Pet::fromDataString(data);
    _pets.append(newPet);

    numPetsChanged(numPets());

}


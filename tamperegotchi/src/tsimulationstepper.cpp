#include "tsimulationstepper.h"
#include "pet.h"
#include "tgameroot.h"
#include "tpetstats.h"

TSimulationStepper::TSimulationStepper(QObject *parent) :
    QObject(parent)
{
}

#define GET_RAND (static_cast <float> (std::rand()) / static_cast <float> (RAND_MAX))

void TSimulationStepper::step(int steps)
{
    TGameRoot * root = reinterpret_cast<TGameRoot *>(parent());
    Pet * pet = reinterpret_cast<Pet *>(root->currentPet());

    if(!pet) return;

    TPetStats stats;
    stats.setPet(pet);

    for(int i = 0; i < steps; i ++)
    {
        //advance pet age
        pet->setAge( pet->age() + 1);

        if(pet->age() > MINUTES(5)) pet->setStage(1);
        if(pet->age() > HOURS(1)) pet->setStage(2);
        if(pet->age() > DAYS(3)) pet->setStage(3);

        //advance basic stats
        pet->setStatFood( pet->statFood() - stats.getHungerRate() );
        pet->setStatHappy( pet->statHappy() - stats.getHappinessRate() );
        pet->setStatEnergy( pet->statEnergy() - stats.getEnergyRate() );
        pet->setStatClean( pet->statClean() - stats.getCleanRate() );

        if(pet->sleeping()) pet->setStatEnergy( pet->statEnergy() + stats.getEnergyRecoverRate() );

        if( GET_RAND < 0.18 && pet->stage() ) // chance of light taking effect, also not egg
        {
            if( pet->envDark() )
            {
                // lights off
                if(!pet->sleeping())
                {
                    switch (pet->stage()) {
                    case 1: // baby
                        pet->setSleeping(true);
                        break;
                    case 2: // child
                        pet->setSleeping(pet->statEnergy() < 0.8);
                        break;
                    default: // adult
                        pet->setSleeping(pet->statEnergy() < 0.3);
                        break;
                    }
                }else if(pet->stage() >= 3)
                {
                    if(pet->statEnergy() == 1.0f)
                    {
                        pet->setEnvDark(false);
                        pet->setSleeping(false);
                    }
                }
            }
            else
            {
                // lights on
                if(pet->sleeping())
                    switch (pet->stage()) {
                    case 1: // baby
                        if(pet->statEnergy() > 0.5)
                        {
                            pet->setSleeping(false);
                            pet->setStatHappy(pet->statHappy() - (1 - pet->statEnergy()));
                        }
                        break;
                    case 2: // child
                        if(pet->statEnergy() > 0.3)
                        {
                            pet->setSleeping(false);
                            pet->setStatHappy(pet->statHappy() - (1 - pet->statEnergy()));
                        }
                        break;
                    default: // adult
                        pet->setSleeping(false);
                        pet->setStatHappy(pet->statHappy() - (1 - pet->statEnergy()));
                        break;
                    }

            }
        }

        // pet can get sick
        if(pet->stage() >= 2 && (!(pet->age() % (60*(pet->stage()==2? 5 : 15)))) && !pet->sick() )
        {
            if(GET_RAND < (1-pet->statClean())*(1-pet->statEnergy())*(1-pet->statFood())*(1-pet->statHappy()))
                pet->setSick(true);
        }

        if(pet->envPoop())
        {
            pet->setStatClean( pet->statClean() - stats.hourlyRate(0.5) );
            pet->setStatHappy( pet->statHappy() - stats.hourlyRate(0.1) );

        }

        float poopChance = stats.getPoopChance();
        float r = GET_RAND;
        if(r < poopChance)
        {
            pet->setEnvPoop(true);
        }
    }

    QSettings settings;
}

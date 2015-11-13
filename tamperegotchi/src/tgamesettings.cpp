#include "tgamesettings.h"

TGameSettings::TGameSettings(QObject *parent) :
    QObject(parent)
{
    QSettings settings;

    _sfxEnabled = settings.value("sfxEnabled", true).toBool();
    _musicEnabled = settings.value("musicEnabled", true).toBool();
    _retroScreen = settings.value("retroScreen", false).toBool();
    _simulationSpeed = settings.value("simulationSpeed", 1).toInt();
}

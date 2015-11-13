#ifndef TGAMESETTINGS_H
#define TGAMESETTINGS_H

#include <QObject>
#include <QSettings>

class TGameSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool sfxEnabled READ sfxEnabled WRITE setSfxEnabled NOTIFY sfxEnabledChanged)
    Q_PROPERTY(bool musicEnabled READ musicEnabled WRITE setMusicEnabled NOTIFY musicEnabledChanged)
    Q_PROPERTY(bool retroScreen READ retroScreen WRITE setRetroScreen NOTIFY retroScreenChanged)
    Q_PROPERTY( int simulationSpeed READ simulationSpeed WRITE setSimulationSpeed NOTIFY simulationSpeedChanged )
public:
    explicit TGameSettings(QObject *parent = 0);

signals:
    void sfxEnabledChanged(bool);
    void musicEnabledChanged(bool);
    void retroScreenChanged(bool);
    void simulationSpeedChanged(int);

public slots:
    bool sfxEnabled() { return _sfxEnabled; }
    bool musicEnabled() { return _musicEnabled; }
    bool retroScreen() { return _retroScreen; }
    int simulationSpeed() { return _simulationSpeed; }

    void setSfxEnabled(bool enabled)
    {
        _sfxEnabled = enabled;
        emit sfxEnabledChanged(enabled);
        QSettings settings;
        settings.setValue("sfxEnabled", enabled);
    }
    void setMusicEnabled(bool enabled)
    {
        _musicEnabled = enabled;
        emit musicEnabledChanged(enabled);
        QSettings settings;
        settings.setValue("musicEnabled", enabled);
    }
    void setRetroScreen(bool enabled)
    {
        _retroScreen = enabled;
        emit retroScreenChanged(enabled);
        QSettings settings;
        settings.setValue("retroScreen", enabled);
    }
    void setSimulationSpeed(int s)
    {
        _simulationSpeed = s;
        emit simulationSpeedChanged(s);
        QSettings settings;
        settings.setValue("simulationSpeed", s);
    }

private:
    bool _sfxEnabled;
    bool _musicEnabled;
    bool _retroScreen;
    int _simulationSpeed;

};

#endif // TGAMESETTINGS_H

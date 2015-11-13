#ifndef PET_H
#define PET_H

#include <QObject>
#include <QMap>
#include <QVariant>
#include <cmath>


class TPetGraphics;

class Pet : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString petName READ petName WRITE setPetName NOTIFY petNameChanged)
    Q_PROPERTY(QString uuid READ uuid)
    Q_PROPERTY(int stage READ stage WRITE setStage NOTIFY stageChanged)
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(qlonglong age READ age WRITE setAge NOTIFY ageChanged)
    Q_PROPERTY(bool male READ male WRITE setMale NOTIFY maleChanged)
    Q_PROPERTY(float hue1 READ hue1 CONSTANT )
    Q_PROPERTY(float hue2 READ hue2 CONSTANT )

    Q_PROPERTY(bool sleeping READ sleeping WRITE setSleeping NOTIFY sleepingChanged)
    Q_PROPERTY(bool sick READ sick WRITE setSick NOTIFY sickChanged)

    Q_PROPERTY(float statFood READ statFood WRITE setStatFood NOTIFY statFoodChanged)
    Q_PROPERTY(float statEnergy READ statEnergy WRITE setStatEnergy NOTIFY statEnergyChanged)
    Q_PROPERTY(float statHappy READ statHappy WRITE setStatHappy NOTIFY statHappyChanged)
    Q_PROPERTY(float statClean READ statClean WRITE setStatClean NOTIFY statCleanChanged)

    Q_PROPERTY(bool envPoop READ envPoop WRITE setEnvPoop NOTIFY envPoopChanged)
    Q_PROPERTY(bool envDark READ envDark WRITE setEnvDark NOTIFY envDarkChanged)

    Q_PROPERTY(QObject * graphics READ graphics CONSTANT)

public:
    explicit Pet(QVariantMap *data, QObject *parent = 0);
    virtual ~Pet();

    QString petName() { return ((*_data)["petName"]).toString(); }
    QString uuid() { return ((*_data)["uuid"]).toString(); }
    int stage() {return ((*_data)["stage"]).toInt();}
    int type() {return ((*_data)["type"]).toInt();}
    qlonglong age() {return ((*_data)["age"]).toLongLong();}
    bool male() {return ((*_data)["male"]).toBool();}

    float hue1(){ return ((*_data)["hue1"]).toFloat(); }
    float hue2(){ return ((*_data)["hue2"]).toFloat(); }

    bool sleeping() {return ((*_data)["sleeping"]).toBool();}
    bool sick() {return ((*_data)["sick"]).toBool();}

    float statFood() { return ((*_data)["statFood"]).toFloat(); }
    float statEnergy() { return ((*_data)["statEnergy"]).toFloat(); }
    float statHappy() { return ((*_data)["statHappy"]).toFloat(); }
    float statClean() { return ((*_data)["statClean"]).toFloat(); }

    bool envPoop() { return ((*_data)["envPoop"]).toBool(); }
    bool envDark() { return ((*_data)["envDark"]).toBool(); }

    QObject * graphics() { return getGraphics(); }

    static Pet * fromDataString(QString);

signals:
    void petNameChanged(QString);
    void stageChanged(int);
    void typeChanged(int);
    void ageChanged(qlonglong);
    void maleChanged(bool);

    void sleepingChanged(bool);
    void sickChanged(bool);

    void statFoodChanged(float);
    void statEnergyChanged(float);
    void statHappyChanged(float);
    void statCleanChanged(float);

    void envPoopChanged(bool);
    void envDarkChanged(bool);

public slots:
    void setPetName(QString name) { (*_data)["petName"] = name; emit petNameChanged(name); }
    void setStage(int stage) { (*_data)["stage"] = stage; emit stageChanged(stage); }
    void setType(int type) { (*_data)["type"] = type; emit typeChanged(type); }
    void setAge(qlonglong age) { (*_data)["age"] = age; emit ageChanged(age); }
    void setMale(bool male) { (*_data)["male"] = male; emit maleChanged(male); }

    void setSleeping(bool sleeping) { (*_data)["sleeping"] = sleeping; emit sleepingChanged(sleeping); }
    void setSick(bool sick) { (*_data)["sick"] = sick; emit sickChanged(sick); }

    void setStatFood(float stat) { (*_data)["statFood"] = clamp(stat); emit statFoodChanged(stat); }
    void setStatEnergy(float stat) { (*_data)["statEnergy"] = clamp(stat); emit statEnergyChanged(stat); }
    void setStatHappy(float stat) { (*_data)["statHappy"] = clamp(stat); emit statHappyChanged(stat); }
    void setStatClean(float stat) { (*_data)["statClean"] = clamp(stat); emit statCleanChanged(stat); }

    void setEnvPoop(bool poop) { (*_data)["envPoop"] = poop; emit envPoopChanged(poop); }
    void setEnvDark(bool dark) { (*_data)["envDark"] = dark; emit envDarkChanged(dark); }

    QObject * getGraphics();

    QVariantMap * data() { return _data; }
    QString dataString();

private:

    float clamp(float val) {return std::max(0.0f, std::min(val, 1.0f));}
    QVariantMap * _data;

    TPetGraphics * _graphics;

};

#endif // PET_H

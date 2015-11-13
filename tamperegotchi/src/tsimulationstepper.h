#ifndef TSIMULATIONSTEPPER_H
#define TSIMULATIONSTEPPER_H

#include <QObject>

#define MINUTES(x) ((x)*60)
#define HOURS(x) ((x)*3600)
#define DAYS(x) ((x)*3600*24)

class TSimulationStepper : public QObject
{
    Q_OBJECT
public:
    explicit TSimulationStepper(QObject *parent = 0);

signals:

public slots:
    void step(int steps = 1);
};

#endif // TSIMULATIONSTEPPER_H

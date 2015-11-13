#include <QString>
#include <QtTest>
#include "../../src/pet.h"


class StatsTest : public QObject
{
    Q_OBJECT

public:
    StatsTest();

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void testCase1();

private:
    Pet * pet;
    QVariantMap * petData;
};

StatsTest::StatsTest()
{
}

void StatsTest::initTestCase()
{
    petData = new QVariantMap();
    (*petData)["petName"] =  "Pet";
    pet = new Pet(petData, this);

    QVERIFY2(pet->petName() != "", "Name was not set");
}

void StatsTest::cleanupTestCase()
{
    delete pet;
    delete petData;
}

void StatsTest::testCase1()
{
    pet->setStatFood(.5f);
    QVERIFY2(pet->statFood() == .5f, "Food stat not updating");
}

QTEST_APPLESS_MAIN(StatsTest)

#include "tst_statstest.moc"

#include <QString>
#include <QtTest>

class PetSpriteTest : public QObject
{
    Q_OBJECT

public:
    PetSpriteTest();

private Q_SLOTS:
    void testCase1();
};

PetSpriteTest::PetSpriteTest()
{
}

void PetSpriteTest::testCase1()
{
    QVERIFY2(true, "Failure");
}

QTEST_APPLESS_MAIN(PetSpriteTest)

#include "tst_petspritetest.moc"

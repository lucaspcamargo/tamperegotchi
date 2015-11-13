import QtQuick 2.0

BorderImage {

    id: statusScreen

    property int padding: 2

    x: parent.currentModal == "status"? padding : parent.width
    y: padding
    anchors.verticalCenter: parent.verticalCenter

    source: res("ui/frame.png")
    width: parent.width-2*padding; height: parent.height-2*padding
    border.left: 5; border.top: 5
    border.right: 5; border.bottom: 5

    MouseArea
    {
        id: blocker
        anchors.fill: parent
    }

    TTextBitmap
    {
        id: petName
        text: gameRoot.currentPet.petName.toUpperCase()
        font: "sonic-hud-black"
        x: 6
        anchors.bottom: spriteFrame.bottom
        anchors.margins: -1
    }

    Rectangle
    {
        id: spriteFrame
        anchors.fill: sprite
        anchors.margins: -1
        color: "white"
        border.color: "black"
        radius: 2
        opacity: 0.5
    }

    PetSprite
    {
        id: sprite
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 7
        wander: false


    }

    Column{
        id: inColumn
        anchors.fill: parent
        anchors.margins: 6
        anchors.topMargin:  2 + petName.y + petName.height
        spacing: 2


        TTextBitmap
        {
            id: ageSex
            text: (gameRoot.currentPet.male? qsTr("Male") : qsTr("Female"))+
                  qsTr(", %1%2:%3h old").arg(gameRoot.currentPet.age > 3600? Math.floor(gameRoot.currentPet.age/3600)+":" : "").arg(Math.floor(gameRoot.currentPet.age/60)%60).arg(gameRoot.currentPet.age%60)
            //anchors.horizontalCenter: parent.horizontalCenter
            height: 10
        }

        TProgressBar
        {
            id: hungerLabel
            label: qsTr("Hunger")// + " " + amount
            amount: gameRoot.currentPet.statFood
            width: parent.width
        }

        TProgressBar
        {
            id: energyLabel
            label: qsTr("Energy")// + " " + amount
            amount: gameRoot.currentPet.statEnergy
            width: parent.width
        }

        TProgressBar
        {
            id: happinessLabel
            label: qsTr("Happy")// + " " + amount
            amount: gameRoot.currentPet.statHappy
            width: parent.width
        }
        TProgressBar
        {
            id: hygieneLabel
            label: qsTr("Clean")// + " " + amount
            amount: gameRoot.currentPet.statClean
            width: parent.width
        }
        TTextBitmap
        {
            id: sickLabel
            text: qsTr("Your pet is sick :(")
            visible: gameRoot.currentPet.sick
        }
    }

    Behavior on x {
        NumberAnimation{ easing.type: Easing.InOutQuad }
    }

}

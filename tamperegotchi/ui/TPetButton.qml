import QtQuick 2.0
Item{
    id: buttonRoot

    property int petIndex: 0

    width: 100
    height: 24

    property alias pressed: touchArea.pressed
    property string icon: ""
    property bool playSound: true

    signal clicked
    clip: true

    BorderImage {
        id: buttonBg
        source: touchArea.pressed? res("ui/button_pressed.png") : res("ui/button.png")
        anchors.fill: parent
        border.left: 2; border.top: touchArea.pressed? 3 : 2
        border.right: 2; border.bottom: touchArea.pressed? 2 : 3
    }

    Image
    {
        id: img
        source: icon
        y: (height != 0? 2 : 0) + (touchArea.pressed? 1 : 0)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    TTextBitmap
    {
        id: textItem
        text: gameRoot.pet(petIndex).petName.toUpperCase()
        anchors.centerIn: parent
        anchors.topMargin: 2
    }

    Item
    {
        clip: true
        width: 26
        height: 21
        x: 1
        y: touchArea.pressed? 2 : 1

        PetSprite
        {
            petIndex: buttonRoot.petIndex
            y: 0
            x: 0
        }
    }


    MouseArea
    {
        id: touchArea
        anchors.fill: parent
        onClicked: {buttonRoot.clicked(); if(playSound) clickSound.play();}
    }
}

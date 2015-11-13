import QtQuick 2.0

Item{
    id: buttonRoot

    implicitWidth: textItem.implicitWidth + 8
    implicitHeight: textItem.implicitHeight + 6 + img.height + (img.height != 0? 2 : 0)
    property alias pressed: point.pressed
    property string icon: ""
    property bool playSound: true

    signal clicked

    BorderImage {
        id: buttonBg
        source: point.pressed? res("ui/button_pressed.png") : res("ui/button.png")
        anchors.fill: parent
        border.left: 2; border.top: point.pressed? 3 : 2
        border.right: 2; border.bottom: point.pressed? 2 : 3
    }

    property alias text: textItem.text

    Image
    {
        id: img
        source: icon
        y: (height != 0? 2 : 0) + (pressed? 1 : 0)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    TTextBitmap
    {
        id: textItem
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: img.bottom
        anchors.topMargin: 3
    }

    MouseArea
    {
        id: point
        anchors.fill: parent
        onClicked: {buttonRoot.clicked(); if(playSound) clickSound.play();}
    }
}

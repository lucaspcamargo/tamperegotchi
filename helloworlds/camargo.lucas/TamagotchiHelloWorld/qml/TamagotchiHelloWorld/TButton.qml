import QtQuick 2.0

Item{
    width: textItem.implicitWidth + 8
    height: textItem.implicitHeight + 3
    signal clicked

    BorderImage {
        id: buttonBg
        source: mouseArea.pressed? "res/ui/button_pressed.png" : "res/ui/button.png"
        anchors.fill: parent
        border.left: 2; border.top: mouseArea.pressed? 3 : 2
        border.right: 2; border.bottom: mouseArea.pressed? 2 : 3
    }

    property alias text: textItem.text

    TTextBitmap
    {
        id: textItem
        anchors.centerIn: parent
        anchors.verticalCenterOffset: mouseArea.pressed ? 1 : 0
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}

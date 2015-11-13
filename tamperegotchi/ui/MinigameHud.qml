import QtQuick 2.0

Item
{
    id: hud
    anchors.fill: parent
    property alias message: msg.text

    Row
    {
        id: livesDisplay
        x: 2
        y: 1

        Repeater
        {
            model: minigameRoot.lives
            Image
            {
                source: res("games/generic/heart2.png")
            }
        }
    }

    TTextBitmap
    {
        anchors.right: parent.right
        anchors.rightMargin: 2
        y: 3
        text: (minigameRoot.score)
    }

    Image
    {
        source: res("games/generic/pause.png")
        anchors.right: parent.right
        anchors.rightMargin: 2
        y: 11
        MouseArea
        {
            anchors.fill: parent
            scale: 2.0
            onClicked:
            {
                hud.parent.pause()
            }
        }
    }

    TTextBitmap
    {
        id: msg
        text: ""
        anchors.centerIn: parent
    }

}

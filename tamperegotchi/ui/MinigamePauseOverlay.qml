import QtQuick 2.0

Rectangle {
    color: "#ccffffff"

    anchors.fill: parent
    visible: minigameRoot.paused

    width: 100
    height: 62

    MouseArea
    {
        anchors.fill: parent
        onClicked: minigameRoot.paused = false
    }

    Item
    {
        id: pauseIcon
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -15
        width: 12
        height: 16
        Rectangle
        {
            color: "black"
            height: parent.height
            width: 4
        }
        Rectangle
        {
            color: "black"
            height: parent.height
            width: 4
            anchors.right: parent.right
        }
    }

    TTextBitmap
    {
        id: pausedText
        text: qsTr("PAUSED")
        anchors.top: pauseIcon.bottom
        anchors.margins: 3
        anchors.horizontalCenter: parent.horizontalCenter
    }

    TButton
    {
        anchors.top: pausedText.bottom
        anchors.margins: 15
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Quit Game")
        onClicked: {screen.currentContent = "GameScreen"; cancelSound.play()}
        playSound: false

    }


}

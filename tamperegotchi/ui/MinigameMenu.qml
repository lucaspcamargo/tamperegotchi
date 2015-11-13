import QtQuick 2.0

BorderImage {

    id: menuScreen

    property int padding: 2
    x: padding
    y: gameScreen.currentModal == "game"? parent.height - 39 : parent.height

    source: res("ui/frame.png")
    width: parent.width-2*padding; height: 60
    border.left: 5; border.top: 5
    border.right: 5; border.bottom: 5

    MouseArea
    {
        id: blocker
        anchors.fill: parent
    }

    Row{
        id: inColumn
        anchors.fill: parent
        anchors.margins: 5
        spacing: 1

        TButton
        {
            id: appleButton
            text: qsTr("Space")
            icon: res("games/spaceshooter/icon.png")
            width: Math.floor((parent.width-2)/2)
            playSound: false
            onClicked: {
                if(gameScreen.currentAction != "" || gameRoot.currentPet.sleeping)
                {
                    cancelSound.play();
                    return;
                }

                clickSound.play();
                gameScreen.currentModal = "";
                screen.currentContent = "MinigameSpaceShooter2";

            }
        }

        TButton
        {
            id: cakeButton
            text: qsTr("JanKenPo")
            icon: res("sprites/miniGames/scissors.png")
            width: Math.floor((parent.width-2)/2)
            playSound: false
            onClicked: {
                if(gameScreen.currentAction != "" || gameRoot.currentPet.sick || gameRoot.currentPet.sleeping)
                {
                    cancelSound.play();
                    return;
                }

                clickSound.play();
                gameScreen.currentModal = "";
                screen.currentContent = "MinigameJanKenPo";
            }
        }
    }

    Behavior on y {
        NumberAnimation{ easing.type: Easing.InOutQuad }
    }

}

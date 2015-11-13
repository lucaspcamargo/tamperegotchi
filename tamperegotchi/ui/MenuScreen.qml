import QtQuick 2.0

BorderImage {

    id: menuScreen

    property int padding: 2
    x: gameScreen.currentModal == "menu"? padding : -width
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

    Grid{
        id: inColumn
        anchors.fill: parent
        anchors.margins: 5
        columnSpacing: 1
        rowSpacing: 1
        columns: 2

        TButton
        {
            id: feedButton
            text: qsTr("Feed")
            icon: res("sprites/food/apple.png")
            width: Math.floor((parent.width-2)/2)
            onClicked: {
                if(gameScreen.currentAction != "")
                    return;

                gameScreen.currentModal = "feed";
            }
        }

        TButton
        {
            id: cleanButton
            text: qsTr("Clean")
            icon: res("ui/menu-clean.png")
            width: parent.width-2-feedButton.width
            onClicked: {
                if(gameScreen.currentAction != "")
                    return;

                gameScreen.currentModal = "";
                gameScreen.currentAction = "clean";
            }
        }

        TButton
        {
            text: qsTr("Lights")
            icon: res("sprites/moon.png")
            onClicked: {
                gameScreen.currentModal = "";
                gameRoot.currentPet.envDark = ! gameRoot.currentPet.envDark;
            }
            width: feedButton.width
        }

        TButton
        {
            text: qsTr("Play")
            icon: res("ui/menu-games.png")
            playSound: false
            onClicked: {

              if( gameRoot.currentPet.sick || gameRoot.currentPet.sleeping )
              {
                  cancelSound.play();
                  return;
              }

              clickSound.play();

              gameScreen.currentModal = "game";
              console.log(mainScreenContent.source)
            }
            width: cleanButton.width
        }

        TButton
        {
            id: careButton
            text: qsTr("Medicine")
            icon: res("sprites/medicine/medicine_pill.png")
            width: feedButton.width
            playSound: false
            onClicked:
            {
                if(gameRoot.currentPet.sick && !gameRoot.currentPet.sleeping)
                {
                    clickSound.play();
                    gameScreen.currentModal = "";
                    gameScreen.currentAction = "remedy";
                }
                else
                {
                    cancelSound.play();
                }
            }
        }

        TButton
        {
            text: qsTr("Sauna")
            icon: res("ui/menu-lights.png")
            width: cleanButton.width
            playSound: false
            onClicked:
            {
                if(gameScreen.currentAction != "" || screen.reverse || gameRoot.currentPet.sick ||  gameRoot.currentPet.sleeping )
                {
                    cancelSound.play();
                    return;
                }

                clickSound.play();
                gameScreen.currentModal = "";
                gameScreen.currentAction = "sauna";
            }
        }



        TButton
        {
            text: qsTr("Leave")
            icon: res("ui/menu-exit.png")
            width: cleanButton.width
            playSound: false
            onClicked: {screen.currentContent = "MainScreen"; cancelSound.play()}
        }

    }

    Behavior on x {
        NumberAnimation{ easing.type: Easing.InOutQuad }
    }

}

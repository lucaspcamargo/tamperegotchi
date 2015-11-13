import QtQuick 2.0
import QtGraphicalEffects 1.0
Item {
    id: gameScreen
    anchors.fill: parent

    property string currentModal: ""
    property string currentAction: ""
    property string currentFood: "apple"

    property string idleAnimation: gameRoot.currentPet.sleeping? "sleep" : (gameRoot.currentPet.sick? "sick" : "idle")
    property string actionAnimation: ""

    PetSprite
    {
        id: petSprite
        wander: currentAction == "" && !gameRoot.currentPet.sleeping
        animation: actionAnimation != ""? actionAnimation : idleAnimation

        function center()
        {
            x = Math.round(gameScreen.width/2 - width / 2);
            y = Math.round(gameScreen.height/2 - height / 2);
        }
    }
/*
    DropShadow
    {
        anchors.fill: petSprite
        source: petSprite
        radius: 1
        color: "#80000000"
        samples: 16
        verticalOffset: 1

    }
*/
    SequentialAnimation
    {
        id: feedAnimation
        running: currentAction == "feed"
        ScriptAction
        {
            script: {
                petSprite.wander = false;
                petSprite.center();
                actionAnimation = "feed";
                feedSound.play();
                foodSprite.visible = true;
                foodSprite.restart();
            }
        }

        PauseAnimation { duration: 3980 }

        ScriptAction
        {
            script: {
                petSprite.wander = true;
                foodSprite.visible = false;
                actionAnimation = "";
                gameRoot.currentPet.statFood += (currentFood == "apple"? 0.4 : 0.2);
                if(currentFood == "cake") gameRoot.currentPet.statHappy += 0.2;
                currentAction = "";
            }
        }
    }


    AnimatedSprite
    {
        id: foodSprite

        width: 16
        height: 16

        anchors.bottom: petSprite.top
        anchors.left: petSprite.right

        visible: false

        source: res("sprites/food/"+currentFood+"_color_animation.png")
        frameDuration: 1000
        frameWidth: width
        frameHeight: height
        frameCount: 4


        interpolate: false
        running: false
        loops: 1
    }


    Item
    {
        id: cleaningClipper

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: cleaningSprite.bottom
        anchors.topMargin: -8

        clip: true

        AnimatedSprite
        {
            id: poopSprite
            width: 19
            height: 19

            x: 20
            y: parent.height - 20 - 19

            visible: gameRoot.currentPet.envPoop
            source: res("sprites/poo/poo3.png")

            frameDuration: 500
            frameWidth: 19
            frameHeight: 19
            frameCount: 2

            interpolate: false
            running: true
        }
    }



    AnimatedSprite{
        id: cleaningSprite
        width: parent.width
        height: 16
        y: -cleaningSprite.height
        source: res("sprites/cleaning/water.png")
        frameDuration: 300
        frameWidth: 24
        frameHeight: 16
        frameCount: 2
        interpolate: false
        running: true
    }

    SequentialAnimation
    {
        id: cleaningAnimation
        running: currentAction == "clean"

        PauseAnimation { duration: 200 }

        ScriptAction
        {
            script: { actionAnimation = "embarrassed"; }
        }

        PropertyAnimation
        {
            target: cleaningSprite
            property: "y"
            from: -cleaningSprite.height
            to: gameScreen.height
            duration: 1000
        }

        ScriptAction
        {
            script:
            {
                actionAnimation = "";
                cleaningSprite.y = -cleaningSprite.height;
                gameRoot.currentPet.envPoop = false;
                gameRoot.currentPet.statHappy += 0.1;
                gameRoot.currentPet.statClean = 1.0;
                currentAction = ""
            }
        }

    }

/* TODO
    AnimatedSprite
    {
        id: saunaSweat
    }
*/

    TButton
    {
        id: endSaunaButton
        visible: currentAction == "sauna"

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 2

        text: qsTr("End Sauna")
        onClicked:
        {
            currentAction = "";
            gameChrome.world = "koski";
            petSprite.wander = true;
            actionAnimation = "";

            gameRoot.currentPet.statHappy = 1;
            gameRoot.currentPet.statEnergy -= 0.1;
        }
    }

    AnimatedSprite
    {
        id: saunaBurner
        visible: currentAction == "sauna"
        x: -8
        y: parent.height - 58

        source: res("sprites/sauna/stove.png")
        width: 48
        height: 48
        frameCount: 2
        frameWidth: 48
        frameHeight: 48
        frameDuration: 500
    }

    SequentialAnimation
    {
        id: saunaAnimation
        running: currentAction == "sauna"

        //PauseAnimation { duration: 200 }

        ScriptAction
        {
            script: { gameChrome.world = "sauna"; petSprite.wander = false; petSprite.center(); actionAnimation = "embarrassed";}
        }

    }

    SequentialAnimation
    {
        id: remedyAnimation
        running: currentAction == "remedy"

        ScriptAction
        {
            script: {
                actionAnimation = "embarrassed";
                remedySprite.visible = true;
                remedySound.play();
            }
        }


        PauseAnimation {
            duration: 2000
        }

        ScriptAction
        {
            script: {
                actionAnimation = "";
                remedySprite.visible = false;
                gameRoot.currentPet.sick = false;
                currentAction = "";
            }
        }
    }

    Image
    {
        id: remedySprite
        visible: false

        source: res("sprites/medicine/medicine_pill.png")

        anchors.bottom: petSprite.top
        anchors.left: petSprite.right
    }

    Rectangle
    {
        id: nightCover
        color: "#000508"
        opacity: (screen.reverse? 1 : 0) * screen.colorfulness * 0.65
        anchors.fill: parent
    }

    Image
    {
        id: nightMoon
        y: 4
        x: parent.width - 20
        opacity: (screen.reverse? 1 : 0)
        Behavior on opacity { PropertyAnimation{ } }
        source: res("sprites/moon.png")
    }

    StatusScreen
    {
        id: statusScreen
    }

    MenuScreen
    {
        id: menuScreen
    }

    FeedMenu
    {
        id: feedMenu
    }

    MinigameMenu
    {
        id: minigameMenu
    }

    Timer
    {
        id: simTimer
        interval: 1000// / gameRoot.gameSettings.simulationSpeed
        repeat: true
        running: Qt.application.state == Qt.ApplicationActive

        onTriggered:
        {
            gameRoot.simulationStepper.step(gameRoot.gameSettings.simulationSpeed);
            gameRoot.savePets();
        }
    }

    Component.onCompleted:
    {
        menuButton.clicked.connect(menuBtnPressed);
        homeButton.clicked.connect(homeBtnPressed);
        statusButton.clicked.connect(statusBtnPressed);
        gameRoot.currentPet.envDarkChanged.connect(updateLights);
        updateLights();
    }

    Component.onDestruction:
    {
        menuButton.clicked.disconnect(menuBtnPressed);
        homeButton.clicked.disconnect(homeBtnPressed);
        statusButton.clicked.disconnect(statusBtnPressed);
    }

    function updateLights()
    {
        screen.reverse = gameRoot.currentPet.envDark;
    }

    function menuBtnPressed()
    {
        if(currentAction != "") return;
        currentModal = currentModal == "menu"? "" : "menu";
    }

    function homeBtnPressed()
    {
        currentModal = "";
    }

    function statusBtnPressed()
    {
        if(currentAction != "") return;
        currentModal = currentModal == "status"? "" : "status";
    }

    // SOUND EFFECTS

    TSoundEffect
    {
        id: feedSound
        source: res("sounds/eat.wav")
    }
    TSoundEffect
    {
        id: remedySound
        source: res("sounds/medicine.wav")
    }

}

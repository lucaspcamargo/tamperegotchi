import QtQuick 2.0
import QtMultimedia 5.0

Item {

    id: mainScreenRoot
    anchors.fill: parent

    property int selectedPet: -1

    Component.onCompleted: {

        // if we are here no pet should be selected
        gameRoot.setCurrentPet(-1);
    }

    Image
    {
        id: bg
        height: parent.height
        width: sourceSize.width * height / sourceSize.height
        property int xInt: 0
        x: xInt

        source: res("ui/panorama.jpg")

        PropertyAnimation
        {
            target: bg
            running: true
            loops: Animation.Infinite
            property: "xInt"
            from: 0
            to: -bg.width + bg.parent.width

            duration:40000
            easing.type: Easing.SineCurve
        }

    }

    Rectangle
    {
        id: bgCover
        color: "white"
        opacity: 0.25
        anchors.fill: parent
    }

    Item
    {
        id: firstScreen
        x: gameRoot.numPets > 0? 0 : width
        width: parent.width
        height: parent.height

        Behavior on x { PropertyAnimation{ easing.type: Easing.InOutQuad } }

        TTextBitmap
        {
            id: title
            text: qsTr("Select a Pet").toUpperCase()
            font: "sonic-hud-black"
            spacing: -2

            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Flickable
        {
            anchors.top: title.bottom
            anchors.topMargin: 8
            anchors.bottom: parent.bottom
            width: parent.width
            contentWidth: width
            contentHeight: buttonsColumn.implicitHeight
            pixelAligned: true

            clip: true

            Column
            {
                id: buttonsColumn
                width: parent.width - 8
                x: 4
                spacing: 2

                Repeater
                {
                    model: gameRoot.numPets

                    TPetButton
                    {
                        petIndex: index
                        width: parent.width

                        onClicked:
                        {
                            selectedPet = index;
                            firstScreen.x = -firstScreen.width
                        }
                    }
                }

                TButton
                {
                    text: qsTr("Create new pet :)")
                    width: parent.width
                    visible: gameRoot.numPets < 6
                    onClicked:
                    {
                        firstScreen.x = firstScreen.width;
                    }
                }

                TButton
                {
                    text: qsTr("Receive shared pet")
                    width: parent.width
                    visible: gameRoot.numPets < 6
                    onClicked:
                    {
                        receiveDialog.visible = true
                    }
                }

                TTextBitmap
                {
                    text: qsTr("Maximum of %1 pets reached").arg(6)
                    visible: gameRoot.numPets >= 6
                }

                TButton
                {
                    text: qsTr("How to Play")
                    width: parent.width
                    onClicked:
                    {
                        gameChrome.showHelp();
                    }
                }
            }
        }

    }

    Item
    {
        id: createPetScreen
        anchors.right: firstScreen.left
        width: parent.width
        height: parent.height

        TTextBitmap
        {
            id: createPetTitle
            text: qsTr("Create a Pet").toUpperCase()
            font: "sonic-hud-black"
            spacing: -2

            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item
        {
            id: genderSwitch

            width: 32
            height: 16

            anchors.top: newPetName.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 3

            property bool male: true

            Image
            {
                id: maleBtn
                source: res("ui/mars.png")
                opacity: genderSwitch.male? 1.0 : 0.5
            }

            Image
            {
                id: femaleBtn
                source: res("ui/venus.png")
                opacity: genderSwitch.male? 0.5 : 1.0
                x: 16
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    genderSwitch.male = ! genderSwitch.male;
                    clickSound.play();
                }
            }

        }

        TTextBitmap
        {
            id: newPetName
            text: "VILLE"
            font: "sonic-hud"
            spacing: -1

            y: 32
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle
            {
                id: cursor
                color: "black"
                width: 1
                height: parent.height
            }
        }

        TKeyboard
        {
            id: keyboard
            y: parent.height - 60

            onLetterPressed:
            {
                if(newPetName.text.length < 10)
                    newPetName.text += letter;
                clickSound.play();
            }

            onBackspacePressed:
            {
                newPetName.text = newPetName.text.slice(0, newPetName.text.length-1 );
                cancelSound.play();
            }
        }
        Row
        {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 3
            spacing: 2

            TButton
            {
                id: createButton
                text: qsTr("Create")
                playSound: false
                onClicked:
                {
                    if(newPetName.text.trim() != "")
                    {
                        gameRoot.createPet(newPetName.text);
                        gameRoot.pet(gameRoot.numPets-1).male = genderSwitch.male;
                        console.log(newPetName.text + ": " + gameRoot.pet(gameRoot.numPets-1).dataString())
                        firstScreen.x = 0;
                        clickSound.play();
                    }
                    else cancelSound.play();
                }
            }

            TButton
            {
                id: cancelButton
                text: qsTr("Cancel")
                playSound: false
                onClicked:
                {
                    firstScreen.x = 0
                    cancelSound.play()
                }
            }
        }
    }

    Item
    {
        id: selectedPetScreen
        anchors.left: firstScreen.right
        width: parent.width
        height: parent.height

        TTextBitmap
        {
            id: selectedPetTitle
            text: selectedPet >= 0? gameRoot.pet(selectedPet).petName.toUpperCase() : ""
            font: "sonic-hud-black"
            spacing: -2

            y: 5
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TTextBitmap
        {
            id: ageSex
            text: (gameRoot.pet(selectedPet).male? qsTr("Male") : qsTr("Female"))+qsTr(", %1:%2h old").arg(Math.floor(gameRoot.pet(selectedPet).age/60)).arg(gameRoot.pet(selectedPet).age%60)
            anchors.horizontalCenter: parent.horizontalCenter
            y: 18
        }

        PetSprite
        {
            id: petPreview
            petIndex: selectedPet
            y: 28
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column
        {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: petPreview.top
            anchors.topMargin: Math.max(32, petPreview.height)
            width: Math.max(Math.max(playButton.implicitWidth, shareButton.implicitWidth), abandonButton.implicitWidth)

            spacing: 2

            TButton
            {
                id: playButton
                text: qsTr("Play with this pet")
                playSound: false
                width: parent.width
                onClicked:
                {
                    gameRoot.setCurrentPet(selectedPet);
                    screen.currentContent = "GameScreen";
                }
            }

            TButton
            {
                id: shareButton
                text: qsTr("Share pet via code")
                playSound: false
                width: parent.width
                onClicked:
                {
                    shareDialog.visible = true;
                    shareDialog.petIndex = selectedPet;
                }
            }

            TButton
            {
                id: shareEmailButton
                text: qsTr("Share pet via email")
                playSound: false
                width: parent.width
                onClicked:
                {
                    var mailURL = "mailto:yourfriend@adress.com?" +
                            "subject="+ encodeURIComponent("I want to share my pet with you!") +
                            "&body=" + encodeURIComponent(makeEmailBody());
                    Qt.openUrlExternally(mailURL);

                }
            }

            TButton
            {
                id: abandonButton
                text: qsTr("Abandon your pet :(")
                playSound: false
                width: parent.width
                onClicked:
                {
                    var i = selectedPet;
                    selectedPet = -1;
                    gameRoot.deletePet(i);
                    firstScreen.x = 0;
                    cancelSound.play();
                }
            }
        }

        TButton
        {
            id: cancelPlay
            text: qsTr("Cancel")
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 3
            playSound: false
            onClicked:
            {
                firstScreen.x = 0
                cancelSound.play()
            }
        }
    }

    ShareDialog
    {
        id: shareDialog
        visible: false
        width: parent.width
        height: parent.height
    }

    ReceiveDialog
    {
        id: receiveDialog
        visible: false
        width: parent.width
        height: parent.height
    }


    TMusic
    {
        id: mainMenuMusic
        source: res("music/main-menu.mp3")
        volume: gameRoot.gameSettings.musicEnabled? 0.5 : 0.0
    }


    function makeEmailBody()
    {
        return "Hello! I really want to share my pet \""+ gameRoot.pet(selectedPet).petName+"\" with you :)\n"+
                "Please copy and paste this link in your browser:\n"+
                "http://tamperegotchi.io/?spc="+gameRoot.pet(selectedPet).dataString()+"\n"+
                "See you in TampereGotchi!";
    }
}

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtMultimedia 5.0

Rectangle {

    id: gameChrome
    color: "#d4dcd3" //lcd background color


    property string world: "koski"

    focus: true
    Keys.onBackPressed:
    {
        // capture and do nothing
        event.accepted = true
    }


    Component.onCompleted:
    {
        if(gameRoot.currentPetIndex() != -1)
        {
            header.y = 0;
            screen.currentContent = "GameScreen"
            titleScreen.destroy();
        }
    }

    Item
    {
        id: screenArea

        width: parent.width //Math.round(parent.width) * 0.99
        //anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top: parent.top
        //anchors.topMargin: header.height*0.9178744
        //anchors.bottom: buttonArea.top
        y: Math.round(0.9178744 * header.height)
        height: Math.round(parent.height - y - 0.91517857 * buttonArea.height)

        Image
        {
            id: worldBgMono
            source: res(("worlds/%1.jpg").arg(world))
            opacity: 0.2 * (1.0 - screen.colorfulness)
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            visible: screen.currentContent == "GameScreen"
        }

        LCDScreen {
            id: screen
            anchors.fill: parent

            property string currentContent: ""
            colorfulness: gameRoot.gameSettings.retroScreen? 0.0 : 1.0

            Behavior on colorfulness{ PropertyAnimation{} }
            Image
            {
                id: worldBgColor
                source: res(("worlds/%1.jpg").arg(world))
                opacity: 0.5 * screen.colorfulness
                fillMode: Image.PreserveAspectCrop
                anchors.fill: parent
            }


            Loader
            {
                id: mainScreenContent
                anchors.fill: parent
                source: ""
            }

            Rectangle
            {
                id: loadFader
                color: "black"
                anchors.fill: parent
            }

            SequentialAnimation
            {
                id: loadFaderAnimation

                PropertyAnimation
                {
                    target: loadFader
                    property: "opacity"
                    from: 0.0
                    to: 1.0
                    duration: 100
                }

                PauseAnimation { duration: 1 }

                ScriptAction
                {
                    script:
                    {
                        mainScreenContent.source = screen.currentContent == ""? "" : screen.currentContent+".qml";
                    }
                }

                PropertyAnimation
                {
                    target: loadFader
                    property: "opacity"
                    from: 1.0
                    to: 0.0
                }
            }

            onCurrentContentChanged:
            {
                loadFaderAnimation.running = true
            }
        }
    }

    SettingsScreen
    {
        id: configScreen

        width: parent.width
        height: parent.height - header.height*0.9 - buttonArea.height*0.9
        y: configBtn.y - height/2
        x: configBtn.x - width/2
        scale: configBtn.height / height
        opacity: 0.0

        Behavior on scale{PropertyAnimation{}}
        Behavior on x{PropertyAnimation{}}
        Behavior on y{PropertyAnimation{}}
        Behavior on opacity{PropertyAnimation{}}

        states:
        [
            State
            {
                name: "on"
                PropertyChanges {
                    target: configScreen
                    scale: 1.0
                    x: 0
                    opacity: 1.0
                    y: header.height*0.9
                }
            }
        ]
    }

    Image
    {
        id: buttonArea

        source: res("chrome/chrome-bottom.png")

        anchors.bottom: parent.bottom
        width: parent.width
        height: sourceSize.height * width/sourceSize.width

        smooth: true

        FrameButton
        {
            id: homeButton
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3.54
        }

        FrameButton
        {
            id: menuButton
            anchors.right: homeButton.left
            anchors.left: parent.left
        }

        FrameButton
        {
            id: statusButton
            anchors.left: homeButton.right
            anchors.right: parent.right
        }

        Rectangle
        {
            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: "#00000000";
                }
                GradientStop {
                    position: 1.00;
                    color: "#000000";
                }
            }

            anchors.fill: parent
            Behavior on opacity { PropertyAnimation{ } }
            opacity: screen.currentContent != "GameScreen" ? 1.0 : 0.0

            MouseArea
            {
                id: blocker
                anchors.fill: parent
                visible:  parent.opacity > 0
                onClicked:
                {
                    cancelSound.play()
                }
            }
        }
    }

    Image
    {
        id: header

        source: res("chrome/chrome-top.png")

        y: parent.height
        width: parent.width
        height: sourceSize.height * width/sourceSize.width

        Behavior on y {PropertyAnimation{duration: 600; easing.type: Easing.InOutQuad}}
        onYChanged: if(y == 0) titleScreen.destroy();

        Image
        {
            id: configBtn
            source: res("chrome/button-settings.png")
            width: height
            height: parent.height/3
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: parent.height / 4
            opacity: configScreen.state == "on" ? 1.0 : 0.5

            Behavior on opacity{PropertyAnimation{}}

            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    if(configScreen.state == "")
                    {
                        configScreen.state = "on";
                        clickSound.play();
                    } else {
                        configScreen.state = "";
                        cancelSound.play();
                    }
                }

                scale: 2
            }
        }


    }

    TitleScreen
    {
        id: titleScreen
    }


    // DEBUG STUFF

    Button
    {
        id: debugButton
        text: "Debug"
        checkable: true
        opacity: checked? 1.0: 0.02
        onCheckedChanged:
        {
            screen.debugEnabled = checked
        }
    }

    Column
    {
        id: debugColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: debugButton.bottom
        visible: debugButton.checked

        Row
        {
            id: debugRow

            Button
            {
                id: color
                text: "COLOR"
                onClicked: {
                    screen.colorfulness = 1.0 - screen.colorfulness ;
                }
            }
            Button
            {
                id: rev
                text: "REV"
                onClicked: {
                    screen.reverse = !screen.reverse;
                }
            }
        }

        TextField
        {
            id: screenDebugText
            enabled: false
            text: screen.pixelWidth + "x" + screen.pixelHeight + "\tminspan " + screen.minPixelSpan
            width: parent.width
            opacity: 1.0
        }

        Slider
        {
            width: parent.width
            onValueChanged: screen.minPixelSpan = 10 + 190 * value
        }
    }


    // GLOBAL SOUND EFFECTS

    TSoundEffect
    {
        id: clickSound
        source: res("ui/click.wav")
    }
    TSoundEffect
    {
        id: cancelSound
        source: res("ui/cancel.wav")
    }

    function showHelp()
    {
        var hsc = Qt.createComponent("HelpDialog.qml");
        hsc.createObject(gameChrome);

    }
}

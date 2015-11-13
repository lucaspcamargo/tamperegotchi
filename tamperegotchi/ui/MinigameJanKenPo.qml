//import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.1

Rectangle {

    anchors.fill: parent

    property int score;
    property string option;

    // Not showing the background for some reason.
    Image {
            id: background
            anchors.fill: parent
            source: res("worlds/mgamebg.jpg")
            fillMode: Image.PreserveAspectCrop
        }

//****************************************************

    TTextBitmap
    {
        text: "===== Jan-ken-gotchi! ====="
        anchors.top: parent.top
        anchors.topMargin: 10

        anchors.horizontalCenter: parent.horizontalCenter
    }
    TTextBitmap
    {
        text: "Please make your choice: "
        anchors.top: parent.top
        anchors.topMargin: 25

        anchors.horizontalCenter: parent.horizontalCenter
    }

    TButton
    {
        id: rock
        text: qsTr("Rock")
        icon: res("sprites/miniGames/rock.png")
        //width: parent.width-2-feedButton.width

        anchors.top: parent.top
        anchors.topMargin: 40

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -38

        onClicked: compare(text, generateMove())
    }

    TButton
    {
        id: paper
        text: qsTr("Paper")
        icon: res("sprites/miniGames/paper.png")
        //width: parent.width-2-feedButton.width

        anchors.top: parent.top
        anchors.topMargin: 40

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -9

        onClicked: compare(text, generateMove())
    }

    TButton
    {
        id: scissors
        text: qsTr("Scissors")
        icon: res("sprites/miniGames/scissors.png")
        //width: parent.width-2-feedButton.width

        anchors.top: parent.top
        anchors.topMargin: 40

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 28

        onClicked: compare(text, generateMove())
    }

    // **************************************************************
    // LUCAS Please check if this is okay and won't cause bugs
    TButton
    {
        id: endMiniGameButton
        //visible: currentAction == "sauna"

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 2

        text: qsTr("Stop Playing")
        onClicked:
        {
            //currentAction = "";
            //gameChrome.world = "koski";
            //petSprite.wander = true;
            //actionAnimation = "";

            screen.currentContent = (screen.currentContent == "MinigameJanKenPo" ? "GameScreen" : "MinigameJanKenPo");
            console.log(mainScreenContent.source)
        }
    }
// **************************************************************
    property string r: "Rock"
    property string p: "Paper"
    property string s: "Scissors"

    property var ai; // AI's choice
    property var userChoice // User's choice



    //MessageDialog { id: resultDialog; standardButtons: StandardButton.Ok; Label{ id: displayLabel } }


    function generateMove() {
        var AIChoice = Math.floor((Math.random() * 3) + 1);
        //display1("<br/>TEST: Randomly generated number: " + AIChoice + "<br/>");

        var AI;

        if (AIChoice == 1) { // We are checking the remainder after dividing by 3 so that we get 1, 2 or 3. Each of these numbers corresponds to either R, P or S. By default, %3 will give 0, 1 or 2 (since any remainder of 3 will just be a 1) so we add 1 to shift the answer for our purpose.
            AI = "Rock"; display1("Rock chosen by your pet");
        } // In this case, if the random number generated and divided by 3 gives a remainder of 1, then the AI's choice is "Rock".
        else if (AIChoice == 2) {
            AI = "Paper";
            display1("Paper chosen by your pet");
        }
        else if (AIChoice == 3) {
            AI = "Scissors";
            display1("Scissors chosen by your pet");
        }
        return AI; // Return the AI's choice so that we can use this to compare with the user's choice.
    }

    // This function will compare the possible combinations of the user and the computer and will decide who wins the match.
    property var compare: (function(choice1, choice2) {
        if (choice1 == r && choice2 == s)
            display2(choice1 + " wins!");
        else if (choice1 == r && choice2 == p)
            display2(choice2 + " wins!");
        else if (choice1 == p && choice2 == r)
            display2(choice1 + " wins!");
        else if (choice1 == p && choice2 == s)
            display2(choice2 + " wins!");
        else if (choice1 == s && choice2 == p)
            display2(choice1 + " wins!");
        else if (choice1 == s && choice2 == r)
            display2(choice2 + " wins!");
        else if ((choice1 == r && choice2 == r || (choice1 == p && choice2 == p) || (choice1 == s && choice2 == s)))
            display2("It's a tie!");
    })

    TTextBitmap
    {
        id: aiChoice

        anchors.top: parent.top
        anchors.topMargin: 80

        anchors.horizontalCenter: parent.horizontalCenter
    }
    TTextBitmap
    {
        id: results

        anchors.top: parent.top
        anchors.topMargin: 90

        anchors.horizontalCenter: parent.horizontalCenter
    }

    function display1(txt)
    {
        //displayLabel.text = txt;
        //resultDialog.visible = true;
        aiChoice.text = txt;
        aiChoice.visible = true;
    }
    function display2(txt)
    {
        //displayLabel.text = txt;
        //resultDialog.visible = true;
        results.text = txt;
        results.visible = true;
    }

}

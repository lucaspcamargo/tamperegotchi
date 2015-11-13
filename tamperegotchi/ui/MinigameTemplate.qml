import QtQuick 2.0
import QtQuick.Particles 2.0
import QtMultimedia 5.0

Rectangle {
    id: minigameRoot

    property string gameName: "generic"
    property string gameNameDisplay: qsTr("Untitled Game")
    property alias bgColor: minigameRoot.color

    property int score: 0
    property int lives: 3

    property string musicName: "main"

    property bool paused: false


    function gameRes(name) {return res("games/"+gameName+"/"+name)}

    TMusic
    {
        id: gameMusic
        source: musicName == ""? "" : gameRes("music-"+musicName+".mp3")
        volumeFactor: (minigameRoot.paused? 0.2 : 1.0)
    }

    Timer
    {
        id: gameFrame
        interval: 16
        repeat: true
        running: !minigameRoot.paused
        onTriggered:
        {
            _frameUpdate();
        }
    }

    Timer
    {
        id: happinessTimer
        interval: 1000
        repeat: true
        running: !minigameRoot.paused
        onTriggered:
        {
            gameRoot.currentPet.statHappy += [0.05, 0.03, 0.01][gameRoot.currentPet.stage + 1]
        }
    }

    function _startup()
    {

        configScreen.opened.connect(pause);
        //rootWindow.onMinimizedChanged.connect(pause);
        screen.reverse = false;

        startup();
    }

    function _frameUpdate()
    {
        frameUpdate();
    }

    function pause()
    {
        paused = true;
    }

    function _cleanup()
    {
        cleanup();
    }

    function overlap(ax1, ax2, ay1, ay2, bx1, bx2, by1, by2)
    {
        return !(ax1 > bx2 || bx1 > ax2 || ay1 > by2 || by1 > ay2);
    }

    Component.onCompleted: _startup()
    Component.onDestruction: _cleanup()
}

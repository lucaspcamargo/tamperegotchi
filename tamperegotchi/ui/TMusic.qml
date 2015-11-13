import QtQuick 2.0
import QtMultimedia 5.0
import QtQuick.Window 2.2

Audio
{
    property real volumeFactor: 1.0

    autoLoad: true
    autoPlay: true
    loops: Audio.Infinite
    volume: volumeFactor * (gameRoot.gameSettings.musicEnabled? 0.6 : 0.0 )
    Behavior on volume{ PropertyAnimation{ duration: 400 } }

    function changePauseState()
    {
        if(Qt.application.state == Qt.ApplicationActive)
            play();
        else
            pause();
    }

    Component.onCompleted:
    {
        Qt.application.onStateChanged.connect(changePauseState);
        changePauseState();
    }

    Component.onDestruction:
    {
        Qt.application.onStateChanged.disconnect(changePauseState);
    }
}

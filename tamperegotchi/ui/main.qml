import QtQuick 2.3
import QtQuick.Window 2.1

Window {
    id: rootWindow
    visible: true
    contentOrientation: Qt.PortraitOrientation
    visibility: Qt.platform.os == "windows" || Qt.platform.os == "linux" || Qt.platform.os == "osx" ? Window.Windowed : Window.FullScreen
    width: 1080 / 3
    height: 1920 / 3

    Component.onCompleted:
    {
        requestActivate();

        if(gameRoot.currentPetIndex() != -1)
        {
            loadingText.visible = true;
            gameScreenLoader.sourceComponent = gameScreenComponent;
        }else
        {
            devLogoFadeIn.running = true;
        }
    }

    function res(path)
    {
         if(Qt.platform.os == "android")
             return "assets:/res/" + path;
         else
             return cwd + "/res/" + path;
    }

    function petNameForType(type)
    {
        return ["generic", "devil", "cat", "snake", "bunny", "bear", "alien", "creature"][type];
    }

    Loader
    {
        id: gameScreenLoader
        anchors.fill: parent
        onStatusChanged: {
            if(status == Loader.Ready) {
                devLogo.destroy();
                faderUnfade.running = true;
            }
        }
    }

    Component
    {
        id: gameScreenComponent

        GameChrome
        {
            anchors.fill: parent
        }

    }

    Item
    {
        id: devLogo
        width: parent.width
        height: parent.height

        Rectangle
        {
            anchors.fill: parent
            color: "white"
        }

        Image
        {
            source: res("ui/splash-dev-logo.jpg")
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
    }

    Rectangle
    {
        id: fader
        color: "black"
        anchors.fill: parent
        visible: true
        property real speedFactor: 1

        SequentialAnimation
        {
            id: devLogoFadeIn
            running: false

            NumberAnimation { target: fader; property: "opacity"; duration: 500/fader.speedFactor; easing.type: Easing.InOutQuad; from: 1.0; to: 0.0 }
            NumberAnimation { target: fader; property: "opacity"; duration: 2000/fader.speedFactor; easing.type: Easing.InOutQuad; from: 0.0; to: 0.0 }

            ScriptAction { script: { loadingText.visible = true } }
            NumberAnimation { target: fader; property: "opacity"; duration: 500/fader.speedFactor; easing.type: Easing.InOutQuad; from: 0.0; to: 1.0 }

            ScriptAction { script: { gameScreenLoader.sourceComponent = gameScreenComponent } }

        }

        SequentialAnimation
        {
            id: faderUnfade
            running: false
            NumberAnimation { target: fader; property: "opacity"; duration: 500/fader.speedFactor; easing.type: Easing.InOutQuad; from: 1.0; to: 0.0 }
            ScriptAction { script: { fader.destroy() } }

        }

        Text
        {
          id: loadingText
          text: qsTr("Loading...")
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          anchors.margins: 20
          color: "white"
          visible: false
        }
    }

}

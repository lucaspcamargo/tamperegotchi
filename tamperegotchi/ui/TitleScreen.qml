import QtQuick 2.0
import QtMultimedia 5.0

Image
{
    id: titleScreen
    source: res("chrome/title-bg.jpg")

    width: parent.width
    height: parent.height

    fillMode: Image.PreserveAspectCrop
    anchors.bottom: header.top

    Image
    {
        id: title
        source: res("chrome/title.png")
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -0.05 * parent.height
        scale: parent.width / 1080.0

        PropertyAnimation
        {
            target: title
            running: true
            loops: Animation.Infinite
            property: "rotation"
            from: 3
            to: -4

            duration: 20000
            easing.type: Easing.SineCurve
        }


        PropertyAnimation
        {
            target: title
            running: true
            loops: Animation.Infinite
            property: "scale"
            from: parent.width / 1080.0
            to: 1.1 * parent.width / 1080.0

            duration: 5000
            easing.type: Easing.SineCurve
        }
    }

    Image
    {
        id: titleTouch
        source: res("chrome/title-touch.png")
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 0.15 * parent.height
        scale: 0.8 * parent.width / 1080.0

        PropertyAnimation
        {
            target: titleTouch
            running: true
            loops: Animation.Infinite
            property: "opacity"
            from: 0.5
            to: 1

            duration: 2000
            easing.type: Easing.SineCurve
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: {screen.currentContent = "MainScreen"; header.y = 0; startSound.play(); titleMusic.volume = 0.0;}
        //TODO Title Music Keeps Playing
    }

    TSoundEffect
    {
        id: startSound
        source: res("ui/gamestart.wav")
    }

    TMusic
    {
        id: titleMusic
        source: res("music/title.mp3")
    }

}

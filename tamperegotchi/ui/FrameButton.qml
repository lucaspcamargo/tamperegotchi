import QtQuick 2.0

MouseArea {

    anchors.bottom: parent.bottom
    height: parent.height
    width: parent.width/3

    Rectangle
    {
        id: highlight
        anchors.fill: parent

        opacity: 0.0
        Behavior on opacity{ NumberAnimation{duration: 100} }

        gradient: Gradient{ GradientStop { position: 0.0; color: "#00ffffff" }
            GradientStop { position: 1.0; color: "#ffffffff" }
        }

    }

    onPressed: {highlight.opacity = 0.2; clickSound.play();}
    onReleased: highlight.opacity = 0.0
}

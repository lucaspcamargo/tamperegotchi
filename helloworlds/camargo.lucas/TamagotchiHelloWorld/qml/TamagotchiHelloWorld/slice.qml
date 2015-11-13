import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    width: 100
    height: 62


    ParticleSystem {
        id: sys
        anchors.fill: parent

        ItemParticle
        {
            fade: false
            delegate: Component
            {
            Rectangle
            {
                width: 1
                height: 1
            }
        }
        }

        Emitter {
            emitRate: 20
            system: sys
            enabled: true
            x: parent.width / 2
            y: parent.height / 2
            width: 1
            height: 1
            velocity: AngleDirection { angleVariation: 360; magnitude: 50  }
            lifeSpan: 1000
        }

        Gravity {
            magnitude: 25
        }

        Wander {
            affectedParameter: Wander.Position
            xVariance: 200
            pace: 30
        }

    }


Rectangle{
    id: spinner
    width: Math.max(parent.width, parent.height) * 1.5
    height: 1
    anchors.centerIn: parent
    color: "white"
    //source: "qrc:///particleresources/star.png"

    SequentialAnimation
    {
        running: true
        loops: Animation.Infinite
        NumberAnimation { target: spinner; property: "rotation"; from: 0; duration: 2000; easing.type: Easing.Linear; to: 360 }
    }
}

Rectangle{
    id: spinner2
    width: Math.max(parent.width, parent.height) * 1.5
    height: 1
    anchors.centerIn: parent
    color: "white"
    //source: "qrc:///particleresources/star.png"

    SequentialAnimation
    {
        running: true
        loops: Animation.Infinite
        NumberAnimation { target: spinner2; property: "rotation"; from: 90; duration: 2000; easing.type: Easing.Linear; to: 450 }
    }
}

}

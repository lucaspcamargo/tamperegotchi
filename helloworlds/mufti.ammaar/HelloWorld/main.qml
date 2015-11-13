import QtQuick 2.3
import QtQuick.Window 2.2

Window {
    visible: true
    width: 360
    height: 360

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Qt.quit();
        }
    }

    /*Text {
        text: qsTr("Hello World")
        anchors.centerIn: parent
    }*/
    Text {
        text: qsTr("Additional line. Mao. MEOW! LOOK AT ME! I AM A LION SAILING ON THE SEAS OF FIRE! \n
Well, I should probably start with a brief story about myself. I was once a small child, weak, fumbling and inadequate to face the challenges and horros of this world. \n
I learnt from my cousin quickly that we both shared a common issue - attention deficit disorder, \n
where I would be talking about something but would totally forget about it because as 2 parallel lines cannot ever converge, we must accept that we are always going to be distinct beings. \n
Something like what Aristotle once told me back at the pond near Hercules' garden of muscular plant. \n
He told me,'Mao, you are like me - we both like rubber duckies.' At that moment I knew what I must do. \n
I headed for the safe house, took out the Carrera GT and went on a long drive towards Cote de Azur. \n
There, at the peak of the hill, I thought to myself, how vast this earth is and how I sometimes enjoy being the odd one out of the crowd. \n
How it is always nearly impossible to find that one special person, with whom I can spend few, key, valuable moments in a waltz of emotions. \n
All of this sprials down to naught when I realise that I must be strong. \n
A tear leaves my eye at exactly 40 degrees from the prime meridian, a real sign, I must say. \n
Brotherhood has never looked so beautiful. Now I realise how the small things in life matter. \n
Such as tying your hair, keeping is clean and healthy, enjoying the finer things in life. Painting your nails. \n
Looking at the sun and just squealing out in joy as the rays caress your cheeks and let you know that all will be all right. \n
I thus end this ode to the famous King of Salamanders, whose name I cannot recall as he was quite a tricky, invisible Iguana. \n
May you find your way, young child who has wasted several important moments reading this and may the Force be with you, \n
for it was never there to begin with.")
        anchors.centerIn: parent
    }
}

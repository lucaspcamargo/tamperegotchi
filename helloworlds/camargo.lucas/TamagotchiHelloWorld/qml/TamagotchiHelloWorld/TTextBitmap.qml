import QtQuick 2.0

Row {
    property string text: ""
    Repeater {
        model: text.length
        Image {
            source: "res/fonts/pixel7/" + text.charCodeAt(index) + ".png"
            smooth: false
            antialiasing: false
        }
    }
}

import QtQuick 2.0

Row {
    property string text: ""
    property string font: "pixel6"
    Repeater {
        model: text.length
        Image {
            source: res("fonts/"+font+"/" + text.charCodeAt(index) + ".png")
            smooth: false
            antialiasing: false
        }
    }
}

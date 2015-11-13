import QtQuick 2.0

Item {

    property string label: ""
    property real amount: 0.5

    width: 100
    height: 11



    TTextBitmap
    {
        id: textBitmap
        text: label
    }

    /*
    Rectangle
    {
        id: baseline
        height: 1
        color: "black"
        y: 5
        opacity: 0.5
        anchors.right: parent.right
        anchors.left: textBitmap.right
    }
    */

    Rectangle
    {
        id: cap1
        color: "black"
        width: 2
        height: 2
        y: 7
        x: 1
    }

    Rectangle
    {
        id: cap2
        color: "black"
        width: 1
        height: 3
        y: 7
        x: 2
    }


    Rectangle
    {
        id: cap3
        color: "black"
        width: 2
        height: 1
        y: 7
    }

    Rectangle
    {
        id: gauge
        width: (parent.width-6) * amount
        color: "#0044aa"
        height: 2
        y: 7
        x: 4

        //Behavior on width { PropertyAnimation {} }

        Rectangle
        {
            id: shine
            color: "white"
            height: 1
            width: parent.width
            opacity: 0.25
        }
    }
}

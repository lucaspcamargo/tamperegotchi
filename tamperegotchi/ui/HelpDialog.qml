import QtQuick 2.0

Rectangle {

    id: hs
    anchors.fill: parent
    color: "#80000000"

    MouseArea
    {
        anchors.fill: parent
        onClicked: parent.destroy()
    }

    Rectangle
    {
        id: rect
        color: "black"
        width: parent.width * 0.9
        height: parent.height - 0.1 * parent.width
        anchors.centerIn: parent


        Flickable
        {
            anchors.fill: parent
            contentHeight: col.height
            contentWidth: col.width
            clip: true

            Column
            {
                id: col
                width: rect.width


                Repeater
                {
                    model: 3

                    Image
                    {
                        source: res("help/page"+(index+1)+".png")
                        width: rect.width
                        height: sourceSize.height * width / sourceSize.width
                    }
                }
            }
        }

        Image
        {
            anchors.horizontalCenter: parent.right
            anchors.verticalCenter: parent.top

            source: res("help/close.png")
            scale: 0.1 * parent.width / 128

            MouseArea
            {
                scale: 2
                anchors.fill: parent
                onClicked: hs.destroy()
            }
        }
    }


}

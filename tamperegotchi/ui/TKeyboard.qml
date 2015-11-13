import QtQuick 2.0

Item
{
    id: keyboard
    width: parent.width
    height: column.height

    signal letterPressed(string letter)
    signal backspacePressed()
    property bool numeric: false

    Column
    {
        id: column
        width: parent.width
        Row
        {
            id: firstRow
            property string rowText: numeric? "789" : qsTr("QWERTYUIOP")
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater
            {
                model: firstRow.rowText.length
                MouseArea
                {
                    width: 10
                    height: 11

                    Rectangle
                    {
                        id: filling
                        anchors.fill: parent
                        anchors.margins: 1
                        opacity: parent.pressed? 1.0 : 0.5
                    }

                    TTextBitmap
                    {
                        text: firstRow.rowText.charAt(index)
                        anchors.centerIn: parent
                    }

                    onClicked: keyboard.letterPressed(firstRow.rowText.charAt(index))
                }
            }
        }

        Row
        {
            id: secondRow
            property string rowText: numeric? "456" : qsTr("ASDFGHJKL")
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater
            {
                model: secondRow.rowText.length
                MouseArea
                {
                    width: 10
                    height: 11

                    Rectangle
                    {
                        id: filling2
                        anchors.fill: parent
                        anchors.margins: 1
                        opacity: parent.pressed? 1.0 : 0.5
                    }

                    TTextBitmap
                    {
                        text: secondRow.rowText.charAt(index)
                        anchors.centerIn: parent
                    }

                    onClicked: keyboard.letterPressed(secondRow.rowText.charAt(index))
                }
            }
        }

        Row
        {
            id: thirdRow
            property string rowText: numeric? "123" : qsTr("ZXCVBNM")
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater
            {
                model: thirdRow.rowText.length
                MouseArea
                {
                    width: 10
                    height: 11

                    Rectangle
                    {
                        id: filling3
                        anchors.fill: parent
                        anchors.margins: 1
                        opacity: parent.pressed? 1.0 : 0.5
                    }

                    TTextBitmap
                    {
                        text: thirdRow.rowText.charAt(index)
                        anchors.centerIn: parent
                    }

                    onClicked: keyboard.letterPressed(thirdRow.rowText.charAt(index))
                }
            }
        }

        Row
        {
            id: fourthRow
            anchors.horizontalCenter: parent.horizontalCenter

                MouseArea
                {
                    width: numeric? 22: 28
                    height: 11

                    Rectangle
                    {
                        anchors.fill: parent
                        anchors.margins: 1
                        opacity: parent.pressed? 1.0 : 0.5
                    }

                    TTextBitmap
                    {
                        text: numeric? "0" : qsTr("Space")
                        anchors.centerIn: parent
                    }

                    onClicked: keyboard.letterPressed(numeric? "0" : " ")
                }

                MouseArea
                {
                    width: numeric? 10 : 15
                    height: 11

                    Rectangle
                    {
                        anchors.fill: parent
                        anchors.margins: 1
                        opacity: parent.pressed? 1.0 : 0.5
                    }

                    TTextBitmap
                    {
                        text: numeric? "<" : qsTr("<-")
                        anchors.centerIn: parent
                    }

                    onClicked: keyboard.backspacePressed()
                }

        }
    }
}


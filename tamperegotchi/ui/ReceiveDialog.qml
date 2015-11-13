import QtQuick 2.0

Item
{
    id: shareDialog
    opacity: visible? 1.0 : 0.0
    Behavior on opacity { PropertyAnimation{} }

    property string host: "http://tamperegotchi.sis.uta.fi"
    property string codeStr: ""

    function bail()
    {
        shareDialog.visible = false;
        cancelSound.play();
    }

    Rectangle
    {
        id: sharebg
        color: "black"
        anchors.fill: parent
        opacity: 0.75

        MouseArea
        {
            anchors.fill: parent
            onClicked: bail();
            visible: shareDialog.visible
        }
    }
    BorderImage {

        id: receiveFrame

        anchors.centerIn: parent

        source: res("ui/frame.png")
        width: parent.width * 0.8; height: Math.round(width*1.2)
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5

        MouseArea
        {
            id: blocker
            anchors.fill: parent
        }

        Column
        {
            y: 8
            anchors.centerIn: parent
            width: parent.width
            spacing: 2

            TTextBitmap
            {
                id: statusLabel
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Enter code:")
            }

            TTextBitmap
            {
                id: codeLabel
                anchors.horizontalCenter: parent.horizontalCenter
                text: codeStr == ""? " " : codeStr
            }


            TKeyboard
            {
                id: keyboard
                anchors.horizontalCenter: parent.horizontalCenter
                numeric: true
                onLetterPressed:
                {

                    if(codeStr.length < 5 && !(codeStr.length == 0 && letter == "0"))
                        codeStr += letter;
                    clickSound.play();
                }

                onBackspacePressed:
                {
                    codeStr = codeStr.slice(0, codeStr.length-1 )
                    cancelSound.play();
                }
            }

            TButton
            {
                id: checkButton
                text: qsTr("Check")
                anchors.horizontalCenter: parent.horizontalCenter
                visible: codeStr.length == 5
                onClicked:
                {
                    statusLabel.text = qsTr("Connecting...");

                    var req = new XMLHttpRequest();
                    req.onreadystatechange = function()
                    {
                        if (req.readyState == XMLHttpRequest.DONE)
                        {
                            if( req.status == 200 ) // did not fail
                            {
                                var dataText = req.responseText.trim();
                                console.log("PET DATA: "+ dataText);
                                gameRoot.addDownloadedPet(dataText);
                                statusLabel.text = qsTr("SUCCESS!");
                            }else
                            {
                                statusLabel.text = qsTr("Failed to connect :(");
                            }
                        }
                    };

                    req.open("GET", host+"/data/" + codeStr);
                    req.send();
                }
            }

        }
    }
}

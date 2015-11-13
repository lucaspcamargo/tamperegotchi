import QtQuick 2.0

Item
{
    id: shareDialog
    opacity: visible? 1.0 : 0.0
    Behavior on opacity { PropertyAnimation{} }

    property string host: "http://tamperegotchi.sis.uta.fi"
    property int petIndex: -1
    property int code: -1

    onPetIndexChanged:
    {
        statusLabel.text = qsTr("Connecting...");

        if(petIndex != -1)
        {
            var req = new XMLHttpRequest();
            req.onreadystatechange = function()
            {
                if (req.readyState == XMLHttpRequest.DONE)
                {
                    console.log("Headers -->");
                    console.log(req.getAllResponseHeaders());
                    console.log("Last modified -->");
                    console.log(req.getResponseHeader("Last-Modified"));
                    console.log("CONTENT -->");
                    console.log(req.responseText);
                    if( req.responseText.indexOf("OK") != -1 ) // did not fail
                    {
                        code = Number(req.responseText.slice(0, req.responseText.indexOf("\n")));
                        statusLabel.text = qsTr("Pet sharing code:");
                    }
                }
            };

            req.open("GET", host+"/?data=" + gameRoot.pet(petIndex).dataString());
            req.send();
        }
    }

    function bail()
    {
        shareDialog.visible = false;
        cancelSound.play();

        //send delete request
        if(code != -1)
        {
            var req = new XMLHttpRequest();
            req.open("GET", host+"/?delete=" + code);
            req.send();
            code = -1
        }

        petIndex = -1
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

        id: shareFrame

        anchors.centerIn: parent

        source: res("ui/frame.png")
        width: parent.width * 0.8; height: width
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5

        Column
        {
            anchors.centerIn: parent
            width: parent.width
            spacing: 2

            TTextBitmap
            {
                id: statusLabel
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TTextBitmap
            {
                id: codeLabel
                visible: code != -1
                anchors.horizontalCenter: parent.horizontalCenter
                text: code
            }
        }
    }
}

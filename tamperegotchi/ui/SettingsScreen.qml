import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

Rectangle {

    id: settingsScreen

    signal opened

    onStateChanged: {
        if(state == "on") opened()
    }

    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#333333";
        }
        GradientStop {
            position: 1.00;
            color: "#070707";
        }
    }

    MouseArea
    {
        // does nothing, prevents interaction with what's underneath
        anchors.fill: parent
    }

    Column
    {
        anchors.fill: parent
        anchors.margins: parent.width / 20
        spacing: parent.width / 30

        Text
        {
            text: qsTr("Settings")
            color: "white"
            font.pixelSize: parent.width / 10
            font.weight: Font.Light
        }

        Item
        {
            width: parent.width
            height: parent.width / 6

            Text
            {
                font.pixelSize: parent.height / 3
                text: qsTr("Sound Effects")
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }

            Switch
            {
                Component.onCompleted: checked = gameRoot.gameSettings.sfxEnabled
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: gameRoot.gameSettings.sfxEnabled = checked
            }
        }

        Item
        {
            width: parent.width
            height: parent.width / 6

            Text
            {
                font.pixelSize: parent.height / 3
                text: qsTr("Music")
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }

            Switch
            {
                Component.onCompleted: checked = gameRoot.gameSettings.musicEnabled
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: gameRoot.gameSettings.musicEnabled = checked
            }
        }

        Item
        {
            width: parent.width
            height: parent.width / 6

            Text
            {
                font.pixelSize: parent.height / 3
                text: qsTr("Retro Screen")
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }

            Switch
            {
                Component.onCompleted: checked = gameRoot.gameSettings.retroScreen
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: gameRoot.gameSettings.retroScreen = checked
            }
        }

        Item
        {
            width: parent.width
            height: parent.width / 6

            Text
            {
                font.pixelSize: parent.height / 3
                text: qsTr("Speed: %1").arg(speedSlider.value)
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }

            Slider
            {
                id: speedSlider
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * 0.6
                minimumValue: 1
                maximumValue: 60
                stepSize: 1

                value: gameRoot.gameSettings.simulationSpeed

                onValueChanged: gameRoot.gameSettings.simulationSpeed = value
            }
        }

        Item
        {
            visible: false
            width: parent.width
            height: parent.width / 6

            Text
            {
                font.pixelSize: parent.height / 3
                text: qsTr("LcdColor")
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
            }

            Button
            {
                id: colorButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {colorDialog.visible = true}

            }
        }

        Button
        {
            text: qsTr("Close")
            width: parent.width
            onClicked:
            {
                cancelSound.play();
                settingsScreen.state = "";
            }
        }
    }

    ColorDialog {
        id: colorDialog
        title: qsTr("Please choose a color for the LCD")
        color: gameChrome.color
        visible: false

        onAccepted: {
            gameChrome.color = colorDialog.color;
        }

    }

}

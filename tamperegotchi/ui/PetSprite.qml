import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: petRoot
    property int petIndex: gameRoot.currentPetIndex()

    property bool wander: false
    property real hue1: gameRoot.pet(petIndex).hue1
    property real hue2: gameRoot.pet(petIndex).hue2

    property string petTypeName: gameRoot.pet(petIndex).graphics.getPetTypeName()
    property string animation: "idle"


    width: gameRoot.pet(petIndex).graphics.spriteWidth
    height: gameRoot.pet(petIndex).graphics.spriteHeight

    x: Math.round(parent.width/2 - width/2)
    y: Math.round(parent.height/2 - height/2)

    // the sprite itself - color1

    AnimatedSprite
    {
        id: sprite1
        source: res("pets/"+petTypeName+"/"+gameRoot.pet(petIndex).graphics.getFileForAnimation(animation)+".png")
        frameWidth: petRoot.width
        frameHeight: petRoot.height
        frameX: gameRoot.pet(petIndex).graphics.getOffsetForAnimation(animation)
        frameDuration: gameRoot.pet(petIndex).graphics.getSpeedForAnimation(animation)
        frameCount: gameRoot.pet(petIndex).graphics.getFrameCountForAnimation(animation)

        anchors.fill: parent

        interpolate: false
        running: true
    }

    Colorize
    {
        id: colorize1
        anchors.fill: parent
        source: sprite1
        hue: hue1
    }

    Timer
    {
        interval: 750
        repeat: true
        running: wander
        onTriggered:
        {
            // funny
            //interval = 1;

            // move pet to a random direction
            var choice = Math.floor((Math.random() * 6)) + 1;
            if(choice == 1) petRoot.x = petRoot.x+1;
            if(choice == 2) petRoot.x = petRoot.x-1;
            if(choice == 3) petRoot.y = petRoot.y+1;
            if(choice == 4) petRoot.y = petRoot.y-1;

            // keep it inside bounds
            if(petRoot.x < screen.pixelWidth*0.25) petRoot.x = Math.ceil(screen.pixelWidth*0.25);
            if(petRoot.x > screen.pixelWidth*0.75 - petRoot.width) petRoot.x = Math.floor(screen.pixelWidth*0.25) - petRoot.width;
            if(petRoot.y < screen.pixelHeight*0.5) petRoot.x = Math.ceil(screen.pixelHeight*0.25); // .5 here because I want the pet down
            if(petRoot.y > screen.pixelHeight*0.75 - petRoot.height) petRoot.y = Math.floor(screen.pixelHeight * 0.75) - petRoot.height;

        }
    }
}

import QtQuick 2.0
import QtQuick.Particles 2.0
import QtMultimedia 5.0

Item {
    id: minigameRoot

    property int score: 0
    property int lives: 3

    property bool paused: false

    ParticleSystem
    {
        id: starfield
        anchors.fill: parent
        running: true

        ItemParticle
        {
            id: starParticle
            fade: false
            delegate: Component{
                Rectangle{
                    width: 1
                    height: 1
                    opacity: Math.random()*0.15 + 0.4
                    color: "black"
                }
            }
        }

        Emitter
        {
            //system: starfield
            width: parent.width
            height: 1
            emitRate: 30
            enabled: true
            velocity: AngleDirection { angle: 90; angleVariation: 0; magnitude: 100; magnitudeVariation: 50;  }
            lifeSpan: 3000
        }
    }

    function gameRes(name) {return res("games/spaceshooter/"+name)}

    SoundEffect
    {
        id: shootSound
        source: gameRes("shoot.wav")
    }
    SoundEffect
    {
        id: explodeSound
        source: gameRes("explode.wav")
    }
    SoundEffect
    {
        id: explode2Sound
        source: gameRes("explode2.wav")
    }
    SoundEffect
    {
        id: powerupSound
        source: gameRes("powerup.wav")
    }
    SoundEffect
    {
        id: dieSound
        source: gameRes("die.wav")
    }

    Audio
    {
        id: gameMusic
        autoLoad: true
        autoPlay: true
        loops: Audio.Infinite
        source: gameRes("music-main.m4a")
        volume: gameRoot.gameSettings.musicEnabled? 0.8 : 0.0
        Behavior on volume{ PropertyAnimation{ duration: 400 } }
    }

    Item
    {
        id: ship
        width: 16
        height: 16

        property int shootCooldown: 7
        property int shootHeat: 0

        PetSprite
        {
            wander: false
        }
        y: parent.height - 30
        x: Math.round( minigameRoot.width/2 - width/2)
    }

    Item
    {
        id: bulletsLayer
        anchors.fill: parent

        Component
        {
            id: bulletComponent
            Rectangle
            {
                id: someBullet
                color: "black"
                width: 2
                height: 2

                property int velX: 0
                property int velY: -2

                function update()
                {
                    x += velX;
                    y += velY;

                    if(y < -height) destroy();

                    var enemyFound = enemiesLayer.childAt(x, y);
                    if(enemyFound)
                    {
                        enemyFound.destroyEnemy();
                        destroy();
                    }

                }
            }
        }
    }

    Item
    {
        id: enemiesLayer
        anchors.fill: parent

        Component
        {
            id: enemyComponent
            SpriteSequence
            {
                id: anEnemy
                width: 8
                height: 8
                interpolate: false

                Sprite
                {
                    source: gameRes("enemy"+Math.round(Math.random() + 1)+".png")
                    frameHeight: 8
                    frameWidth: 8
                    frameCount: 4
                    frameDuration: 200
                }

                function update()
                {

                }

                function destroyEnemy()
                {
                    score += 100;
                    destroy();

                    if(Math.random() > 0.5)
                        explodeSound.play();
                    else explode2Sound.play();
                    // TODO EFFECTS
                }
            }
        }
    }

    MinigameHud
    {

    }

    TButton
    {
        id: leftBtn
        text: "<"
        anchors.bottom: parent.bottom
        width: Math.round((parent.width -4) / 3)
        x: 1
        playSound: false
    }

    TButton
    {
        id: rightBtn
        text: ">"
        anchors.bottom: parent.bottom
        anchors.rightMargin: 1
        anchors.right: parent.right
        width: Math.round((parent.width-4) / 3)
        playSound: false
    }

    TButton
    {
        id: fireBtn
        text: qsTr("FIRE")
        anchors.bottom: parent.bottom
        anchors.rightMargin: 1
        anchors.right: rightBtn.left
        anchors.leftMargin: 1
        anchors.left: leftBtn.right
        playSound: false
    }

    MinigamePauseOverlay
    {

    }


    Timer
    {
        id: gameFrame
        interval: 16
        repeat: true
        running: !minigameRoot.paused
        onTriggered:
        {
            frameUpdate();
        }
    }

    function startup()
    {
        //screen.reverse = true;

        // CREATE SOME ENEMIES

        for(var i = 0; i < 7; i ++)
        {
            var enemy = enemyComponent.createObject(enemiesLayer);
            enemy.x = 3 + i * 10;
            enemy.y = 20;
        }
        for(var i = 0; i < 7; i ++)
        {
            var enemy = enemyComponent.createObject(enemiesLayer);
            enemy.x = 6 + i * 10;
            enemy.y = 30;
        }

        configScreen.opened.connect(pause);
    }



    function frameUpdate()
    {
        // move the ship
        if(leftBtn.pressed) ship.x -= 1;
        if(rightBtn.pressed) ship.x += 1;
        // TODO BOUNDS

        // move the bullets
        var l = bulletsLayer.children.length;
        for(var i = 0; i < l; i ++)
        {
            bulletsLayer.children[i].update();
        }

        // cool off the ship or fire if player wants
        if(ship.shootHeat > 0)
        {
            ship.shootHeat--;
        }else
        {
            if(fireBtn.pressed)
            {
                ship.shootHeat = ship.shootCooldown;

                // create shot
                var bullet = bulletComponent.createObject( bulletsLayer );
                bullet.y = ship.y + 5;
                bullet.x = ship.x + ship.width/2 - 1;

                // play sound
                if(!shootSound.playing)shootSound.play();

            }
        }
    }

    function pause()
    {
        paused = true;
    }

    function cleanup()
    {

        //screen.reverse = false;
    }

    Component.onCompleted: startup()
    Component.onDestruction: cleanup()
}

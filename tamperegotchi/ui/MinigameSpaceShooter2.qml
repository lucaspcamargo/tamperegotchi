import QtQuick 2.0
import QtQuick.Particles 2.0
import QtSensors 5.3

MinigameTemplate {
    id: minigameRoot

    gameName: "spaceshooter"
    gameNameDisplay: qsTr("Space Shooter")

    bgColor: "transparent"
    lives: 3

    Image
    {
        //visible: screen.colorfulness == 1.0
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: res("ui/main-bg.png")
    }

    /*
    ParticleSystem
    {
        id: starfield
        anchors.fill: parent
        running: true
        paused: minigameRoot.paused

        ItemParticle
        {
            id: starParticle
            delegate: Component
            {
            Rectangle
            {
                width: 1
                height: 1
                color: "white"
            }

            }
        }

        Emitter
        {
            width: parent.width
            height: 1
            emitRate: 15
            enabled: !minigameRoot.paused
            velocity: AngleDirection { angle: 90; angleVariation: 0; magnitude: 150; magnitudeVariation: 30;  }
            lifeSpan: 1500
            startTime: 2000
            size: 1
        }
    }
*/
    TSoundEffect
    {
        id: shootSound
        source: gameRes("shoot.wav")
    }

    TSoundEffect
    {
        id: enemyShootSound
        source: gameRes("shoot-enemy.wav")
    }

    TSoundEffect
    {
        id: explodeSound
        source: gameRes("explode.wav")
    }

    TSoundEffect
    {
        id: explode2Sound
        source: gameRes("explode2.wav")
    }

    TSoundEffect
    {
        id: powerupSound
        source: gameRes("powerup.wav")
    }

    TSoundEffect
    {
        id: dieSound
        source: gameRes("die.wav")
    }

    Item
    {
        id: shipLayer
        anchors.fill: parent
        Item
        {
            id: ship
            width: 16
            height: 16

            property int shootCooldown: 15
            property int shootHeat: 0
            property bool dead: false
            property bool invincible: false
            property int laserShots: 0


            AnimatedSprite
            {
                id: shipSprite
                source: res("games/spaceships/"+petNameForType(gameRoot.currentPet.type)+"_ship.png")
                frameWidth: 16
                frameHeight: 16
                frameCount: 2
                width: 16
                height: 16
                frameDuration: 100
                interpolate: false
                visible: !ship.dead

                Image
                {
                    source: gameRes("powerup-laser.png")
                    opacity: ship.laserShots/3.0
                    anchors.centerIn: parent
                }

            }

            y: parent.height - 29
            x: Math.round( minigameRoot.width/2 - width/2)

            SequentialAnimation
            {
                id: deathAnimation
                ScriptAction
                {
                    script:
                    {
                        ship.dead = true;
                        dieSound.play();
//                        if(explosionEmitter)
//                        {
//                            explosionEmitter.x = ship.x+4;
//                            explosionEmitter.y = ship.y+4;
//                            nEmitter.pulse(10);
//                        }
                        minigameRoot.lives -= 1;
                    }
                }

                PauseAnimation { duration: 3000 }

                ScriptAction
                {
                    script:
                    {
                        if(minigameRoot.lives > 0)
                        {
                            ship.resetShip();
                        }
                        else
                        {
                            hud.message = qsTr("Game Over");
                        }
                    }
                }
            }

            SequentialAnimation
            {
                id: invincibleAnimation
                running: ship.invincible
                PropertyAnimation
                {
                    target: shipSprite
                    property: "opacity"
                    from: 0.5
                    to: 1.0
                    easing.type: Easing.SineCurve
                    loops: 15
                    duration: 200
                }

                ScriptAction
                {
                    script: {shipSprite.opacity = 1.0; ship.invincible = false;}
                }
            }

            function takeDamage()
            {
                if(!(dead || invincible))
                {
                    deathAnimation.start();
                }
            }

            function resetShip()
            {
                x = Math.round((parent.width - width)/2);
                dead = false;
                invincible = true;
                ship.laserShots = 0;
            }

            Component.onCompleted: resetShip();
        }

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
                color: screen.colorfulness == 1.0? (velY < 0? "orange": "red") : "black"
                width: 2
                height: 2

                property int velX: 0
                property int velY: -2
                property bool pierce: false

                function update()
                {
                    x += velX;
                    y += velY;

                    if(y < -height) destroy();
                    if(y > minigameRoot.height) destroy();

                    if(velY < 0)
                    {
                        //going up, test enemies
                        var l = enemiesLayer.children.length;
                        for(var i = 0; i < l; i ++)
                        {
                            var enemy = enemiesLayer.children[i];
                            if(overlap(x, x+width, y, y+height, enemy.x, enemy.x + enemy.width, enemy.y, enemy.y + enemy.height))
                            {
                                enemy.takeDamage();
                                if(!pierce) destroy();
                            }
                        }
                    }else
                    {
                        //going down, test player
                        if(overlap(x, x+width, y, y+height, ship.x, ship.x + ship.width, ship.y, ship.y + ship.height))
                        {
                            ship.takeDamage();
                            if(!pierce) destroy();
                        }
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
            AnimatedSprite
            {
                id: anEnemy
                width: 8
                height: 8
                interpolate: false
                running: !minigameRoot.paused

                source: gameRes("enemy"+Math.round(Math.random() + 1)+".png")
                frameHeight: 8
                frameWidth: 8
                frameCount: 4
                frameDuration: 200

                function update()
                {
                    // check collision with player
                    if(!ship.dead && overlap(x, x+width, y, y+height, ship.x, ship.x + ship.width, ship.y, ship.y + ship.height))
                    {
                        takeDamage();
                        ship.takeDamage();
                        return;
                    }

                    //movement
                    if(Math.random() < 0.1)
                    {
                        y += 1;

                        if(y > minigameRoot.height)
                            destroy();
                    }


                    if( y > 0 && Math.random() < 0.003 )
                    {
                        // create shot
                        var bullet = bulletComponent.createObject( bulletsLayer );
                        bullet.y = y + 8;
                        bullet.x = x + 3;
                        bullet.velY = 1

                        enemyShootSound.play();
                    }

                }

                function takeDamage()
                {
                    score += 100;
                    destroy();

                    if(Math.random() > 0.5)
                        explodeSound.play();
                    else explode2Sound.play();

//                    if(explosionEmitter)
//                    {
//                        explosionEmitter.x = x;
//                        explosionEmitter.y = y;
//                        explosionEmitter.pulse(10);
//                    }

                    // create powerup
                    if(Math.random() < 0.05)
                    {
                        var powerup = powerupComponent.createObject( powerupsLayer );
                        powerup.y = y;
                        powerup.x = x - 2;
                    }
                }
            }
        }
    }

    Item
    {
        id: powerupsLayer
        anchors.fill: parent


        Component
        {
            id: powerupComponent
            Image
            {
                id: aPowerup

                property int type: Math.floor(Math.random() * 3)
                source: gameRes("powerup-"+["life", "laser", "boom"][type]+".png")

                function update()
                {
                    // check collision with player
                    if(!ship.dead && overlap(x, x+width, y, y+height, ship.x, ship.x + ship.width, ship.y, ship.y + ship.height))
                    {
                        powerupSound.play();

                        if(type == 0) //life
                            minigameRoot.lives += 1;

                        if(type == 1) //laser
                        {
                            ship.laserShots = 3;
                        }

                        if(type == 2) //boom
                        {
                            boomFlashAnimation.running = true;
                            var l = enemiesLayer.children.length;
                            for(var i = 0; i < l; i ++)
                            {
                                enemiesLayer.children[i].takeDamage();
                            }

                        }

                        destroy();
                        return;
                    }

                    //movement
                    y += 1;
                    if(y > minigameRoot.height)
                        destroy();

                }

                function takeDamage()
                {
                    score += 100;
                    destroy();

                    if(Math.random() > 0.5)
                        explodeSound.play();
                    else explode2Sound.play();

                    if(explosionEmitter)
                    {
                        explosionEmitter.x = x;
                        explosionEmitter.y = y;
                        explosionEmitter.pulse(10);
                    }
                }
            }
        }
    }
    /*
    ParticleSystem
    {
        id: explosionField
        anchors.fill: parent
        running: true
        paused: minigameRoot.paused

        ImageParticle
        {
            id: explosionParticle
            source: gameRes("particle-px.png")
            entryEffect: ImageParticle.None
            spritesInterpolate: false
            opacity: 0.5
            colorTable: gameRes("particle-color-table.png")
        }

        Emitter
        {
            id: explosionEmitter
            width: 8
            height: 8
            emitRate: 20 * 100
            enabled: false
            velocity: AngleDirection { angle: 0; angleVariation: 360; magnitude: 100; magnitudeVariation: 30;  }
            lifeSpan: 200
            lifeSpanVariation: 100
            size: 3
        }
    }
*/

    TMultitouchButton
    {
        id: leftBtn
        text: "<"
        anchors.bottom: parent.bottom
        width: Math.round((parent.width -4) / 3)
        x: 1
        playSound: false
    }

    TMultitouchButton
    {
        id: fireBtn
        text: qsTr("FIRE")
        anchors.bottom: parent.bottom
        anchors.rightMargin: 1
        anchors.right: parent.right
        width: Math.round((parent.width-4) / 3)
        playSound: false
    }

    TMultitouchButton
    {
        id: rightBtn
        text: ">"
        anchors.bottom: parent.bottom
        anchors.rightMargin: 1
        anchors.right: fireBtn.left
        anchors.leftMargin: 1
        anchors.left: leftBtn.right
        playSound: false
    }

    Rectangle
    {
        id: boomFlash
        color: "lightyellow"
        opacity: 0.0
        anchors.fill: parent

        PropertyAnimation
        {
            id: boomFlashAnimation
            running: false
            loops: 3
            target: boomFlash
            property: "opacity"
            duration: 100
            easing.type: Easing.SineCurve
            from: 0.0
            to: 1.0
        }
    }

    MinigameHud
    {
        id: hud
    }

    MinigamePauseOverlay
    {

    }

    function startup()
    {
        //screen.reverse = true;

        // CREATE SOME ENEMIES

        for(var i = 0; i < 6; i ++)
        {
            var enemy = enemyComponent.createObject(enemiesLayer);
            enemy.x = 3 + i * 20;
            enemy.y = 20;
        }

    }

    function frameUpdate()
    {
        if(!ship.dead)
        {
            // move the ship
            if(leftBtn.pressed) ship.x -= 1;
            if(rightBtn.pressed) ship.x += 1;

            if(ship.x < 0) ship.x = 0;
            if(ship.x > width - ship.width) ship.x = width - ship.width;

            if(ship.y > parent.height) destroy();
        }

        // update the enemies
        var l = enemiesLayer.children.length;
        for(var i = 0; i < l; i ++)
        {
            enemiesLayer.children[i].update();
        }

        // update the bullets
        l = bulletsLayer.children.length;
        for(i = 0; i < l; i ++)
        {
            bulletsLayer.children[i].update();
        }

        // update the powerups
        l = powerupsLayer.children.length;
        for(i = 0; i < l; i ++)
        {
            powerupsLayer.children[i].update();
        }

        // cool off the ship or fire if player wants
        if(ship.shootHeat > 0)
        {
            ship.shootHeat--;
        }else
        {
            if(fireBtn.pressed && !ship.dead)
            {
                ship.shootHeat = ship.shootCooldown;

                // create shot
                var bullet = bulletComponent.createObject( bulletsLayer );
                bullet.y = ship.y;
                bullet.x = ship.x + ship.width/2 - 1;

                if(ship.laserShots > 0)
                {
                    ship.laserShots--;
                    bullet.y = ship.y - 4;
                    bullet.x = ship.x + ship.width/2 - 4;

                    bullet.width = 8;
                    bullet.height = 20;
                    bullet.color = "lime";
                    bullet.radius = 4;
                    bullet.pierce = true;
                    bullet.border.color = "green";
                    bullet.velY = -4;
                }

                // play sound
                if(!shootSound.playing)shootSound.play();

            }
        }

        //create new enemies
        if( (!ship.dead) && (Math.random() < 0.015) && (enemiesLayer.children.length < 20) )
        {
            //create new enemy
            var enemy = enemyComponent.createObject(enemiesLayer);
            enemy.x = 8 + Math.round( Math.random() * (width - 16) );
            enemy.y = -7;
        }
    }

    function cleanup()
    {

        //screen.reverse = false;
    }

    onPausedChanged: if(!paused) powerupSound.play();

    property string currentModal: ""

    Component.onCompleted:
    {
        //menuButton.clicked.connect(menuBtnPressed);
        //homeButton.clicked.connect(homeBtnPressed);
        //statusButton.clicked.connect(statusBtnPressed);
        Qt.application.onStateChanged.connect(pause);
    }

    Component.onDestruction:
    {
        //menuButton.clicked.disconnect(menuBtnPressed);
        //homeButton.clicked.disconnect(homeBtnPressed);
        //statusButton.clicked.disconnect(statusBtnPressed);
        Qt.application.onStateChanged.disconnect(pause);
    }
}

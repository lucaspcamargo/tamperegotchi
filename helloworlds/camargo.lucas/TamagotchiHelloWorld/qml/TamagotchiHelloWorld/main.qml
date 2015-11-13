import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle
{
    width: 480 * 0.8
    height: 854 * 0.8
    //source: "res/vd-mockup-1.png"
    color: "#acd3ac"
    smooth: false

    Image
    {
        id: worldBg
        source: "res/worlds/1.jpg"
        opacity: 0.3
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
    }

    FontLoader
    {
        id: pixelFont
        source: "res/pixel.ttf"
    }

    Item
    {
        id: screenArea

        //width: Math.round(parent.width * 0.9 )
        //height: Math.round(parent.height * 0.64)
        anchors.fill: parent

        Rectangle
        {
            id: screen

            property int pixelSize: Math.max(3, Math.min(parent.width, parent.height)/96) // I want a screen of at least 96 px at the smallest dimension

            width: Math.round(parent.width / pixelSize)
            height: Math.round(parent.height / pixelSize)
            anchors.centerIn: parent

            color: "white"
            scale: pixelSize // scale screen so that we can receive input events at the right places

            /*Canvas
            {
                id: canvas
                anchors.fill: parent
                onPaint:
                {
                    var ctx = canvas.getContext("2d");

                    ctx.fillStyle = "#00000000";
                    ctx.fillRect(0,0,canvas.width, canvas.height);

                    var pat = ctx.createPattern("lightgray", Qt.DiagCrossPattern);
                    ctx.fillStyle = pat;
                    ctx.fillRect(0,0,canvas.width, canvas.height);

                }
            }*/

            Rectangle{
                id: spinner
                width: Math.max(parent.width, parent.height) * 1.5
                height: 1
                anchors.centerIn: parent
                color: "black"
                //source: "qrc:///particleresources/star.png"

                SequentialAnimation
                {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { target: spinner; property: "rotation"; from: 0; duration: 2000; easing.type: Easing.Linear; to: 360 }
                }
            }

            Rectangle{
                id: spinner2
                width: Math.max(parent.width, parent.height) * 1.5
                height: 1
                anchors.centerIn: parent
                color: "black"
                //source: "qrc:///particleresources/star.png"

                SequentialAnimation
                {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation { target: spinner2; property: "rotation"; from: 90; duration: 2000; easing.type: Easing.Linear; to: 450 }
                }
            }

            BorderImage {
                id: frame
                source: "res/ui/frame.png"
                width: Math.floor(parent.width*0.9); height: Math.floor(parent.height*0.5)
                border.left: 5; border.top: 6
                border.right: 5; border.bottom: 6
                anchors.centerIn: parent

                Column{
                    id: inColumn
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 2


                    TTextBitmap
                    {
                        text: "LCD DEMO"
                        y: 5
                        scale: 1.5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    TButton
                    {
                        text: "TEST"
                        width: parent.width
                    }

                    TButton
                    {
                        text: "QUIT"
                        width: parent.width
                        onClicked: Qt.quit();
                    }
                }
            }

        }

        ShaderEffectSource
        {
            id: screenShaderSource
            sourceItem: screen
            textureSize: screen.width + "x" + screen.height
            mipmap: false
            hideSource: true
            smooth: false
        }

        Rectangle
        {
            id: screenPixelMask
            width: screen.pixelSize
            height: width

            color: "#00000000"

            Rectangle
            {
                width: Math.max(1, screen.pixelSize - 1) //Math.floor(screen.pixelSize*0.85)
                height: width
            }
        }

        ShaderEffectSource
        {
            id: screenPixelMaskSource
            sourceItem: screenPixelMask
            hideSource: true
            wrapMode: ShaderEffectSource.Repeat
            smooth: false
        }

        ShaderEffect
        {
            id: screenRenderer
            property variant pixelMask: screenPixelMaskSource
            property variant src: screenShaderSource

            property real offOpacity: 0.08
            property real pixelsWidth: screen.width
            property real pixelsHeight: screen.height

            property color pixelColor: "#ff0a0a00"
            opacity: 1.0

            anchors.centerIn: parent
            width: screen.width * screen.pixelSize
            height: screen.height * screen.pixelSize
            vertexShader: "
                        uniform highp mat4 qt_Matrix;
                        attribute highp vec4 qt_Vertex;
                        attribute highp vec2 qt_MultiTexCoord0;
                        varying highp vec2 coord;
                        void main() {
                            coord = qt_MultiTexCoord0;
                            gl_Position = qt_Matrix * qt_Vertex;
                        }"

            fragmentShader: "
                        varying highp vec2 coord;
                        uniform lowp float pixelsWidth;
                        uniform lowp float pixelsHeight;
                        uniform sampler2D src;
                        uniform sampler2D pixelMask;
                        uniform lowp vec4 pixelColor;
                        uniform lowp float offOpacity;
                        uniform lowp float qt_Opacity;
                        void main() {
                            lowp vec4 tex = texture2D(src, coord);
                            lowp vec4 pixelMaskTex = texture2D(pixelMask, coord * vec2(pixelsWidth, pixelsHeight) );
                            gl_FragColor = pixelColor * pixelMaskTex.a * mix(offOpacity, qt_Opacity, 1.0-tex.r);
                        }"
        }

    }
}

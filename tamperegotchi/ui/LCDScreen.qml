import QtQuick 2.0
import QtQuick.Particles 2.0

Item
{
    id: screenArea

    default property alias screenData: screen.data
    property int minPixelSpan: 102
    property real colorfulness: 0.0
    property bool reverse: false
    property bool debugEnabled: false

    property int pixelWidth: screen.width
    property int pixelHeight: screen.height

    Rectangle
    {
        id: screen

        // I want a screen of at least "minPixelSpan" px at the smallest dimension
        property int pixelSize: Math.max(2, Math.min(parent.width, parent.height)/screenArea.minPixelSpan)

        // our size in pixels must be an integer
        width: Math.round(parent.width / pixelSize)
        height: Math.round(parent.height / pixelSize)

        // center in parent
        anchors.centerIn: parent


        // white background by default
        color: "white"
        scale: pixelSize // scale screen so that we can receive input events at the right places

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
    /*

    Rectangle
    {
        id: screenPixelMask
        width: screen.pixelSize
        height: width

        color: "#888"

        Rectangle
        {
            width: Math.max(1, (2*screen.pixelSize - (screen.pixelSize/20)*(1.5 - colorfulness) ) / 2 )
            height: width
            smooth: true
            antialiasing: true
            radius: colorfulness*width/10
            Image
            {
                opacity: colorfulness*0.15
                anchors.fill: parent
                source: res("ui/screen-pixelmask.png")
            }
        }
    }
    ShaderEffectSource
    {
        id: screenPixelMaskSource
        sourceItem: screenPixelMask
        hideSource: true
        wrapMode: ShaderEffectSource.Repeat
        format: ShaderEffectSource.RGB
    }
    */

    /*
    ShaderEffect
    {
        id: screenRenderer
        property variant pixelMask: screenPixelMaskSource
        property variant src: screenShaderSource

        property real offOpacity: 0.05
        property real invert: reverse? 0.0 : 1.0

        Behavior on invert{ PropertyAnimation{} }

        property real colorful: colorfulness
        property real pixelsWidth: screen.width
        property real pixelsHeight: screen.height

        property color pixelColor: "black"
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
                        uniform lowp float invert;
                        uniform lowp float colorful;
                        uniform lowp float qt_Opacity;
                        void main() {
                            lowp vec4 tex = texture2D(src, coord);
                            lowp vec4 pixelMaskTex = texture2D(pixelMask, coord * vec2(pixelsWidth, pixelsHeight) );
                            gl_FragColor =
                            mix(pixelColor, tex.rgba, colorful) *
                            pixelMaskTex *
                            max( colorful, mix(offOpacity, qt_Opacity, (invert * 1.0) + pow(dot(tex.rgb, vec3(0.3, 0.59, 0.11)),0.7)*(1.0 - 2.0*invert) ) );
                        }"

    }
*/


    ShaderEffect
    {
        id: screenRendererSimplified
        //property variant pixelMask: screenPixelMaskSource
        property variant src: screenShaderSource

        property real offOpacity: 0.05
        property real invert: reverse? 0.0 : 1.0

        Behavior on invert{ PropertyAnimation{} }

        property real pixelsWidth: screen.width
        property real pixelsHeight: screen.height

        property color pixelColor: "black"

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

        fragmentShader: colorfulness > 0.5? "
                            // COLORFUL SHADER
                            varying highp vec2 coord;
                            uniform lowp float pixelsWidth;
                            uniform lowp float pixelsHeight;
                            uniform sampler2D src;
                            //uniform sampler2D pixelMask;
                            uniform lowp float invert;
                            void main() {
                                lowp vec4 tex = texture2D(src, coord);
                                //lowp vec4 pixelMaskTex = texture2D(pixelMask, coord * vec2(pixelsWidth, pixelsHeight) );
                                gl_FragColor = tex.rgba;;// * pixelMaskTex;
                            }
" : " // or
                            // RETRO SHADER
                            varying highp vec2 coord;
                            uniform lowp float pixelsWidth;
                            uniform lowp float pixelsHeight;
                            uniform sampler2D src;
                            //uniform sampler2D pixelMask;
                            uniform lowp vec4 pixelColor;
                            uniform lowp float offOpacity;
                            uniform lowp float invert;
                            void main() {
                                lowp vec4 tex = texture2D(src, coord);
                                //lowp vec4 pixelMaskTex = texture2D(pixelMask, coord * vec2(pixelsWidth, pixelsHeight) );
                                gl_FragColor = pixelColor * mix(offOpacity, 1.0, (invert * 1.0) + pow(dot(tex.rgb, vec3(0.3, 0.59, 0.11)),0.7)*(1.0 - 2.0*invert) );// * pixelMaskTex ;
                            }"

    }



    ShaderEffect
    {
        id: screenSourceShow
        property variant src: screenShaderSource

        opacity: 1.0

        anchors.bottom: parent.bottom
        anchors.margins: 10
        x: 10

        visible: debugEnabled

        width: screen.width
        height: screen.height
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
                        uniform sampler2D src;
                        uniform lowp float qt_Opacity;
                        void main() {
                            lowp vec4 tex = texture2D(src, coord);
                            gl_FragColor = tex * qt_Opacity;
                        }"

        Rectangle
        {
            anchors.fill: parent
            anchors.margins: -1
            color: "transparent"
            border.color: "red"
        }

    }


    ShaderEffect
    {
        visible: false
        id: super_2XSai
        property variant decal: screenShaderSource
        property vector2d video_size: Qt.vector2d(width, height)
        property vector2d texture_size: Qt.vector2d(screen.width, screen.height)
        property vector2d output_size: Qt.vector2d(width, height)

        opacity: 1.0

        anchors.fill: parent

        width: screen.width * 2
        height: screen.height * 2
        vertexShader: "
                        uniform highp mat4 qt_Matrix;
                        attribute highp vec4 qt_Vertex;
                        attribute highp vec2 qt_MultiTexCoord0;
                        varying highp vec2 texCoord;
                        void main() {
                            texCoord = qt_MultiTexCoord0;
                            gl_Position = qt_Matrix * qt_Vertex;
                        }"

        fragmentShader: "
                        const vec3 dtt = vec3(65536.0,255.0,1.0);

                        uniform highp vec2 video_size;
                        uniform highp vec2 texture_size;
                        uniform highp vec2 output_size;
                        uniform sampler2D decal;
                        varying highp vec2 texCoord;

                            int GET_RESULT(float A, float B, float C, float D)
                            {
                            int x = 0; int y = 0; int r = 0;
                            if (A == C) x+=1; else if (B == C) y+=1;
                            if (A == D) x+=1; else if (B == D) y+=1;
                            if (x <= 1) r+=1;
                            if (y <= 1) r-=1;
                            return r;
                            }

                            float reduce(vec3 color)
                            {
                            return dot(color, dtt);
                            }

                            void main()
                            {

                            // get texel size
                            vec2 ps = vec2(0.999/texture_size.x, 0.999/texture_size.y);
                            // calculating offsets, coordinates
                            vec2 dx = vec2( ps.x, 0.0);
                            vec2 dy = vec2( 0.0, ps.y);
                            vec2 g1 = vec2( ps.x,ps.y);
                            vec2 g2 = vec2(-ps.x,ps.y);
                            vec2 pixcoord = texCoord/ps;
                            vec2 fp = fract(pixcoord);
                            vec2 pC4 = texCoord-fp*ps;
                            vec2 pC8 = pC4+g1;
                            // Reading the texels
                            vec3 C0 = texture2D(decal,pC4-g1).xyz;
                            vec3 C1 = texture2D(decal,pC4-dy).xyz;
                            vec3 C2 = texture2D(decal,pC4-g2).xyz;
                            vec3 D3 = texture2D(decal,pC4-g2+dx).xyz;
                            vec3 C3 = texture2D(decal,pC4-dx).xyz;
                            vec3 C4 = texture2D(decal,pC4 ).xyz;
                            vec3 C5 = texture2D(decal,pC4+dx).xyz;
                            vec3 D4 = texture2D(decal,pC8-g2).xyz;
                            vec3 C6 = texture2D(decal,pC4+g2).xyz;
                            vec3 C7 = texture2D(decal,pC4+dy).xyz;
                            vec3 C8 = texture2D(decal,pC4+g1).xyz;
                            vec3 D5 = texture2D(decal,pC8+dx).xyz;
                            vec3 D0 = texture2D(decal,pC4+g2+dy).xyz;
                            vec3 D1 = texture2D(decal,pC8+g2).xyz;
                            vec3 D2 = texture2D(decal,pC8+dy).xyz;
                            vec3 D6 = texture2D(decal,pC8+g1).xyz;
                            vec3 p00,p10,p01,p11;
                            // reducing vec3 to float
                            float c0 = reduce(C0);float c1 = reduce(C1);
                            float c2 = reduce(C2);float c3 = reduce(C3);
                            float c4 = reduce(C4);float c5 = reduce(C5);
                            float c6 = reduce(C6);float c7 = reduce(C7);
                            float c8 = reduce(C8);float d0 = reduce(D0);
                            float d1 = reduce(D1);float d2 = reduce(D2);
                            float d3 = reduce(D3);float d4 = reduce(D4);
                            float d5 = reduce(D5);float d6 = reduce(D6);
                            if (c7 == c5 && c4 != c8) {
                            p11 = p01 = C7;
                            } else if (c4 == c8 && c7 != c5) {
                            p11 = p01 = C4;
                            } else if (c4 == c8 && c7 == c5) {
                            int r = 0;
                            r += GET_RESULT(c5,c4,c6,d1);
                            r += GET_RESULT(c5,c4,c3,c1);
                            r += GET_RESULT(c5,c4,d2,d5);
                            r += GET_RESULT(c5,c4,c2,d4);
                            if (r > 0)
                            p11 = p01 = C5;
                            else if (r < 0)
                            p11 = p01 = C4;
                            else {
                            p11 = p01 = 0.5*(C4+C5);
                            }
                            } else {
                            if (c5 == c8 && c8 == d1 && c7 != d2 && c8 != d0)
                            p11 = 0.25*(3.0*C8+C7);
                            else if (c4 == c7 && c7 == d2 && d1 != c8 && c7 != d6)
                            p11 = 0.25*(3.0*C7+C8);
                            else
                            p11 = 0.5*(C7+C8);
                            if (c5 == c8 && c5 == c1 && c4 != c2 && c5 != c0)
                            p01 = 0.25*(3.0*C5+C4);
                            else if (c4 == c7 && c4 == c2 && c1 != c5 && c4 != d3)
                            p01 = 0.25*(3.0*C4+C5);
                            else
                            p01 = 0.5*(C4+C5);
                            }
                            if (c4 == c8 && c7 != c5 && c3 == c4 && c4 != d2)
                            p10 = 0.5*(C7+C4);
                            else if (c4 == c6 && c5 == c4 && c3 != c7 && c4 != d0)
                            p10 = 0.5*(C7+C4);
                            else
                            p10 = C7;
                            if (c7 == c5 && c4 != c8 && c6 == c7 && c7 != c2)
                            p00 = 0.5*(C7+C4);
                            else if (c3 == c7 && c8 == c7 && c6 != c4 && c7 != c0)
                            p00 = 0.5*(C7+C4);
                            else
                            p00 = C4;
                            // Distributing the four products
                            if (fp.x < 0.50)
                            { if (fp.y < 0.50) p10 = p00;}
                            else
                            { if (fp.y < 0.50) p10 = p01; else p10 = p11;}
                            // OUTPUT
                            gl_FragColor = vec4(p10, 1);
                            }"

    }


}


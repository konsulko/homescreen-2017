import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Item {
    id: main
    Image {
        id: item; parent: loc
        x: main.x + 5; y: main.y + 5
        width: main.width - 10; height: main.height - 10;

        Label {
            id: title
            y: 60
            font.pixelSize: 125
            anchors.horizontalCenter: parent.horizontalCenter
            text: model.name.substring(0,1).toUpperCase()
            visible: false
        }
        LinearGradient  {
            anchors.fill: title
            source: title
            gradient: Gradient {
                GradientStop { position: -0.5; color: "#6BFBFF" }
                GradientStop { position: +1.5; color: "#00ADDC" }
            }
            visible: model.icon === 'Blank'
        }


        Label {
            id: name
            y: 245
            width: main.width - 10
            font.pixelSize: 25
            font.letterSpacing: 5
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            text: qsTr(model.name.toUpperCase())
        }

        source: './images/HMI_AppLauncher_%1_%2-01.svg'.arg(model.icon).arg(loc.pressed && (loc.index === model.index || loc.currentId === model.id) ? 'Active' : 'Inactive')
        antialiasing: item.state !== ''
        Behavior on x { enabled: item.state !== 'active'; NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        Behavior on y { enabled: item.state !== 'active'; NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        SequentialAnimation on rotation {
            NumberAnimation { to:  5; duration: 100 }
            NumberAnimation { to: -5; duration: 200 }
            NumberAnimation { to:  0; duration: 100 }
            running: loc.currentId !== '' && item.state !== 'active'
            loops: Animation.Infinite; alwaysRunToEnd: true
        }
        states: [
            State {
                name: 'active'
                when: loc.currentId == model.id
                PropertyChanges { target: item; x: loc.mouseX - width/2; y: loc.mouseY - height/2; scale: 1.15; z: 10 }
            },
            State {
                when: loc.currentId !== ''
                PropertyChanges {
                    target: item
                    scale: 0.85
                    opacity: 0.75
                }
            }
        ]
        transitions: Transition { NumberAnimation { properties: 'scale, opacity, x, y'; duration: 150; easing.type: Easing.OutCubic} }
    }
}

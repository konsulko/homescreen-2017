import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Item {
    id: main
    width: 320
    height: 320

    Item {
        id: container
        parent: loc
        x: main.x
        y: main.y
        width: main.width
        height: main.height

        Image {
            id: item
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            width: 220
            height: width
            source: './images/%1_%2.svg'.arg(model.icon).arg(loc.pressed && (loc.index === model.index || loc.currentId === model.id) ? 'active' : 'inactive')
            antialiasing: item.state !== ''

            Label {
                id: title
                style: Text.Outline
                styleColor: 'red'
                color: 'transparent'
                font.pixelSize: 125
                anchors.centerIn: parent
                text: model.name.substring(0,1).toUpperCase()
                visible: model.icon === 'blank'

                layer.enabled: true
                layer.effect: LinearGradient {
                    gradient: Gradient {
                            GradientStop { position: -0.5; color: "#6BFBFF" }
                            GradientStop { position: +1.5; color: "#00ADDC" }
                    }
                }
            }
        }
        Label {
            id: name
            anchors.top: item.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            font.pixelSize: 25
            font.letterSpacing: 5
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            color: "white"
            text: qsTr(model.name.toUpperCase())
        }

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
                PropertyChanges {
                    target: container
                    x: loc.mouseX - width/2
                    y: loc.mouseY - height/2
                    scale: 1.15
                    z: 10
                }
            },
            State {
                when: loc.currentId !== ''
                PropertyChanges {
                    target: container
                    scale: 0.85
                    opacity: 0.75
                }
            }
        ]
        transitions: Transition { NumberAnimation { properties: 'scale, opacity, x, y'; duration: 150; easing.type: Easing.OutCubic} }
    }
}

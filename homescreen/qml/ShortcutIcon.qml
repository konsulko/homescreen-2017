/*
 * Copyright (C) 2016 The Qt Company Ltd.
 * Copyright (C) 2016, 2017 Mentor Graphics Development (Deutschland) GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import QtQuick 2.2
import QtQuick.Controls 2.0

MouseArea {
    id: root
    width: 195
    height: 216.8
    property string name: 'Home'
    property bool active: false
    Image {
        id: icon
        anchors.fill: parent
        source: './images/Shortcut/%1.svg'.arg(root.name.toLowerCase())
    }
    Image {
        anchors.fill: parent
        source: './images/Shortcut/%1_active.svg'.arg(root.name.toLowerCase())
        opacity: 1.0 - icon.opacity
    }
    Label {
        id: name
        y: 160
        width: root.width - 10
        font.pixelSize: 15
        font.letterSpacing: 5
        // wrapMode: Text.WordWrap
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        color: "white"
        text: qsTr(model.name.toUpperCase())
    }
    states: [
        State {
            when: root.active
            PropertyChanges {
                target: icon
                opacity: 0.0
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: 'opacity'
                easing.type: Easing.OutExpo
            }
        }
    ]
}

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
import Home 1.0

Item {
    id: root

    Image {
        y: 0
        anchors.fill: parent
        anchors.topMargin: -218
        anchors.bottomMargin: -215
        source: './images/AGL_HMI_Blue_Background_Car-01.png'
    }

    property int pid: -1
    width: 1080
    height: 1487

    GridView {
        id: grid
        x: 60
        y: 100
        width: 960
        height: 1280
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        contentHeight: 320
        flickableDirection: Flickable.AutoFlickDirection
        snapMode: GridView.SnapOneRow
        visible: true
        cellWidth: 320
        cellHeight: 320
        interactive: false

        model: ApplicationModel { id: applicationModel }
        delegate: IconItem {
            width: grid.cellWidth
            height: grid.cellHeight
        }

        MouseArea {
            id: loc
            anchors.fill: parent
            property string currentId: ''
            property int newIndex: -1
            property int index: grid.indexAt(loc.mouseX, loc.mouseY)
            x: 62
            y: 264
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            onPressAndHold: currentId = applicationModel.id(newIndex = index)
            onReleased: {
                if (currentId === '') {
                    pid = launcher.launch(applicationModel.id(loc.index))
                    if (1 < pid) {
//                        layoutHandler.makeMeVisible(pid)

                        applicationArea.visible = true
                        appLauncherAreaLauncher.visible = false
  //                      layoutHandler.showAppLayer(applicationModel.id(loc.index),  pid)
                    }
                    else {
                        console.warn("app cannot be launched!")
                    }
                } else {
                    currentId = ''
                }
                homescreenHandler.tapShortcut(applicationModel.name(loc.index))
            }
            onPositionChanged: {
                if (loc.currentId === '') return
                if (index < 0) return
                if (index === newIndex) return
                    applicationModel.move(newIndex, newIndex = index)
            }
        }
    }
}

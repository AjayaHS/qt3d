/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt3D examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import Qt3D 1.0


Viewport {
    width: parent.width
    height: parent.height
    picking: true
    renderMode: "DirectRender"

    camera: Camera {
        eye: Qt.vector3d(0, 3, 10)
    }

    Item3D {
        id: teapot
        transform: [
            Rotation3D {
                id: teapot_rotate1
                angle: 0
                axis: Qt.vector3d(0, 1, 0)
            },
            Rotation3D {
                id: teapot_rotate2
                angle: 0
                axis: Qt.vector3d(0, 0, 1)
            }
        ]
        property bool bounce: false

        Item3D {
            id: body
            mesh: Mesh { source: "teapot-body.bez" }
            effect: Effect {
                material: china
            }

            onHoverEnter: { effect.material = china_highlight }
            onHoverLeave: { effect.material = china }
            onClicked: { teapot.bounce = true }
        }

        Item3D {
            id: handle
            mesh: Mesh { source: "teapot-handle.bez" }
            effect: Effect {
                material: china
            }

            onHoverEnter: { effect.material = china_highlight }
            onHoverLeave: { effect.material = china }
            onClicked: {
                if (teapot.state == "facing_left" ||
                    teapot.state == "pour_left") {
                    teapot.state = "facing_right";
                } else if (teapot.state == "facing_right" ||
                           teapot.state == "pour_right") {
                    teapot_rotate1.angle = 0;
                    teapot.state = "facing_left";
                } else {
                    teapot.state = "facing_left";
                }
            }
        }

        Item3D {
            id: spout
            mesh: Mesh { source: "teapot-spout.bez" }
            effect: Effect {
                material: china
            }

            onHoverEnter: { effect.material = china_highlight }
            onHoverLeave: { effect.material = china }
            onClicked: {
                if (teapot.state == "facing_left") {
                    teapot.state = "pour_left";
                } else if (teapot.state == "pour_left") {
                    teapot.state = "facing_left";
                    teapot.state = "pour_left";
                } else if (teapot.state == "pour_right" ||
                           teapot.state == "facing_right") {
                    teapot.state = "";
                    teapot_rotate1.angle = 0;
                    teapot.state = "pour_right";
                } else {
                    teapot.state = "pour_right";
                }
            }
        }

        SequentialAnimation on y{
            running: teapot.bounce
            NumberAnimation { to : 1.0; duration: 300; easing.type: "OutQuad" }
            NumberAnimation { to : 0.0; duration: 300; easing.type: "OutBounce" }
            onCompleted: teapot.bounce = false
        }

        states: [
            State {
                name: "facing_left"
                PropertyChanges {
                    target: teapot_rotate1
                    angle: 180
                }
            },
            State {
                name: "facing_right"
                PropertyChanges {
                    target: teapot_rotate1
                    angle: 360
                }
            },
            State {
                name: "pour_left"
                PropertyChanges {
                    target: teapot
                    y: 0
                }
                PropertyChanges {
                    target: teapot
                    x: 0
                }
                PropertyChanges {
                    target: teapot_rotate1
                    angle: 180
                }
                PropertyChanges {
                    target: teapot_rotate2
                    angle: 0
                }
            },
            State {
                name: "pour_right"
                PropertyChanges {
                    target: teapot
                    y: 0
                }
                PropertyChanges {
                    target: teapot
                    x: 0
                }
                PropertyChanges {
                    target: teapot_rotate2
                    angle: 0
                }
            }
        ]

        transitions: [
            Transition {
                from: "*"
                to: "facing_left"
                NumberAnimation {
                    targets: teapot_rotate1
                    properties: "angle"
                    duration: 300
                }
            },
            Transition {
                from: "*"
                to: "facing_right"
                NumberAnimation {
                    targets: teapot_rotate1
                    properties: "angle"
                    duration: 300
                }
            },
            Transition {
                from: "*"
                to: "pour_left"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: teapot
                            property: "y"
                            duration: 500
                            to: 1
                            easing.type: "OutQuad"
                        }
                        NumberAnimation {
                            target: teapot
                            property: "x"
                            duration: 500
                            to: -0.5
                            easing.type: "OutQuad"
                        }
                        NumberAnimation {
                            target: teapot_rotate2
                            property: "angle"
                            duration: 500
                            to: 45
                            easing.type: "OutQuad"
                        }
                    }
                    PauseAnimation { duration: 700 }
                    ParallelAnimation {
                        NumberAnimation {
                            target: teapot
                            property: "y"
                            duration: 500
                            to: 0
                            easing.type: "OutQuad"
                        }
                        NumberAnimation {
                            target: teapot
                            property: "x"
                            duration: 500
                            to: 0
                            easing.type: "OutQuad"
                        }
                        NumberAnimation {
                            target: teapot_rotate2
                            property: "angle"
                            duration: 500
                            to: 0
                            easing.type: "OutQuad"
                        }
                    }
                }
            },
            Transition {
                from: "*"
                to: "pour_right"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: teapot
                            property: "y"
                            duration: 500
                            to: 1
                            easing.type: "OutQuad"
                        }
                        NumberAnimation {
                            target: teapot
                            property: "x"
                            duration: 500
                            to: 0.5
                            easing.type: "OutQuad"
                        }
                        NumberAnimation {
                            target: teapot_rotate2
                            property: "angle"
                            duration: 500
                            to: -45
                            easing.type: "OutQuad"
                        }
                    }
                    PauseAnimation { duration: 700 }
                    ParallelAnimation {
                        NumberAnimation {
                            target: teapot
                            property: "y"
                            duration: 500
                            to: 0
                            easing.type: "OutQuad"
                        }
                        NumberAnimation {
                            target: teapot
                            property: "x"
                            duration: 500
                            to: 0
                            easing.type: "OutQuad"
                        }
                        NumberAnimation {
                            target: teapot_rotate2
                            property: "angle"
                            duration: 500
                            to: 0
                            easing.type: "OutQuad"
                        }
                    }
                }
            }
        ]
    }

    Teacup {
        id: teacup1
        position: Qt.vector3d(-2.3, -0.75, 0.0)
    }

    Teacup {
        id: teacup2
        position: Qt.vector3d(2.3, -0.75, 0.0)
        transform: Rotation3D {
            angle: 180
            axis: Qt.vector3d(0, 1, 0)
        }
    }

    Teaspoon {
        x: -1.7
        y: -0.58
        saucerY: teacup1.spoonY
    }

    Teaspoon {
        x: 1.7
        y: -0.58
        saucerY: teacup2.spoonY
    }

    Mesh {
        id: teacup_mesh
        source: "teacup.bez"
    }

    Mesh {
        id: teaspoon_mesh
        source: "teaspoon.bez"
    }

    Material {
        id: china
        ambientColor: "#c09680"
        specularColor: "#3c3c3c"
        shininess: 128
    }

    Material {
        id: china_highlight
        ambientColor: "#ffc000"
        specularColor: "#3c3c00"
        shininess: 128
    }

    Material {
        id: metal
        ambientColor: "#ffffff"
        diffuseColor: "#969696"
        specularColor: "#ffffff"
        shininess: 128
    }

    Material {
        id: metal_highlight
        ambientColor: "#ffff60"
        diffuseColor: "#969660"
        specularColor: "#ffffff"
        shininess: 128
    }
}
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 1600
    height: 900
    visible: true
    color: "#B0F2DE"
    title: qsTr("VoltFlow 伏流")
    property string alertMsg: ""
    property bool isReviewAlert: false
    property real scaleFactor: Math.min(window.width / 1600.0, window.height / 900.0)

    SequentialAnimation {
        id: anim_shake
        loops: 2
        NumberAnimation {
            target: stack
            property: "x"
            to: 12
            duration: 40
        }
        NumberAnimation {
            target: stack
            property: "x"
            to: -12
            duration: 40
        }
        NumberAnimation {
            target: stack
            property: "x"
            to: 0
            duration: 40
        }
    }

    Connections {
        target: taskManager
        function onTriggerShake(msg, isReview) {
            window.alertMsg = msg
            window.isReviewAlert = isReview
            anim_shake.start()
        }
    }

    Item {
        id: container
        width: 1600
        height: 900
        x: (window.width - 1600 * window.scaleFactor) / 2
        y: (window.height - 900 * window.scaleFactor) / 2
        transform: Scale {
            origin.x: 0
            origin.y: 0
            xScale: window.scaleFactor
            yScale: window.scaleFactor
        }

        StackView {
            id: stack
            anchors.fill: parent
            initialItem: View_Main {}
            property real dx: 0
            property real dy: 0
            pushEnter: Transition {
                NumberAnimation {
                    property: "x"
                    from: stack.dx
                    to: 0
                    duration: 400
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    property: "y"
                    from: stack.dy
                    to: 0
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
            pushExit: Transition {
                NumberAnimation {
                    property: "x"
                    from: 0
                    to: -stack.dx
                    duration: 400
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    property: "y"
                    from: 0
                    to: -stack.dy
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
            popEnter: Transition {
                NumberAnimation {
                    property: "x"
                    from: -stack.dx
                    to: 0
                    duration: 400
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    property: "y"
                    from: -stack.dy
                    to: 0
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
            popExit: Transition {
                NumberAnimation {
                    property: "x"
                    from: 0
                    to: stack.dx
                    duration: 400
                    easing.type: Easing.OutCubic
                }
                NumberAnimation {
                    property: "y"
                    from: 0
                    to: stack.dy
                    duration: 400
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
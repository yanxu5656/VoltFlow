import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window
    width: 1600
    height: 900
    maximumWidth: 1600
    minimumWidth: 1600
    maximumHeight: 900
    minimumHeight: 900
    visible: true
    color: "#B0F2DE"
    title: qsTr("VoltFlow 伏流")
    property string alertMsg: ""
    property bool isReviewAlert: false

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

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: View_Main{}
    }
}
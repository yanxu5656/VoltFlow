// 核心承载窗口：提供全局抖动动画框架，捕获并执行物理窗口抖动逻辑
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

    // 接收全局通知的气泡数据槽
    property string alertMsg: ""
    property bool isReviewAlert: false

    // 窗口物理坐标抖动动画
    SequentialAnimation {
        id: anim_shake
        loops: 2
        NumberAnimation { target: window; property: "x"; to: window.x + 10; duration: 40 }
        NumberAnimation { target: window; property: "x"; to: window.x - 10; duration: 40 }
        NumberAnimation { target: window; property: "x"; to: window.x; duration: 40 }
    }

    // 绑定 C++ 层震动和提醒触发器
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
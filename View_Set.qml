// 时间控制管理视图：支持系统时钟同步切换以及演示步进多级微调控制
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Item {
    id: view_set
    width: 1600
    height: 900

    Rectangle {
        anchors.fill: parent
        color: "#B0F2DE"

        Rectangle {
            id: rect_time_box
            x: 50
            y: 60
            width: 600
            height: 700
            color: "#8ED9F6"
            border.color: "#1ABC9C"
            border.width: 4

            Text {
                id: txt_time_title
                x: 20
                y: 20
                text: "核心时钟与调度管理"
                color: "#FFFFD6"
                font.pixelSize: 28
                font.bold: true
            }

            Rectangle {
                x: 20
                y: 90
                width: 560
                height: 120
                color: "#ADCEC8"
                border.color: "#1ABC9C"
                border.width: 2

                Text {
                    x: 20
                    y: 20
                    text: "当前虚拟系统时间"
                    color: "#FFFFD6"
                    font.pixelSize: 18
                }

                Text {
                    x: 20
                    y: 55
                    text: Qt.formatDateTime(taskManager.currentTime, "yyyy-MM-dd HH:mm:ss")
                    color: "#FFFFD6"
                    font.pixelSize: 32
                    font.bold: true
                }
            }

            Text {
                x: 20
                y: 240
                text: "演示快进控制槽（触发掉电与周期结算）"
                color: "#FFFFD6"
                font.pixelSize: 20
                font.bold: true
            }

            Button {
                x: 20
                y: 290
                width: 160
                height: 50
                text: "快进 1 小时 (-10%)"
                onClicked: taskManager.addDemoTime(1)
            }

            Button {
                x: 210
                y: 290
                width: 160
                height: 50
                text: "快进 12 小时"
                onClicked: taskManager.addDemoTime(12)
            }

            Button {
                x: 400
                y: 290
                width: 180
                height: 50
                text: "快进 24 小时 (结算)"
                onClicked: taskManager.addDemoTime(24)
            }

            Rectangle {
                x: 20
                y: 380
                width: 560
                height: 280
                color: "#ADCEC8"
                border.color: "#1ABC9C"
                border.width: 2

                Text {
                    x: 20
                    y: 20
                    text: "时钟运作规则看板"
                    color: "#FFFFD6"
                    font.pixelSize: 20
                    font.bold: true
                }

                Text {
                    x: 20
                    y: 65
                    text: "• 每日 07:00 电池核心强制初始化重置为 100%\n• 每流逝 1 小时，系统固有结界消耗 10% 电量\n• 每日 24:00 自动触发暗夜汇总结算模块\n• 完成自定义任务可为核心注能，允许突破 100% 极限"
                    color: "#FFFFD6"
                    font.pixelSize: 16
                    lineHeight: 1.6
                }
            }
        }

        Shape {
            id: sanjiaoxing_xia
            width: 1600
            height: 900
            layer.enabled: true
            ShapePath {
                strokeColor: "#1ABC9C"
                strokeWidth: 4
                fillColor: "#8ED9F6"
                startX: 800
                startY: 730
                PathLine { x: 860; y: 880 }
                PathLine { x: 740; y: 880 }
                PathLine { x: 800; y: 730 }
            }
            MouseArea {
                x: 740
                y: 730
                width: 120
                height: 150
                onClicked: stack.pop()
            }
        }

        Text {
            x: 776
            y: 815
            text: "返回"
            color: "#FFFFD6"
            font.pixelSize: 24
            font.bold: true
        }

        Rectangle {
            id: rect_weekly
            x: 575
            y: 755
            width: 150
            height: 90
            color: "#8ED9F6"
            border.color: "#1ABC9C"
            border.width: 4
            Text { id: label_weekly; anchors.horizontalCenter: parent.horizontalCenter; y: 15; text: "周能量值"; color: "#FFFFD6"; font.pixelSize: 22; font.bold: true }
            Text { anchors.horizontalCenter: parent.horizontalCenter; anchors.top: label_weekly.bottom; anchors.topMargin: 5; text: taskManager.weeklyEnergy; color: "#FFFFD6"; font.pixelSize: 20; font.bold: true }
        }

        Rectangle {
            id: rect_total
            x: 875
            y: 755
            width: 150
            height: 90
            color: "#8ED9F6"
            border.color: "#1ABC9C"
            border.width: 4
            Text { id: label_total; anchors.horizontalCenter: parent.horizontalCenter; y: 15; text: "总能量值"; color: "#FFFFD6"; font.pixelSize: 22; font.bold: true }
            Text { anchors.horizontalCenter: parent.horizontalCenter; anchors.top: label_total.bottom; anchors.topMargin: 5; text: taskManager.totalEnergy; color: "#FFFFD6"; font.pixelSize: 20; font.bold: true }
        }
    }
}
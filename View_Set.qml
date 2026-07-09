import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
            color: "#B0E0E6"
            radius: 24

            Text {
                id: txt_time_title
                x: 25
                y: 20
                text: "核心时钟与调度管理"
                color: "#34495E"
                font.pixelSize: 24
                font.bold: true
            }

            Rectangle {
                x: 20
                y: 75
                width: 560
                height: 120
                color: "#80FFFFFF"
                radius: 16
                Text {
                    x: 20
                    y: 20
                    text: "当前虚拟系统时间"
                    color: "#7F8C8D"
                    font.pixelSize: 16
                    font.bold: true
                }
                Text {
                    x: 20
                    y: 55
                    text: Qt.formatDateTime(taskManager.currentTime, "yyyy-MM-dd HH:mm:ss")
                    color: "#2C3E50"
                    font.pixelSize: 32
                    font.bold: true
                }
            }

            Text {
                x: 25
                y: 220
                text: "演示快进控制槽（触发掉电与周期结算）"
                color: "#34495E"
                font.pixelSize: 18
                font.bold: true
            }

            RowLayout {
                x: 20
                y: 260
                width: 560
                spacing: 15
                Button {
                    Layout.fillWidth: true
                    height: 48
                    contentItem: Text {
                        text: "+1 小时 (-10%)"
                        color: "white"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: parent.pressed ? "#16A085" : "#1ABC9C"
                        radius: 10
                    }
                    onClicked: taskManager.addDemoTime(1)
                }
                Button {
                    Layout.fillWidth: true
                    height: 48
                    contentItem: Text {
                        text: "+12 小时"
                        color: "white"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: parent.pressed ? "#16A085" : "#1ABC9C"
                        radius: 10
                    }
                    onClicked: taskManager.addDemoTime(12)
                }
                Button {
                    Layout.fillWidth: true
                    height: 48
                    contentItem: Text {
                        text: "+24 小时 (结算)"
                        color: "white"
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: parent.pressed ? "#2C3E50" : "#34495E"
                        radius: 10
                    }
                    onClicked: taskManager.addDemoTime(24)
                }
            }

            Text {
                x: 25
                y: 345
                text: "系统底层维护面板"
                color: "#34495E"
                font.pixelSize: 18
                font.bold: true
            }
            Button {
                x: 20
                y: 385
                width: 560
                height: 50
                contentItem: Text {
                    text: "清空数据库数据"
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.pressed ? "#C0392B" : "#E74C3C"
                    radius: 12
                }
                onClicked: taskManager.clearDatabase()
            }

            Rectangle {
                x: 20
                y: 465
                width: 560
                height: 210
                color: "#80FFFFFF"
                radius: 16
                Text {
                    x: 20
                    y: 15
                    text: "时钟运作规则"
                    color: "#34495E"
                    font.pixelSize: 16
                    font.bold: true
                }
                Text {
                    x: 20
                    y: 45
                    text: "• 每日 07:00 电池核心强制初始化重置为 100%\n• 每流逝 1 小时，系统固有结界消耗 10% 电量\n• 每日 24:00 自动触发暗夜汇总结算模块\n• 完成自定义任务可为核心注能，允许突破 100% 极限"
                    color: "#5D6D7E"
                    font.pixelSize: 14
                    lineHeight: 1.6
                }
            }
        }

        Shape {
            id: sanjiaoxing_xia
            width: 1600
            height: 900
            ShapePath {
                strokeColor: "transparent"
                fillColor: "#B0E0E6"
                startX: 800
                startY: 730
                PathLine {
                    x: 860
                    y: 880
                }
                PathLine {
                    x: 740
                    y: 880
                }
                PathLine {
                    x: 800
                    y: 730
                }
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
            color: "#34495E"
            font.pixelSize: 24
            font.bold: true
        }

        Rectangle {
            id: rect_weekly
            x: 575
            y: 755
            width: 150
            height: 90
            color: "#B0E0E6"
            radius: 14
            Text {
                id: label_weekly
                anchors.horizontalCenter: parent.horizontalCenter
                y: 15
                text: "周能量值"
                color: "#34495E"
                font.pixelSize: 22
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: label_weekly.bottom
                anchors.topMargin: 5
                text: taskManager.weeklyEnergy
                color: "#1ABC9C"
                font.pixelSize: 20
                font.bold: true
            }
        }
        Rectangle {
            id: rect_total
            x: 875
            y: 755
            width: 150
            height: 90
            color: "#B0E0E6"
            radius: 14
            Text {
                id: label_total
                anchors.horizontalCenter: parent.horizontalCenter
                y: 15
                text: "总能量值"
                color: "#34495E"
                font.pixelSize: 22
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: label_total.bottom
                anchors.topMargin: 5
                text: taskManager.totalEnergy
                color: "#1ABC9C"
                font.pixelSize: 20
                font.bold: true
            }
        }
    }
}
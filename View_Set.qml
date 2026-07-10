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

        RowLayout {
            x: 30
            y: 20
            spacing: 15
            Button {
                width: 70
                height: 35
                contentItem: Text {
                    text: "返回"
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.pressed ? "#7F8C8D" : "#95A5A6"
                    radius: 8
                }
                onClicked: stack.pop()
            }
            Rectangle {
                width: 90
                height: 35
                color: "#B0E0E6"
                radius: 8
                Text {
                    anchors.centerIn: parent
                    text: "⚡ " + taskManager.currentEnergy + "%"
                    color: "#34495E"
                    font.bold: true
                    font.pixelSize: 14
                }
            }
            Rectangle {
                width: 100
                height: 35
                color: "#B0E0E6"
                radius: 8
                Text {
                    anchors.centerIn: parent
                    text: "周: " + taskManager.weeklyEnergy
                    color: "#34495E"
                    font.bold: true
                    font.pixelSize: 14
                }
            }
            Rectangle {
                width: 100
                height: 35
                color: "#B0E0E6"
                radius: 8
                Text {
                    anchors.centerIn: parent
                    text: "总: " + taskManager.totalEnergy
                    color: "#34495E"
                    font.bold: true
                    font.pixelSize: 14
                }
            }
        }

        Rectangle {
            id: rect_time_box
            x: 265
            y: 80
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
                        text: "+12 小s"
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
        }

        Rectangle {
            id: rect_rules_box
            x: 905
            y: 80
            width: 470
            height: 700
            color: "#B0E0E6"
            radius: 24

            Text {
                x: 25
                y: 20
                text: "全维度流转规则明细"
                color: "#34495E"
                font.pixelSize: 24
                font.bold: true
            }

            Rectangle {
                x: 15
                y: 70
                width: 440
                height: 605
                color: "#80FFFFFF"
                radius: 16

                Text {
                    x: 20
                    y: 25
                    width: 400
                    text: "• 恒定苏醒\n  每日 07:00 核心强制初始化为 100%\n\n• 固有结界\n  每流逝 1 小时自动消耗 10% 基础电量\n\n• 任务注能\n  完成自定或推荐任务可获得能量注入，允许突破 100% 核心极限\n\n• 暗夜结算\n  每日 24:00 自动结算，转换分支规则如下：\n  [超能状态] 当今日电量超过 100% 时，激活平方加权增幅公式：\n  获得能量值 = 今日能量值 × (今日能量值 / 100)\n  [普通状态] 当今日电量低于或等于 100% 时，直接进行 1:1 全额等量转化结算，免除二次缩减惩罚\n\n• 历史波形\n  周期内未登录产生能耗的天数在趋势线中默认补零"
                    color: "#5D6D7E"
                    font.pixelSize: 15
                    lineHeight: 1.6
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
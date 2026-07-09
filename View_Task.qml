import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: view_task
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
            id: rect_recs_box
            x: 50
            y: 80
            width: 600
            height: 350
            color: "#B0E0E6"
            radius: 24

            Text {
                x: 25
                y: 20
                text: "每日系统推荐任务清单"
                color: "#34495E"
                font.pixelSize: 24
                font.bold: true
            }

            Rectangle {
                x: 20
                y: 70
                width: 560
                height: 250
                color: "#80FFFFFF"
                radius: 16

                ListView {
                    anchors.fill: parent
                    anchors.margins: 10
                    model: taskManager.sysRecs
                    clip: true
                    spacing: 8
                    delegate: Rectangle {
                        width: parent.width
                        height: 45
                        color: "#F0F8FF"
                        radius: 10
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: 12
                            text: "💡 " + modelData.name
                            color: "#2C3E50"
                            font.pixelSize: 15
                            font.bold: true
                        }
                        Row {
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 8
                            Button {
                                text: "详细编辑"
                                height: 30
                                background: Rectangle {
                                    color: "#1ABC9C"
                                    radius: 6
                                }
                                onClicked: {
                                    input_name.text = modelData.name
                                    cb_type.currentIndex = 1
                                }
                            }
                            Button {
                                text: "清理"
                                height: 30
                                background: Rectangle {
                                    color: "#E74C3C"
                                    radius: 6
                                }
                                onClicked: taskManager.removeTask(modelData.id, true)
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rect_active_box
            x: 50
            y: 450
            width: 600
            height: 380
            color: "#B0E0E6"
            radius: 24

            Text {
                x: 25
                y: 20
                text: "活动执行任务监视栏"
                color: "#34495E"
                font.pixelSize: 24
                font.bold: true
            }

            Rectangle {
                x: 20
                y: 70
                width: 560
                height: 280
                color: "#80FFFFFF"
                radius: 16

                ListView {
                    anchors.fill: parent
                    anchors.margins: 10
                    model: taskManager.userTasks
                    clip: true
                    spacing: 8
                    delegate: Rectangle {
                        width: parent.width
                        height: 45
                        color: "#F0F8FF"
                        radius: 10
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: 12
                            text: (modelData.is_rec === 1 ? "[推荐] " : "[自定] ") + modelData.name
                            color: "#2C3E50"
                            font.pixelSize: 15
                        }
                        Button {
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter
                            text: "废弃"
                            height: 30
                            background: Rectangle {
                                color: "#95A5A6"
                                radius: 6
                            }
                            onClicked: taskManager.removeTask(modelData.id, false)
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rect_add_box
            x: 690
            y: 80
            width: 650
            height: 480
            color: "#B0E0E6"
            radius: 24

            Text {
                x: 25
                y: 20
                text: "任务发布与投放面板"
                color: "#34495E"
                font.pixelSize: 24
                font.bold: true
            }

            TextField {
                id: input_name
                x: 20
                y: 70
                width: 410
                height: 40
                placeholderText: "输入正在编辑的任务主题具体内容..."
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }

            ComboBox {
                id: cb_type
                x: 450
                y: 70
                width: 180
                height: 40
                model: ["普通任务", "系统推荐属性"]
                currentIndex: 0
            }

            TextField {
                id: input_reward
                x: 20
                y: 130
                width: 195
                height: 40
                placeholderText: "能量加分(如25)"
                validator: IntValidator{bottom: 1}
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }

            TextField {
                id: input_hours
                x: 235
                y: 130
                width: 195
                height: 40
                placeholderText: "限时完成(小时)"
                validator: IntValidator{bottom: 1}
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }

            ComboBox {
                id: cb_priority
                x: 450
                y: 130
                width: 180
                height: 40
                model: ["优先级 1 (低)", "优先级 2", "优先级 3", "优先级 4", "优先级 5 (高)"]
                currentIndex: 2
                visible: cb_type.currentIndex === 0
            }

            ComboBox {
                id: cb_review
                x: 20
                y: 190
                width: 250
                height: 40
                model: ["关闭留存复习提醒", "开启自定分钟循环", "开启艾宾浩斯判定"]
                currentIndex: 0
                visible: cb_type.currentIndex === 0
            }

            TextField {
                id: input_rev_val
                x: 290
                y: 190
                width: 340
                height: 40
                placeholderText: "输入具体循环复习间隔(分钟)"
                visible: cb_review.currentIndex > 0 && cb_type.currentIndex === 0
                validator: IntValidator{bottom: 1}
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }

            Button {
                x: 20
                y: 260
                width: 610
                height: 45
                contentItem: Text {
                    text: "确认保存并向主舱同步投放该任务"
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.pressed ? "#16A085" : "#1ABC9C"
                    radius: 12
                }
                onClicked: {
                    var isRecFlag = Number(cb_type.currentIndex);
                    var pLevel = isRecFlag === 1 ? 1 : Number(cb_priority.currentIndex + 1);
                    var rType = isRecFlag === 1 ? 0 : Number(cb_review.currentIndex);
                    var rInt = (isRecFlag === 0 && rType > 0) ? (parseInt(input_rev_val.text) || 60) : 0;
                    var reward = parseInt(input_reward.text) || 20;
                    var durationHours = parseInt(input_hours.text) || 24;
                    taskManager.addTask(input_name.text, pLevel, durationHours, rType, rInt, reward, isRecFlag);
                    input_name.clear();
                    input_reward.clear();
                    input_hours.clear();
                    input_rev_val.clear();
                }
            }

            Rectangle {
                x: 20
                y: 330
                width: 610
                height: 2
                color: "#80FFFFFF"
            }

            TextField {
                id: input_new_pool
                x: 20
                y: 360
                width: 410
                height: 40
                placeholderText: "向推荐候选大池中永久追加新条目..."
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }

            Button {
                x: 450
                y: 360
                width: 180
                height: 40
                contentItem: Text {
                    text: "确认追加候选"
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.pressed ? "#2C3E50" : "#34495E"
                    radius: 10
                }
                onClicked: {
                    taskManager.addRecPool(input_new_pool.text);
                    input_new_pool.clear();
                }
            }
        }

        Rectangle {
            id: rect_priority_rules
            x: 690
            y: 580
            width: 650
            height: 250
            color: "#B0E0E6"
            radius: 24

            Text {
                x: 25
                y: 20
                text: "核心任务优先级临期警告机制说明"
                color: "#34495E"
                font.pixelSize: 22
                font.bold: true
            }

            Rectangle {
                x: 15
                y: 65
                width: 620
                height: 165
                color: "#80FFFFFF"
                radius: 16

                Text {
                    x: 20
                    y: 15
                    width: 580
                    text: "• 优先级 P5 (最高级) : 每隔 1 小时 触发一次临期物理抖动预警\n• 优先级 P4 (次高级) : 每隔 3 小时 触发一次临期物理抖动预警\n• 优先级 P3 (中级档) : 每隔 6 小时 触发一次临期物理抖动预警\n• 优先级 P2 (次低级) : 每隔 12 小时 触发一次临期物理抖动预警\n• 优先级 P1 (最低级) : 每隔 24 小时 触发一次临期物理抖动预警\n高优先级任务在逼近截止期时，会强制中枢以极高的频率进行密集弹窗及晃动提醒。"
                    color: "#5D6D7E"
                    font.pixelSize: 10
                    lineHeight: 1.5
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
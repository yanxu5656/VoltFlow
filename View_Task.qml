import QtQuick
import QtQuick.Controls

Item {
    id: view_task
    width: 1600
    height: 900

    Rectangle {
        anchors.fill: parent
        color: "#B0F2DE"

        Rectangle {
            id: rect_box
            x: 50
            y: 60
            width: 600
            height: 780
            color: "#B0E0E6"
            radius: 24

            Text {
                id: txt_title
                x: 25
                y: 20
                text: "任务与系统推荐配置面板"
                color: "#34495E"
                font.pixelSize: 24
                font.bold: true
            }

            Text {
                x: 25
                y: 65
                text: "点击下方系统推荐项，可直接载入详细编辑区:"
                color: "#5D6D7E"
                font.pixelSize: 14
            }
            Rectangle {
                x: 20
                y: 90
                width: 560
                height: 140
                color: "#80FFFFFF"
                radius: 16

                ListView {
                    anchors.fill: parent
                    anchors.margins: 10
                    model: taskManager.sysRecs
                    clip: true
                    spacing: 6
                    delegate: Rectangle {
                        width: parent.width
                        height: 40
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

            Text {
                x: 25
                y: 245
                text: "当前正在执行中的活动任务列表:"
                color: "#5D6D7E"
                font.pixelSize: 14
            }
            Rectangle {
                x: 20
                y: 270
                width: 560
                height: 180
                color: "#80FFFFFF"
                radius: 16

                ListView {
                    anchors.fill: parent
                    anchors.margins: 10
                    model: taskManager.userTasks
                    clip: true
                    spacing: 6
                    delegate: Rectangle {
                        width: parent.width
                        height: 40
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

            TextField {
                id: input_name
                x: 20
                y: 480
                width: 380
                height: 40
                placeholderText: "输入正在编辑的任务主题具体内容..."
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }
            ComboBox {
                id: cb_type
                x: 410
                y: 480
                width: 170
                height: 40
                model: ["普通任务", "系统推荐属性"]
                currentIndex: 0
            }

            TextField {
                id: input_reward
                x: 20
                y: 535
                width: 180
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
                x: 210
                y: 535
                width: 180
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
                x: 400
                y: 535
                width: 180
                height: 40
                model: ["优先级 1 (低)", "优先级 2", "优先级 3", "优先级 4", "优先级 5 (高)"]
                currentIndex: 2
                visible: cb_type.currentIndex === 0
            }

            ComboBox {
                id: cb_review
                x: 20
                y: 590
                width: 260
                height: 40
                model: ["关闭留存复习提醒", "开启自定分钟循环", "开启艾宾浩斯判定"]
                currentIndex: 0
                visible: cb_type.currentIndex === 0
            }
            TextField {
                id: input_rev_val
                x: 300
                y: 590
                width: 280
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
                y: 650
                width: 560
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

            TextField {
                id: input_new_pool
                x: 20
                y: 720
                width: 380
                height: 40
                placeholderText: "向推荐候选大池中永久追加新条目..."
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }
            Button {
                x: 410
                y: 720
                width: 170
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

        Button {
            x: 740
            y: 750
            width: 120
            height: 50
            contentItem: Text {
                text: "返回大厅"
                color: "white"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                color: "#95A5A6"
                radius: 12
            }
            onClicked: stack.pop()
        }
    }
}
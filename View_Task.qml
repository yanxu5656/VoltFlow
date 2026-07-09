// 任务舱配置后台：向 C++ 直接传送纯整型持续时间，规避 JS Date 到 C++ 反射故障
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
            color: "#8ED9F6"
            border.color: "#1ABC9C"
            border.width: 4
            Text { id: txt_title; x: 20; y: 20; text: "任务与系统推荐配置面板"; color: "#FFFFD6"; font.pixelSize: 24; font.bold: true }

            Text { x: 20; y: 65; text: "点击下方系统推荐项，可直接载入详细编辑区:"; color: "#FFFFD6"; font.pixelSize: 14 }
            Rectangle {
                x: 20;
                y: 90; width: 560; height: 140; color: "#ADCEC8"; border.color: "#1ABC9C"; border.width: 2
                ListView {
                    anchors.fill: parent; anchors.margins: 5; model: taskManager.sysRecs; clip: true
                    delegate: Rectangle {
                        width: parent.width; height: 40; color: "transparent"
                        Text { anchors.verticalCenter: parent.verticalCenter; x: 10; text: "💡 " + modelData.name; color: "#FFFFD6"; font.pixelSize: 15; font.bold: true }
                        Row {
                            anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter; spacing: 5
                            Button { text: "详细编辑"; height: 30; onClicked: { input_name.text = modelData.name; cb_type.currentIndex = 1; } }
                            Button { text: "清理"; height: 30; onClicked: taskManager.removeTask(modelData.id, true) }
                        }
                    }
                }
            }

            Text { x: 20; y: 245; text: "当前正在执行中的活动任务列表:"; color: "#FFFFD6"; font.pixelSize: 14 }
            Rectangle {
                x: 20;
                y: 270; width: 560; height: 180; color: "#ADCEC8"; border.color: "#1ABC9C"; border.width: 2
                ListView {
                    anchors.fill: parent; anchors.margins: 5; model: taskManager.userTasks; clip: true
                    delegate: Rectangle {
                        width: parent.width; height: 40; color: "transparent"
                        Text { anchors.verticalCenter: parent.verticalCenter; x: 10; text: (modelData.is_rec === 1 ? "[推荐] " : "[自定] ") + modelData.name; color: "#FFFFD6"; font.pixelSize: 15 }
                        Button { anchors.right: parent.right; anchors.rightMargin: 10; anchors.verticalCenter: parent.verticalCenter; text: "废弃"; height: 30; onClicked: taskManager.removeTask(modelData.id, false) }
                    }
                }
            }

            Rectangle { x: 20; y: 465; width: 560; height: 2; color: "#1ABC9C" }
            TextField { id: input_name; x: 20; y: 480; width: 380; height: 40; placeholderText: "输入正在编辑的任务主题具体内容..." }
            ComboBox {
                id: cb_type;
                x: 410; y: 480; width: 170; height: 40
                model: ["普通任务", "系统推荐属性"]
                currentIndex: 0
            }

            TextField { id: input_reward; x: 20; y: 535; width: 180; height: 40; placeholderText: "能量加分(如25)"; validator: IntValidator{bottom: 1} }
            TextField { id: input_hours; x: 210; y: 535; width: 180; height: 40; placeholderText: "限时完成(小时)"; validator: IntValidator{bottom: 1} }
            ComboBox {
                id: cb_priority;
                x: 400; y: 535; width: 180; height: 40
                model: ["优先级 1 (低)", "优先级 2", "优先级 3", "优先级 4", "优先级 5 (高)"]
                currentIndex: 2;
                visible: cb_type.currentIndex === 0
            }

            ComboBox {
                id: cb_review;
                x: 20; y: 590; width: 260; height: 40
                model: ["关闭留存复习提醒", "开启自定分钟循环", "开启艾宾浩斯判定"]
                currentIndex: 0;
                visible: cb_type.currentIndex === 0
            }
            TextField {
                id: input_rev_val;
                x: 300; y: 590; width: 280; height: 40; placeholderText: "输入具体循环复习间隔(分钟)"
                visible: cb_review.currentIndex > 0 && cb_type.currentIndex === 0;
                validator: IntValidator{bottom: 1}
            }

            Button {
                x: 20;
                y: 650; width: 560; height: 45; text: "确认保存并向主舱同步投放该任务"
                onClicked: {
                    var isRecFlag = Number(cb_type.currentIndex);
                    var pLevel = isRecFlag === 1 ? 1 : Number(cb_priority.currentIndex + 1);
                    var rType = isRecFlag === 1 ? 0 : Number(cb_review.currentIndex);
                    var rInt = (isRecFlag === 0 && rType > 0) ? (parseInt(input_rev_val.text) || 60) : 0;
                    var reward = parseInt(input_reward.text) || 20;
                    var durationHours = parseInt(input_hours.text) || 24; // 💡 直接获取纯数字小时数

                    // 💡 修复重点：直接给C++传递纯数字基础参数类型，避开JS Date映射崩溃
                    taskManager.addTask(input_name.text, pLevel, durationHours, rType, rInt, reward, isRecFlag);
                    input_name.clear(); input_reward.clear(); input_hours.clear(); input_rev_val.clear();
                }
            }

            Rectangle { x: 20; y: 710; width: 560; height: 2; color: "#1ABC9C" }
            TextField { id: input_new_pool; x: 20; y: 725; width: 380; height: 40; placeholderText: "向推荐候选大池中永久追加新条目..." }
            Button { x: 420; y: 725; width: 160; height: 40; text: "确认追加候选"; onClicked: { taskManager.addRecPool(input_new_pool.text); input_new_pool.clear(); } }
        }

        Button { x: 740; y: 750; width: 120; height: 50; text: "返回大厅"; onClicked: stack.pop() }
    }
}
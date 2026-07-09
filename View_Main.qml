// 主厅视图：修复qMin为Math.min环境函数，确保电量填充与Canvas趋势线绘制稳健
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: view_main
    width: 1600
    height: 900

    Rectangle {
        id: rect_tasks
        x: 50
        y: 60
        width: 470
        height: 480
        color: "#8ED9F6"
        border.color: "#1ABC9C"
        border.width: 4

        Text {
            x: 20
            y: 15
            text: "自定义任务列表"
            color: "#FFFFD6"
            font.pixelSize: 24
            font.bold: true
        }

        Rectangle {
            x: 20
            y: 60
            width: 430
            height: 400
            color: "#ADCEC8"
            border.color: "#1ABC9C"
            border.width: 2

            ListView {
                anchors.fill: parent
                anchors.margins: 10
                model: taskManager.userTasks
                clip: true
                spacing: 12

                delegate: Rectangle {
                    width: parent.width
                    height: 110
                    color: "#25000000"
                    border.color: "#1ABC9C"
                    border.width: 2
                    radius: 8

                    Rectangle {
                        anchors.fill: parent
                        color: modelData.is_rec === 1 ? "#20FFD700" : "transparent"
                        radius: 6
                    }

                    ColumnLayout {
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 8

                        Text {
                            text: (modelData.is_rec === 1 ? "💡 [推荐] " : "📌 [自定] ") + modelData.name
                            color: "#FFFFD6"
                            font.pixelSize: 17
                            font.bold: true
                        }

                        RowLayout {
                            spacing: 20
                            Text {
                                text: "🔥 优先级: P" + modelData.priority
                                color: "#FFBE76"
                                font.pixelSize: 13
                            }
                            Text {
                                text: "⚡ 能量奖励: +" + modelData.energy_reward
                                color: "#1ABC9C"
                                font.pixelSize: 14
                                font.bold: true
                            }
                        }

                        RowLayout {
                            spacing: 15
                            Text {
                                text: "🔄 复习: " + (modelData.review_type === 0 ? "未开启" : (modelData.review_type === 1 ? "自定义循环" : "艾宾浩斯"))
                                color: "#FFFFD6"
                                font.pixelSize: 13
                            }
                            Text {
                                text: "🗓️ 截止: " + Qt.formatDateTime(modelData.deadline, "MM-dd HH:mm")
                                color: "#FF6B6B"
                                font.pixelSize: 13
                                font.bold: true
                            }
                        }
                    }

                    Button {
                        id: btn_done
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        width: 80
                        height: 45
                        text: "结束"
                        font.pixelSize: 16
                        font.bold: true
                        onClicked: taskManager.completeTask(modelData.id)
                    }
                }
            }
        }
    }

    Rectangle {
        id: rect_recs
        x: 50
        y: 560
        width: 470
        height: 320
        color: "#8ED9F6"
        border.color: "#1ABC9C"
        border.width: 4

        Text {
            x: 20
            y: 15
            text: "系统推荐列表"
            color: "#FFFFD6"
            font.pixelSize: 24
            font.bold: true
        }

        Rectangle {
            x: 20
            y: 60
            width: 430
            height: 240
            color: "#ADCEC8"
            border.color: "#1ABC9C"
            border.width: 2

            ListView {
                anchors.fill: parent
                anchors.margins: 10
                model: taskManager.sysRecs
                clip: true
                spacing: 6
                delegate: Rectangle {
                    width: parent.width
                    height: 45
                    color: "#12000000"
                    border.color: "#1ABC9C"
                    border.width: 1
                    radius: 4
                    Text { anchors.verticalCenter: parent.verticalCenter; x: 12; text: "💡 " + modelData.name; color: "#FFFFD6"; font.pixelSize: 15 }
                }
            }
        }
    }

    Shape {
        id: liubianxing
        width: 470
        height: 470
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 40
        ShapePath {
            strokeColor: "#1ABC9C"
            strokeWidth: 5
            fillColor: "#ADCEC8"
            startX: liubianxing.width / 2
            startY: 10
            PathLine { x: liubianxing.width - 10; y: 10 + (liubianxing.height - 20) * 0.25 }
            PathLine { x: liubianxing.width - 10; y: 10 + (liubianxing.height - 20) * 0.75 }
            PathLine { x: liubianxing.width / 2; y: liubianxing.height - 10 }
            PathLine { x: 10; y: 10 + (liubianxing.height - 20) * 0.75 }
            PathLine { x: 10; y: 10 + (liubianxing.height - 20) * 0.25 }
            PathLine { x: liubianxing.width / 2; y: 10 }
        }
    }

    Item {
        id: core_battery
        width: 140
        height: 240
        anchors.centerIn: liubianxing
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: taskManager.isSuperCharged ? "#FFD700" : "#1ABC9C"
            border.width: 4
            radius: 8
            Rectangle {
                width: 40
                height: 12
                color: parent.border.color
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 3
            }
            Rectangle {
                width: parent.width - 16
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                // 💡 修复：将qMin替换为Math.min
                height: (parent.height - 16) * (Math.min(taskManager.currentEnergy, 100) / 100.0)
                color: taskManager.isSuperCharged ? "#FFD700" : "#1ABC9C"
                radius: 4
                Behavior on height { NumberAnimation { duration: 400 } }
            }
            Text {
                anchors.centerIn: parent
                text: taskManager.currentEnergy + "%"
                color: taskManager.isSuperCharged ? "#FF4500" : "#FFFFD6"
                font.pixelSize: 28
                font.bold: true
            }
        }
        PropertyAnimation {
            target: core_battery
            property: "opacity"
            from: 0.6
            to: 1.0
            duration: 800
            running: taskManager.isSuperCharged
            loops: Animation.Infinite
        }
    }

    Rectangle {
        id: pop_bubble
        width: 260
        height: 75
        anchors.horizontalCenter: liubianxing.horizontalCenter
        anchors.bottom: liubianxing.top
        anchors.bottomMargin: -20
        color: window.isReviewAlert ? "#FF6B6B" : "#FFBE76"
        radius: 12
        visible: window.alertMsg !== ""
        border.color: "#FFFFD6"
        border.width: 2
        Text {
            anchors.fill: parent
            anchors.margins: 10
            text: window.alertMsg
            color: "#FFFFD6"
            font.pixelSize: 14
            font.bold: true
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            text: "✖"
            color: "#FFFFD6"
            font.pixelSize: 14
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 6
            anchors.rightMargin: 8
            MouseArea { anchors.fill: parent; onClicked: window.alertMsg = "" }
        }
    }

    Rectangle {
        id: rect_stats
        x: 1080
        y: 60
        width: 470
        height: 200
        color: "#8ED9F6"
        border.color: "#1ABC9C"
        border.width: 4
        Text { x: 20; y: 15; text: "今日数据分析"; color: "#FFFFD6"; font.pixelSize: 24; font.bold: true }
        RowLayout {
            x: 20
            y: 70
            width: 430
            spacing: 50
            ColumnLayout {
                Text { text: "今日添加数"; color: "#FFFFD6"; font.pixelSize: 18; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                Text { text: taskManager.tasksAddedToday.toString(); color: "#1ABC9C"; font.pixelSize: 40; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            }
            ColumnLayout {
                Text { text: "当前完成率"; color: "#FFFFD6"; font.pixelSize: 18; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                Text { text: taskManager.taskCompletionRate + "%"; color: "#1ABC9C"; font.pixelSize: 40; font.bold: true; Layout.alignment: Qt.AlignHCenter }
            }
        }
    }

    Rectangle {
        id: rect_chart
        x: 1080
        y: 300
        width: 470
        height: 580
        color: "#8ED9F6"
        border.color: "#1ABC9C"
        border.width: 4
        Text { x: 20; y: 15; text: "周期能量流转趋势"; color: "#FFFFD6"; font.pixelSize: 24; font.bold: true }
        Canvas {
            id: canvas_line
            anchors.fill: parent
            anchors.topMargin: 70
            anchors.bottomMargin: 30
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.strokeStyle = "#251ABC9C";
                ctx.lineWidth = 1;
                for (var i = 0; i <= 4; i++) {
                    var yGrid = height * (i / 4);
                    ctx.beginPath(); ctx.moveTo(0, yGrid); ctx.lineTo(width, yGrid); ctx.stroke();
                }
                // 💡 修复：将qMin替换为Math.min
                var dataset = [45, 60, 85, 40, 95, 70, Math.min(taskManager.currentEnergy, 150)];
                var stepX = width / (dataset.length - 1);
                ctx.strokeStyle = taskManager.isSuperCharged ? "#FFD700" : "#1ABC9C";
                ctx.lineWidth = 3; ctx.beginPath();
                for (var j = 0; j < dataset.length; j++) {
                    var ptY = height - (dataset[j] / 150.0) * height;
                    var ptX = j * stepX;
                    if (j === 0) ctx.moveTo(ptX, ptY);
                    else ctx.lineTo(ptX, ptY);
                }
                ctx.stroke();
                for (var k = 0; k < dataset.length; k++) {
                    var pY = height - (dataset[k] / 150.0) * height;
                    var pX = k * stepX;
                    ctx.fillStyle = (k === dataset.length - 1) ? (taskManager.isSuperCharged ? "#FF4500" : "#FFFFD6") : "#1ABC9C";
                    ctx.beginPath(); ctx.arc(pX, pY, 5, 0, 2 * Math.PI); ctx.fill();
                }
            }
            Connections {
                target: taskManager
                function onEnergyChanged() { canvas_line.requestPaint(); }
            }
        }
    }

    Rectangle {
        x: 630
        y: 20
        width: 340
        height: 45
        color: "#ADCEC8"
        radius: 6
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatDateTime(taskManager.currentTime, "yyyy-MM-dd HH:mm")
            color: "#FFFFD6"
            font.pixelSize: 16
            font.bold: true
        }
        Button {
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "+1小时演示"
            onClicked: taskManager.addDemoTime(1)
        }
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

    Shape {
        id: sanjiaoxing_zuo
        width: 1600
        height: 900
        ShapePath { strokeColor: "#1ABC9C"; strokeWidth: 4; fillColor: "#8ED9F6"; startX: 570; startY: 360; PathLine { x: 570; y: 60 } PathLine { x: 790; y: 250 } PathLine { x: 570; y: 360 } }
        MouseArea { x: 570; y: 60; width: 220; height: 300; onClicked: stack.push("View_Task.qml") }
    }
    Text { x: 590; y: 215; text: "管理任务"; color: "#FFFFD6"; font.pixelSize: 24; font.bold: true }

    Shape {
        id: sanjiaoxing_you
        width: 1600
        height: 900
        ShapePath { strokeColor: "#1ABC9C"; strokeWidth: 4; fillColor: "#8ED9F6"; startX: 1030; startY: 360; PathLine { x: 1030; y: 60 } PathLine { x: 810; y: 250 } PathLine { x: 1030; y: 360 } }
        MouseArea { x: 810; y: 60; width: 220; height: 300; onClicked: stack.push("View_Set.qml") }
    }
    Text { x: 890; y: 215; text: "时间设置"; color: "#FFFFD6"; font.pixelSize: 24; font.bold: true }

    Shape {
        id: sanjiaoxing_xia
        width: 1600
        height: 900
        ShapePath { strokeColor: "#1ABC9C"; strokeWidth: 4; fillColor: "#8ED9F6"; startX: 800; startY: 730; PathLine { x: 860; y: 880 } PathLine { x: 740; y: 880 } PathLine { x: 800; y: 730 } }
        MouseArea { x: 740; y: 730; width: 120; height: 150; onClicked: stack.push("View_Store.qml") }
    }
    Text { x: 776; y: 815; text: "商店"; color: "#FFFFD6"; font.pixelSize: 24; font.bold: true }
}
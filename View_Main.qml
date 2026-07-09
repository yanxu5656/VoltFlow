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
        color: "#B0E0E6"
        radius: 20

        Text {
            x: 25
            y: 20
            text: "任务列表"
            color: "#34495E"
            font.pixelSize: 24
            font.bold: true
                }

        Rectangle {
            x: 15
            y: 70
            width: 440
            height: 390
            color: "#80FFFFFF"
            radius: 16

            ListView {
                anchors.fill: parent
                anchors.margins: 10
                model: taskManager.userTasks
                clip: true
                spacing: 10
                delegate: Rectangle {
                    width: parent.width
                    height: 115
                    color: "#F0F8FF"
                    radius: 12

                    Rectangle {
                        anchors.fill: parent
                        color: modelData.is_rec === 1 ? "#20FFD700" : "transparent"
                        radius: 12
                    }

                    ColumnLayout {
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6
                        Text {
                            text: (modelData.is_rec === 1 ? "💡 [推荐] " : "📌 [自定] ") + modelData.name
                            color: "#2C3E50"
                            font.pixelSize: 17
                            font.bold: true
                        }
                        Text {
                            text: "🔥 P" + modelData.priority + " | ⚡奖励: +" + modelData.energy_reward
                            color: "#7F8C8D"
                            font.pixelSize: 13
                        }
                        Text {
                            text: "🗓️ " + Qt.formatDateTime(modelData.deadline, "MM-dd HH:mm")
                            color: "#1ABC9C"
                            font.pixelSize: 13
                            font.bold: true
                        }
                    }

                    Button {
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        width: 70
                        height: 40
                        contentItem: Text {
                            text: "结束"
                            color: "white"
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.pressed ? "#16A085" : "#1ABC9C"
                            radius: 8
                        }
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
        color: "#B0E0E6"
        radius: 20

        Text {
            x: 25
            y: 15
            text: "系统推荐任务"
            color: "#34495E"
            font.pixelSize: 22
            font.bold: true
        }

        Rectangle {
            x: 15
            y: 55
            width: 440
            height: 250
            color: "#80FFFFFF"
            radius: 16
            ListView {
                anchors.fill: parent
                anchors.margins: 10
                model: taskManager.sysRecs
                clip: true
                spacing: 10
                delegate: Rectangle {
                    width: parent.width
                    height: 50
                    color: "#F0F8FF"
                    radius: 10
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        text: "💡 " + modelData.name
                        color: "#34495E"
                        font.pixelSize: 15
                        font.bold: true
                    }
                    Button {
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        width: 65
                        height: 32
                        contentItem: Text {
                            text: "激活"
                            color: "white"
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        background: Rectangle {
                            color: parent.pressed ? "#2C3E50" : "#34495E"
                            radius: 6
                        }
                        onClicked: taskManager.activateRecommendation(modelData.name)
                    }
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
            strokeColor: "transparent"
            fillColor: "#B0E0E6"
            startX: liubianxing.width / 2
            startY: 10
            PathLine {
                x: liubianxing.width - 10
                y: 10 + (liubianxing.height - 20) * 0.25
            }
            PathLine {
                x: liubianxing.width - 10
                y: 10 + (liubianxing.height - 20) * 0.75
            }
            PathLine {
                x: liubianxing.width / 2
                y: liubianxing.height - 10
            }
            PathLine {
                x: 10
                y: 10 + (liubianxing.height - 20) * 0.75
            }
            PathLine {
                x: 10
                y: 10 + (liubianxing.height - 20) * 0.25
            }
            PathLine {
                x: liubianxing.width / 2
                y: 10
            }
        }
    }

    Item {
        id: core_battery
        width: 140
        height: 240
        anchors.centerIn: liubianxing
        Rectangle {
            anchors.fill: parent
            color: "#40FFFFFF"
            radius: 15
            Rectangle {
                width: 40
                height: 12
                color: "#B0E0E6"
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 4
            }
            Rectangle {
                width: parent.width - 16
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8
                height: (parent.height - 16) * (Math.min(taskManager.currentEnergy, 100) / 100.0)
                color: taskManager.isSuperCharged ? "#FFD700" : "#1ABC9C"
                radius: 10
                Behavior on height {
                    NumberAnimation {
                        duration: 400
                    }
                }
            }
            Text {
                anchors.centerIn: parent
                text: taskManager.currentEnergy + "%"
                color: "#2C3E50"
                font.pixelSize: 32
                font.bold: true
            }
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
            MouseArea {
                anchors.fill: parent
                onClicked: window.alertMsg = ""
            }
        }
    }

    Rectangle {
        id: rect_stats
        x: 1080
        y: 60
        width: 470
        height: 200
        color: "#B0E0E6"
        radius: 20
        Text {
            x: 25
            y: 20
            text: "今日效率洞察"
            color: "#34495E"
            font.pixelSize: 24
            font.bold: true
        }
        RowLayout {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 20
            spacing: 60
            Column {
                Text {
                    text: "今日添加"
                    color: "#7F8C8D"
                    font.pixelSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: taskManager.tasksAddedToday
                    color: "#1ABC9C"
                    font.pixelSize: 44
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
            Column {
                Text {
                    text: "完成率"
                    color: "#7F8C8D"
                    font.pixelSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text {
                    text: taskManager.taskCompletionRate + "%"
                    color: "#1ABC9C"
                    font.pixelSize: 44
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Rectangle {
        id: rect_chart
        x: 1080
        y: 300
        width: 470
        height: 580
        color: "#B0E0E6"
        radius: 20
        Text {
            x: 25
            y: 20
            text: "周期注能趋势"
            color: "#34495E"
            font.pixelSize: 24
            font.bold: true
        }
        Canvas {
            id: canvas_line
            anchors.fill: parent
            anchors.margins: 40
            anchors.topMargin: 90
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                var dataset = taskManager.historicalEnergy;
                if (dataset.length === 0) return;
                var stepX = width / (dataset.length - 1);
                ctx.strokeStyle = taskManager.isSuperCharged ? "#FFD700" : "#1ABC9C";
                ctx.lineWidth = 4;
                ctx.beginPath();
                for (var j = 0; j < dataset.length; j++) {
                    var ptY = height - (Math.min(dataset[j], 150) / 150.0) * (height - 20);
                    if (j === 0) ctx.moveTo(0, ptY);
                    else ctx.lineTo(j * stepX, ptY);
                }
                ctx.stroke();
                ctx.font = "bold 13px sans-serif";
                ctx.textAlign = "center";
                for (var k = 0; k < dataset.length; k++) {
                    var pY = height - (Math.min(dataset[k], 150) / 150.0) * (height - 20);
                    var pX = k * stepX;
                    ctx.fillStyle = (k === dataset.length - 1) ? "#FF4500" : "#1ABC9C";
                    ctx.beginPath();
                    ctx.arc(pX, pY, 5, 0, 2 * Math.PI);
                    ctx.fill();
                    ctx.fillStyle = "#34495E";
                    ctx.fillText(dataset[k].toString(), pX, pY - 12);
                }
            }
            Connections {
                target: taskManager
                function onHistoricalEnergyChanged() {
                    canvas_line.requestPaint();
                }
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

    Shape {
        id: sanjiaoxing_zuo
        width: 1600
        height: 900
        ShapePath {
            strokeColor: "transparent"
            fillColor: "#B0E0E6"
            startX: 570
            startY: 360
            PathLine {
                x: 570
                y: 60
            }
            PathLine {
                x: 790
                y: 250
            }
            PathLine {
                x: 570
                y: 360
            }
        }
        MouseArea {
            x: 570
            y: 60
            width: 220
            height: 300
            onClicked: stack.push("View_Task.qml")
        }
    }

    Text {
        x: 590
        y: 215
        text: "管理任务"
        color: "#34495E"
        font.pixelSize: 24
        font.bold: true
    }

    Shape {
        id: sanjiaoxing_you
        width: 1600
        height: 900
        ShapePath {
            strokeColor: "transparent"
            fillColor: "#B0E0E6"
            startX: 1030
            startY: 360
            PathLine {
                x: 1030
                y: 60
            }
            PathLine {
                x: 810
                y: 250
            }
            PathLine {
                x: 1030
                y: 360
            }
        }
        MouseArea {
            x: 810
            y: 60
            width: 220
            height: 300
            onClicked: stack.push("View_Set.qml")
        }
    }

    Text {
        x: 890
        y: 215
        text: "时间设置"
        color: "#34495E"
        font.pixelSize: 24
        font.bold: true
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
            onClicked: stack.push("View_Store.qml")
        }
    }

    Text {
        x: 776
        y: 815
        text: "商店"
        color: "#34495E"
        font.pixelSize: 24
        font.bold: true
    }
}
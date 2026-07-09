// 商店物资补给舱视图：提供能量道具和兑换看板占位
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Item {
    id: view_store
    width: 1600
    height: 900

    Rectangle {
        anchors.fill: parent
        color: "#B0F2DE"

        Rectangle {
            id: rect_store_box
            x: 50
            y: 60
            width: 600
            height: 700
            color: "#8ED9F6"
            border.color: "#1ABC9C"
            border.width: 4

            Text {
                id: txt_store_title
                x: 20
                y: 20
                text: "伏流能量商店"
                color: "#FFFFD6"
                font.pixelSize: 28
                font.bold: true
            }

            Rectangle {
                x: 20
                y: 80
                width: 560
                height: 580
                color: "#ADCEC8"
                border.color: "#1ABC9C"
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "物资舱升级中，后续开放能量值兑换权益..."
                    color: "#FFFFD6"
                    font.pixelSize: 20
                    font.bold: true
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
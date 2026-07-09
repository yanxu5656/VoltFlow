import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: view_set

    property int weeklyEnergy: 0
    property int totalEnergy: 0

    Shape {
        id: liubianxing
        width: 470
        height: 470
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 40
        layer.enabled: true

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
            onClicked: {
                stack.pop()
            }
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

        Text {
            id: label_weekly
            anchors.horizontalCenter: parent.horizontalCenter
            y: 15
            text: "周能量值"
            color: "#FFFFD6"
            font.pixelSize: 22
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: label_weekly.bottom
            anchors.topMargin: 5
            text: view_main.weeklyEnergy
            color: "#FFFFD6"
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
        color: "#8ED9F6"
        border.color: "#1ABC9C"
        border.width: 4

        Text {
            id: label_total
            anchors.horizontalCenter: parent.horizontalCenter
            y: 15
            text: "总能量值"
            color: "#FFFFD6"
            font.pixelSize: 22
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: label_total.bottom
            anchors.topMargin: 5
            text: view_main.totalEnergy
            color: "#FFFFD6"
            font.pixelSize: 20
            font.bold: true
        }
    }
}
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item{
    id:view_main
    // ======================= 左侧核心区（绝对定位） =======================
        Rectangle {
            x: 20
            y: 20
            width: 400
            height: 860
            color: "#FFFFFF"
            radius: 12
            opacity: 0.85

            Text { text: "左侧：任务列表"; anchors.centerIn: parent; font.pixelSize: 18 }
        }

        // ======================= 右侧分析区（绝对定位） =======================
        Rectangle {
            x: 1180 // 1600 - 400 - 20
            y: 20
            width: 400
            height: 860
            color: "#FFFFFF"
            radius: 12
            opacity: 0.85

            Text { text: "右侧：数据分析与番茄钟"; anchors.centerIn: parent; font.pixelSize: 18 }
        }

        // ======================= 中间动力舱（绝对定位） =======================
        // 中间区域的实际边界是 x 在 420 到 1180 之间，宽度一共 760

        // 1. 顶部按钮
        Button {
            x: 440
            y: 20
            width: 80
            height: 40
            text: "管理"
        }

        Button {
            x: 1080 // 靠近右侧边缘
            y: 20
            width: 80
            height: 40
            text: "日期"
        }

        // 2. 正中央的科技感六边形
        Shape {
            id: hexagon
            // 让六边形在中间 760 像素的区域里绝对居中
            x: 440 + (760 - width) / 2 // 计算得出绝对 X 坐标
            y: 200                     // 绝对 Y 坐标
            width: 350
            height: 350
            layer.enabled: true
            layer.samples: 4 // 抗锯齿

            ShapePath {
                strokeColor: "#1ABC9C"
                strokeWidth: 5
                fillColor: "transparent"

                startX: hexagon.width / 2
                startY: 0

                PathLine { x: hexagon.width; y: hexagon.height * 0.25 }
                PathLine { x: hexagon.width; y: hexagon.height * 0.75 }
                PathLine { x: hexagon.width / 2; y: hexagon.height }
                PathLine { x: 0; y: hexagon.height * 0.75 }
                PathLine { x: 0; y: hexagon.height * 0.25 }
                PathLine { x: hexagon.width / 2; y: 0 }
            }

            // 电池预留文字直接挂在六边形正中心
            Text {
                text: "🔋\n电池动力舱"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 20
                color: "#2C3E50"
            }
        }

        // 3. 底部能量结算状态栏
        Rectangle {
            x: 440
            y: 800
            width: 720
            height: 80
            color: "#FFFFFF"
            radius: 12
            opacity: 0.85

            // 内部的小元素我们用简单的精确定位即可
            Text {
                x: 20
                anchors.verticalCenter: parent.verticalCenter
                text: "🔋 周能量值"
                font.bold: true
            }

            Button {
                anchors.centerIn: parent
                width: 120
                height: 40
                text: "🛒 进入商店"
                onClicked: stack.push("StoreView.qml")
            }

            Text {
                x: parent.width - 100
                anchors.verticalCenter: parent.verticalCenter
                text: "💎 总能量值"
                font.bold: true
            }
        }
}
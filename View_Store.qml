import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: view_store
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
            id: rect_shop_box
            x: 50
            y: 80
            width: 600
            height: 700
            color: "#B0E0E6"
            radius: 24

            Text {
                x: 25
                y: 20
                text: "商店小铺商品列表"
                color: "#34495E"
                font.pixelSize: 24
                font.bold: true
            }

            Rectangle {
                x: 20
                y: 70
                width: 560
                height: 600
                color: "#80FFFFFF"
                radius: 16

                ListView {
                    anchors.fill: parent
                    anchors.margins: 15
                    model: taskManager.storeItems
                    clip: true
                    spacing: 10
                    delegate: Rectangle {
                        width: parent.width
                        height: 55
                        color: "#F0F8FF"
                        radius: 12
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: 15
                            text: "📦 " + modelData.name
                            color: "#2C3E50"
                            font.pixelSize: 16
                            font.bold: true
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: btn_buy.left
                            anchors.rightMargin: 15
                            text: "⚡ " + modelData.price
                            color: "#E67E22"
                            font.pixelSize: 15
                            font.bold: true
                        }
                        Button {
                            id: btn_buy
                            anchors.right: parent.right
                            anchors.rightMargin: 15
                            anchors.verticalCenter: parent.verticalCenter
                            width: 70
                            height: 35
                            contentItem: Text {
                                text: "购买"
                                color: "white"
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: taskManager.totalEnergy >= modelData.price ? (parent.pressed ? "#D35400" : "#E67E22") : "#BDC3C7"
                                radius: 8
                            }
                            enabled: taskManager.totalEnergy >= modelData.price
                            onClicked: taskManager.buyItem(modelData.id)
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rect_manage_box
            x: 690
            y: 80
            width: 650
            height: 700
            color: "#B0E0E6"
            radius: 24

            Text {
                x: 25
                y: 20
                text: "商品上架与下架管理中枢"
                color: "#34495E"
                font.pixelSize: 24
                font.bold: true
            }

            TextField {
                id: input_item_name
                x: 20
                y: 70
                width: 300
                height: 40
                placeholderText: "输入新商品名称..."
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }

            TextField {
                id: input_item_price
                x: 340
                y: 70
                width: 130
                height: 40
                placeholderText: "消耗电量"
                validator: IntValidator{bottom: 1}
                background: Rectangle {
                    color: "white"
                    radius: 10
                }
            }

            Button {
                x: 490
                y: 70
                width: 140
                height: 40
                contentItem: Text {
                    text: "上架商品"
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: parent.pressed ? "#16A085" : "#1ABC9C"
                    radius: 10
                }
                onClicked: {
                    taskManager.addStoreItem(input_item_name.text, parseInt(input_item_price.text || "10"));
                    input_item_name.clear();
                    input_item_price.clear();
                }
            }

            Rectangle {
                x: 20
                y: 135
                width: 610
                height: 545
                color: "#80FFFFFF"
                radius: 16

                ListView {
                    anchors.fill: parent
                    anchors.margins: 15
                    model: taskManager.storeItems
                    clip: true
                    spacing: 8
                    delegate: Rectangle {
                        width: parent.width
                        height: 45
                        color: "#F0F8FF"
                        radius: 10
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: 15
                            text: modelData.name + " (⚡" + modelData.price + ")"
                            color: "#34495E"
                            font.pixelSize: 15
                        }
                        Button {
                            anchors.right: parent.right
                            anchors.rightMargin: 15
                            anchors.verticalCenter: parent.verticalCenter
                            width: 70
                            height: 30
                            contentItem: Text {
                                text: "下架"
                                color: "white"
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            background: Rectangle {
                                color: parent.pressed ? "#C0392B" : "#E74C3C"
                                radius: 6
                            }
                            onClicked: taskManager.removeStoreItem(modelData.id)
                        }
                    }
                }
            }
        }
    }
}
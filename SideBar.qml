import QtQuick
import QtQuick.Controls

Rectangle{

    color:"#FFFFFF"
    radius:16
    border.color:"#EEF2F7"
    property int hoverIndex:-1
    property int currentIndex:0

    property var menus:[

        {
            name:"首页",
            icon:"house.svg"
        },
        {
            name:"任务添加",
            icon:"clipboard-plus.svg"
        },
        {
            name:"学习记录",
            icon:"history.svg"
        },
        {
            name:"统计分析",
            icon:"chart-column.svg"
        },
        {
            name:"设置",
            icon:"bolt.svg"
        },
        {
            name:"主题",
            icon:"shirt.svg"
        },
        {
            name:"商店",
            icon:"store.svg"
        }
    ]

    Column{

    anchors.fill:parent
    anchors.margins:20
    spacing:18

    Row{
        spacing:15
        Text{
            text:"☰"
            font.pixelSize:28
            color:"#334155"
        }

        Text{
            text:"VoltFlow"
            font.pixelSize:26
            font.bold:true
            color:"#1E293B"
        }

    }

    Repeater{

    model:menus

    delegate:Rectangle{
        width:220
        height:45
        radius:10
        color:hoverIndex===index?
              "#E9F2FF":
              "#FFFFFF"

        Behavior on color{
            ColorAnimation{
                duration:120
            }
        }

        Row{
                anchors.verticalCenter:parent.verticalCenter
                anchors.left:parent.left
                anchors.leftMargin:10
                spacing:12
                Image{
                    width:20
                    height:20
                    source:
                    "qrc:/qt/qml/VoltFlow/assets/icons/" + modelData.icon
                }

                Text{
                    text:modelData.name
                    color:hoverIndex===index?
                    "#2878FF":
                    "#64748B"
                    font.pixelSize:16
                    verticalAlignment:Text.AlignVCenter
                }
        }

        MouseArea{
            anchors.fill:parent
            hoverEnabled:true
            cursorShape:Qt.PointingHandCursor
            onEntered:{
                hoverIndex=index
            }
            onExited:{
                hoverIndex=-1
            }
        }

    }


    } //repeater
    }
}
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle{

    id:root

    width:300
    height:86

    radius:14
    color:mouse.containsMouse ?
              "#F8FAFC" :
              "#FFFFFF"

    border.color:"#EDF2F7"
    border.width:1

    property int colorIndex:0
    property var accentColors:[
        "#3B82F6",   //蓝
        "#8B5CF6",   //紫
        "#06B6D4",   //青
        "#10B981",   //绿
        "#F59E0B",   //橙
        "#EC4899"    //粉
    ]
    property string taskTitle:""
    property string date:""
    property string status:""
    property color statusColor:"#2F80FF"
    property int taskIndex:0

    signal clicked()
    signal editClicked(
        string title,
        string deadline,
        string taskStatus
    )

    MouseArea{
         id:mouse
         anchors.fill:parent
         hoverEnabled:true
         cursorShape:Qt.PointingHandCursor
         onClicked:root.clicked()
    }

    // 阴影（Qt6兼容）
    Rectangle{
        anchors.fill: parent
        anchors.topMargin:2
        radius:parent.radius
        color:"#10000000"
        z:-1
    }

    // 左侧状态条
    Rectangle{
        width:5
        radius:3

        anchors.left:parent.left
        anchors.top:parent.top
        anchors.bottom:parent.bottom

        color:accentColors[colorIndex]
    }

    RowLayout{

        anchors.fill:parent
        anchors.leftMargin:18
        anchors.rightMargin:14
        spacing:14

        Column{

            Layout.fillWidth:true
            Layout.alignment:Qt.AlignVCenter
            spacing:10

            Text{
                text:taskTitle
                font.pixelSize:19
                font.bold:true
                color:"#1E293B"
            }

            Row{
                spacing:16

                Row{
                    spacing:5

                    Text{                    
                        text:"📅"
                        font.pixelSize:13
                    }
                    Text{
                        text:date
                        color:"#7C8798"
                        font.pixelSize:14
                    }
                }

                Row{
                    spacing:5
                    Text{
                        text:"◉"
                        color:statusColor
                        font.pixelSize:12
                    }
                    Text{
                        text:status
                        color:statusColor
                        font.pixelSize:14
                        font.bold:true
                    }
                }
            }
        }

        Item{
            width:1
            Layout.fillWidth:true
        }

        Rectangle{

            Layout.preferredWidth:36
            Layout.preferredHeight:36
            Layout.alignment:Qt.AlignVCenter

            radius:10
            color:"#FFFFFF"

            Text{
                anchors.centerIn:parent
                text:"⋮"
                font.pixelSize:28
                color:"#64748B"
            }

            MouseArea{
                   id:menuMouse
                   anchors.fill:parent
                   hoverEnabled:true
                   cursorShape:Qt.PointingHandCursor

                   onClicked:{
                       root.editClicked(
                                   root.taskTitle,
                                   root.date,
                                   root.status
                        )
                   }
            }
        }
    }

}
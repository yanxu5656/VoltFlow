import QtQuick

Rectangle{

    radius:18
    color:"#FFFFFF"
    border.color:"#EEF2F7"

    Column{
        anchors.fill:parent
        anchors.margins:25
        spacing:15

        Text{
            text:"推荐任务"
            font.pixelSize:20
            font.bold:true
            color:"#1E293B"
        }

        Rectangle{
            width:parent.width
            height:70
            radius:12
            color:"#E9F8EF"
            Column{
                anchors.centerIn:parent
                Text{
                    text:"完善Qt动画效果"
                    color:"#166534"
                    font.bold:true
                }
                Text{
                    text:"预计提升 +15 Energy"
                    color:"#64748B"
                    font.pixelSize:13
                }
            }

        }

    }

}
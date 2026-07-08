import QtQuick
import QtQuick.Layouts


Rectangle{


    radius:18

    color:"#FFFFFF"


    border.color:"#EEF2F7"



    Column{


        anchors.fill:parent

        anchors.margins:25


        spacing:18




        Text{


            text:"今日任务分析"

            color:"#1E293B"

            font.pixelSize:22

            font.bold:true

        }





        Rectangle{


            width:parent.width

            height:1


            color:"#EDF1F5"


        }





        DetailRow{

            title:"任务名称"

            value:"Qt Quick界面开发"

        }



        DetailRow{

            title:"任务状态"

            value:"专注中"

        }



        DetailRow{


            title:"开始时间"

            value:"09:00"

        }



        DetailRow{


            title:"预计收益"

            value:"+25 Energy"

        }



        DetailRow{


            title:"优先级"

            value:"高"

        }




        Text{


            text:"任务描述"

            color:"#64748B"

            font.pixelSize:14

        }



        Text{


            text:"完成首页UI设计，实现\nVoltFlow第一版桌面端"


            color:"#334155"

            wrapMode:Text.WordWrap


        }



    }





}

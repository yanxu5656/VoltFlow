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


            text:"今日资源状态"


            font.pixelSize:20


            font.bold:true


            color:"#1E293B"

        }





        ResourceRow{

            icon:"⏱"

            name:"专注时间"

            value:"5.2 h"

        }



        ResourceRow{

            icon:"⚡"

            name:"获得电量"

            value:"+82"

        }



        ResourceRow{

            icon:"🎯"

            name:"PF效率"

            value:"86.4"

        }




    }



}
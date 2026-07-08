import QtQuick

Rectangle{


    width:340

    height:80


    radius:15


    color:"#17232e"



    property string title:""

    property string value:""





    Row{


        anchors.fill:parent


        anchors.margins:20


        spacing:30



        Text{


            text:title


            color:"#91a8b8"


            font.pixelSize:15

        }



        Text{


            text:value


            color:"#ffffff"


            font.pixelSize:20


            font.bold:true


        }


    }


}

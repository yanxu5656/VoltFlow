import QtQuick


Rectangle{


    width:190

    height:42


    radius:10


    color:"#101923"



    property string text:""

    property bool active:false



    Text{


        anchors.centerIn:parent


        text:parent.text


        color:

        active?

        "#43e06f":

        "#b7c8d4"


        font.pixelSize:15

    }



}
import QtQuick


Row{


    width:parent.width


    spacing:20



    Text{


        width:100


        text:title


        color:"#64748B"


        font.pixelSize:15

    }




    Text{


        text:value


        color:"#1E293B"


        font.pixelSize:15

    }



    property string title

    property string value


}
import QtQuick


Column{


spacing:8



property string title

property string value




Text{


text:title


color:"#64748B"


font.pixelSize:15


}



Text{


text:value


color:"#2878FF"


font.pixelSize:32


font.bold:true


}



}
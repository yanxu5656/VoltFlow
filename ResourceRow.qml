import QtQuick


Row{


spacing:15


property string icon

property string name

property string value




Text{


text:icon

font.pixelSize:18


}



Text{


text:name


width:150


color:"#64748B"


}



Text{


text:value


font.bold:true


color:"#1E293B"


}



}
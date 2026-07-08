import QtQuick


Rectangle{


height:65


color:"#FFFFFF"



border.color:"#EDF1F5"



Row{


anchors.fill:parent


anchors.leftMargin:25


spacing:20



Text{

text:"☰"

font.pixelSize:25

color:"#34495E"

}



Text{


text:"VoltFlow"

font.pixelSize:25

font.bold:true

color:"#1F2937"


}



}




Row{


anchors.right:parent.right

anchors.rightMargin:30


anchors.verticalCenter:parent.verticalCenter


spacing:25



Text{

text:"—"

font.pixelSize:22

}



Text{

text:"□"

font.pixelSize:20

}



Text{

text:"×"

font.pixelSize:22

}



}



}
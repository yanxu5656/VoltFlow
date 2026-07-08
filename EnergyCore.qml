import QtQuick
import QtQuick.Layouts


Rectangle{


color:"#FFFFFF"


radius:20

Layout.alignment:Qt.AlignCenter

property int energy:82



Column{


anchors.centerIn:parent


spacing:20



Text{


text:"管理"

color:"#334155"


font.pixelSize:20


}




Rectangle{


width:300

height:300


color:"transparent"



Canvas{


anchors.fill:parent



onPaint:{


var ctx=getContext("2d")


ctx.clearRect(0,0,width,height)


ctx.beginPath()



var cx=width/2

var cy=height/2

var r=120



for(var i=0;i<6;i++){


var angle=Math.PI/3*i-Math.PI/6


var x=cx+r*Math.cos(angle)

var y=cy+r*Math.sin(angle)


if(i===0)
ctx.moveTo(x,y)
else
ctx.lineTo(x,y)


}


ctx.closePath()


ctx.strokeStyle="#2878FF"

ctx.lineWidth=4

ctx.stroke()



}



}



Column{


    width:parent.width

   anchors.verticalCenter:parent.verticalCenter

   spacing:20




Text{
     width:parent.width
      horizontalAlignment:Text.AlignHCenter

text:energy+"%"

font.pixelSize:55

font.bold:true

color:"#1E293B"

}


Text{
     width:parent.width
    horizontalAlignment:Text.AlignHCenter

text:"周电容"

font.pixelSize:20

color:"#64748B"

}


}



}



Text{


text:"🎯 目标\n保持每日专注学习"


horizontalAlignment:Text.AlignHCenter


color:"#64748B"


}



}



}
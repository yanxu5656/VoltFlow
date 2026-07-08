import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


ApplicationWindow {

    id: root

    width: 1440
    height: 820

    visible: true

    title: "VoltFlow"

    color:"#080d13"



    property int capacitor:82



    RowLayout{


        anchors.fill:parent

        spacing:0



        //==========================
        // 左侧菜单栏
        //==========================

        Rectangle{


            Layout.preferredWidth:240

            Layout.fillHeight:true


            color:"#0d141c"



            Column{


                anchors.fill:parent

                anchors.margins:25


                spacing:18



                Text{

                    text:"⚡ VoltFlow"

                    color:"#e5f0f7"

                    font.pixelSize:28

                    font.bold:true

                }



                Text{

                    text:"SELF CONTROL SYSTEM"

                    color:"#60788b"

                    font.pixelSize:11

                }



                Rectangle{

                    width:190

                    height:1

                    color:"#253441"

                }



                MenuButton{

                    text:"⌂  首页"

                    active:true

                }



                MenuButton{

                    text:"＋ 任务添加"

                }



                MenuButton{

                    text:"◷ 学习记录"

                }



                MenuButton{

                    text:"⚙ 设置"

                }



                MenuButton{

                    text:"◐ 主题"

                }



                Item{

                    height:260

                }



                Text{

                    text:"● System Online"

                    color:"#43e06f"

                }


            }

        }






        //==========================
        // 中间电容
        //==========================


        Rectangle{


            Layout.fillWidth:true

            Layout.fillHeight:true


            color:"#0a1017"




            Column{


                anchors.centerIn:parent


                spacing:25




                Text{

                    text:"WEEKLY CAPACITOR"

                    color:"#8fa8bb"

                    font.pixelSize:22

                }



                //竖向电池

                Rectangle{


                    width:160

                    height:450


                    radius:30


                    color:"#111b25"


                    border.width:2


                    border.color:

                    capacitor>=100?
                    "#39ff88":
                    "#34495a"





                    Rectangle{


                        anchors.bottom:parent.bottom


                        anchors.horizontalCenter:parent.horizontalCenter



                        width:120


                        height:

                        400*capacitor/100



                        radius:22



                        color:

                        capacitor<30?

                        "#ff304f":

                        capacitor<70?

                        "#ffc857":

                        "#39d353"





                        SequentialAnimation on opacity{


                            running:capacitor>=100

                            loops:Animation.Infinite



                            NumberAnimation{

                                from:1

                                to:0.4

                                duration:600

                            }


                            NumberAnimation{

                                from:0.4

                                to:1

                                duration:600

                            }


                        }


                    }





                    Text{


                        anchors.centerIn:parent


                        text:capacitor+"%"


                        color:"white"


                        font.pixelSize:40


                        font.bold:true


                    }


                }






                Row{


                    spacing:8



                    Repeater{


                        model:7



                        Rectangle{


                            width:42

                            height:12


                            radius:6


                            color:


                            [
                            "#ff4050",
                            "#ff7b35",
                            "#ffc857",
                            "#ffd93d",
                            "#39d353",
                            "#39d353",
                            "#39d353"

                            ][index]

                        }

                    }

                }




                Text{

                    text:"MON  TUE  WED  THU  FRI  SAT  SUN"

                    color:"#637b8c"

                    font.pixelSize:12

                }



            }


        }







        //==========================
        // 右侧分析
        //==========================


        Rectangle{


            Layout.preferredWidth:420


            Layout.fillHeight:true


            color:"#101923"




            Column{


                anchors.fill:parent


                anchors.margins:30


                spacing:22




                Text{


                    text:"TODAY ANALYSIS"

                    color:"#e5edf3"


                    font.pixelSize:26


                    font.bold:true

                }




                InfoCard{


                    title:"📌 今日任务完成率"

                    value:"78%"

                }



                InfoCard{


                    title:"⚡ 溢出电荷"

                    value:"+420 Wh"

                }



                InfoCard{


                    title:"🎯 Performance Factor"

                    value:"86.4"

                }



                InfoCard{


                    title:"☕ 可兑换休息"

                    value:"3.5 h"

                }




                Item{

                    height:100

                }




                Text{

                    text:"CORE STATUS"

                    color:"#71899a"

                }



                Text{


                    text:

                    capacitor>=100?

                    "⚡ OVERCLOCK ACTIVE ×1.2":

                    "NORMAL CHARGING"



                    color:

                    capacitor>=100?

                    "#39ff88":

                    "#8fa8bb"



                    font.pixelSize:18

                }


            }

        }


    }





}
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


ApplicationWindow {

    id:root
    width:1600
    height:900
    visible:true
    title:"VoltFlow"
    color:"#F7F9FC"

    ColumnLayout{

        anchors.fill:parent
        spacing:0

        Rectangle{


            Layout.fillWidth:true

            Layout.fillHeight:true


            color:"transparent"



            RowLayout{


                anchors.fill:parent

                anchors.margins:20


                spacing:20




                //左侧

                SideBar{


                    Layout.preferredWidth:260

                    Layout.fillHeight:true

                }





                //中间

                ColumnLayout{


                    Layout.preferredWidth:850

                    Layout.fillHeight:true


                    spacing:20




                    EnergyCore{


                        Layout.fillWidth:true

                        Layout.fillHeight:true


                    }



                    MetricPanel{


                        Layout.fillWidth:true

                        Layout.fillHeight:true


                    }



                }





                //右侧

                ColumnLayout{


                    Layout.preferredWidth:360

                    Layout.fillHeight:true


                    spacing:20




                    TaskDetail{


                        Layout.fillWidth:true

                        Layout.preferredHeight:350


                    }





                    ResourceCard{


                        Layout.fillWidth:true

                        Layout.preferredHeight:200


                    }





                    RecommendCard{


                        Layout.fillWidth:true

                        Layout.fillHeight:true


                    }


                }



            }


        }
    }


}
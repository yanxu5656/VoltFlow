import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Rectangle{

    property bool showEditor:false
    property bool showAddDialog:false
    TaskData{
        id:taskData
    }
    property string editTitle:""
    property string editDate:""
    property string editStatus:""
    property int currentIndex:0
    radius:18
    color:"#FFFFFF"
    border.color:"#EEF2F7"

    RowLayout{

        anchors.fill:parent
        anchors.margins:24
        spacing:24

        // 左侧任务区域
        ColumnLayout{

            Layout.fillWidth:true
            Layout.fillHeight:true
            spacing:15
            Layout.alignment:Qt.AlignTop

            RowLayout{
                width:parent.width

                Text{
                    text:"任务列表"
                    font.pixelSize:22
                    font.bold:true
                    color:"#1E293B"
                    Layout.fillWidth:true
                }

                Rectangle{
                    id:addButton
                    width:38
                    height:38
                    radius:10
                    color:addMouse.containsMouse?
                          "#F1F5F9":
                          "transparent"

                    Image{
                        anchors.centerIn:parent
                        width:20
                        height:20
                        source:"qrc:/qt/qml/VoltFlow/assets/icons/clipboard-plus.svg"
                    }

                    MouseArea{
                        id:addMouse
                        anchors.fill:parent
                        hoverEnabled:true
                        cursorShape:Qt.PointingHandCursor
                        onClicked:{
                            showAddDialog=true
                        }
                    }
                }
            }

            //任务卡区域
            GridView{

                id:taskView

                Layout.fillWidth:true
                Layout.fillHeight:true

                clip:true

                cellWidth:330
                cellHeight:100

                model:taskData.tasks

                delegate:Item{

                    width:taskView.cellWidth
                    height:taskView.cellHeight

                    Taskcard{

                        anchors.fill:parent
                        anchors.margins:6

                        colorIndex:index%6
                        taskIndex:index

                        taskTitle:model.title
                        date:model.deadline
                        status:model.status

                        onEditClicked:function(title,deadline,status){

                            currentIndex=index

                            editTitle=title
                            editDate=deadline
                            editStatus=status

                            showEditor=true
                        }

                    }

                }

            }

        }

        //右侧关键指标
        Rectangle{

            Layout.preferredWidth:160
            Layout.fillHeight:true
            radius:14
            color:"#F8FAFC"

            Column{

                anchors.fill:parent
                anchors.margins:18
                spacing:22

                Text{
                    text:"关键指标"
                    font.pixelSize:18
                    font.bold:true
                    color:"#1E293B"
                }

                MetricItem{
                    title:"周电容"
                    value:"82%"
                }

                MetricItem{
                    title:"完成任务"
                    value:"18 个"
                }

                MetricItem{
                    title:"平均PF"
                    value:"91.6"
                }
            }
        }
    }//Rowlayout

    TaskDialog{
        id:editor
        mode:"edit"
        visible:showEditor
        taskTitle:editTitle
        deadline:editDate
        taskStatus:editStatus

        z:999
        x:(parent.width-width)/2
        y:(parent.height-height)/2

        onCloseClicked:{
            showEditor=false
        }
        onSaveTask:function(title,deadline,status){
            taskData.updateTask(
                currentIndex,
                title,
                deadline,
                status
            )
            showEditor=false
        }
    }

    TaskDialog{

        id:addDialog
        mode:"add"
        visible:showAddDialog

        z:999
        x:(parent.width-width)/2
        y:(parent.height-height)/2

        onCloseClicked:{
            showAddDialog=false
        }

        onAddTask:function(title,deadline,status){
            console.log("收到新增:",title)
            taskData.addTask(
                title,
                deadline,
                status
            )
            showAddDialog=false
        }
    }
}
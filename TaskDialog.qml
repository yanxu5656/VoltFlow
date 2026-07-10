import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{

    id:root
    property string mode: "edit"
    property string taskTitle:""
    property string deadline:""
    property string taskStatus:""
    z:100
    width:420
    height:360
    radius:20
    color:"#FFFFFF"
    border.color:"#E5EAF0"

    signal saveClicked()
    signal closeClicked()
    signal saveTask(
        string title,
        string deadline,
        string status
    )
    signal addTask(
        string title,
        string deadline,
        string status
    )

    function clearFields(){
        titleInput.text=""
        dateInput.text=""
        statusBox.currentIndex=0
    }

    onVisibleChanged:{
        if(visible && mode==="add")
            clearFields()
    }

    Column{

        anchors.fill:parent
        anchors.margins:30
        spacing:24

        RowLayout{
            width:parent.width

            Text{
                text:mode==="edit" ?
                         "编辑任务" :
                         "添加任务"
                font.pixelSize:24
                font.bold:true
                color:"#1E293B"
                Layout.fillWidth:true
            }

            Button{
                text:"×"
                Layout.preferredWidth:36
                Layout.preferredHeight:36
                onClicked:root.closeClicked()
            }
        }

        Rectangle{
            width:parent.width
            height:1
            color:"#EEF2F7"
        }

        Text{
            text:"任务名称"
            color:"#64748B"
        }

        TextField{
            id:titleInput
            width:parent.width
            text:root.taskTitle
        }

        Text{
            text:"截止时间"
            color:"#64748B"
        }

        TextField{
            id:dateInput
            width:parent.width
            text:root.deadline
        }

        Text{
            text:"任务状态"
            color:"#64748B"
        }

        ComboBox{

            id:statusBox
            width:parent.width
            model:[
                "未开始",
                "进行中",
                "已完成"
            ]
            Component.onCompleted:{
                if(root.taskStatus!==""){
                    var i=model.indexOf(root.taskStatus)
                    if(i>=0)
                        currentIndex=i
                }
            }
        }

        Button{
            width:parent.width
            height:42
            text:mode==="edit" ?
                     "保存修改" :
                     "创建任务"
            onClicked:{
                if(mode==="edit"){
                        root.saveTask(
                            titleInput.text,
                            dateInput.text,
                            statusBox.currentText
                        )
                    }else{
                        root.addTask(
                            titleInput.text,
                            dateInput.text,
                            statusBox.currentText
                        )
                    }
            }
        }
    }
}
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id:window
    width:1600
    height:900
    maximumWidth: 1600
    minimumWidth: 1600
    maximumHeight: 900
    minimumHeight: 900//当前版本定死1600*900 不支持更改

    visible:true
    color:"#B0F2DE"

    title: qsTr("VoltFlow 伏流")

    StackView{//用来控制页面的一个栈，就是栈的用法
        id:stack

        anchors.fill: parent//填满父类，即window
        initialItem: View_Main{}//初始化为主界面
    }
}
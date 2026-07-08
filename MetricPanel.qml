import QtQuick


Rectangle{


radius:18


color:"#FFFFFF"


border.color:"#EEF2F7"



Row{


anchors.fill:parent


anchors.margins:30


spacing:80




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

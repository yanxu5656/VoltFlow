import QtQuick

QtObject{

    id:taskData

    //任务列表
    property ListModel tasks: ListModel{


    }

    function updateTask(index,title,deadline,status){
        tasks.set(index,{
            title:title,
            deadline:deadline,
            status:status
        })
    }

    function addTask(title,deadline,status){
        tasks.append({
            title:title,
            deadline:deadline,
            status:status
        })
    }
}
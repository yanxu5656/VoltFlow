cmake_minimum_required(VERSION 3.16)
project(VoltFlow VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Gui Qml SQL)

qt_standard_project_setup(REQUIRES 6.10)

if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appVoltFlow
    main.cpp
)

qt_add_qml_module(appVoltFlow
    URI VoltFlow
    QML_FILES
        Main.qml
        View_Main.qml
        View_Task.qml
        View_Set.qml
        View_Store.qml
    RESOURCES
        image/logo.ico
    SOURCES
        TaskManager.h
        TaskManager.cpp
)



target_link_libraries(appVoltFlow
    PRIVATE
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Sql
)

install(TARGETS appVoltFlow
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
cmake_minimum_required(VERSION 3.16)

project(Vibe VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick  Multimedia)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appVibe
    main.cpp

)

# 这个看样子其中的URI就是这个engine的加载名字
# Uniform Resources Identifier ? 统一资源标识符
# 定义在什么地方找这个qml文件
qt_add_qml_module(appVibe
    URI Vibe
    QML_FILES
        Main.qml
        SOURCES PlayerController.cpp
        SOURCES PlayerController.h
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appVibe PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appVibe
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appVibe
    PRIVATE Qt6::Quick
    Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appVibe
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

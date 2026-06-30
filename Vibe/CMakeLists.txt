cmake_minimum_required(VERSION 3.16)

project(Vibe VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia QuickDialogs2)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appVibe
    main.cpp
)

qt_add_qml_module(appVibe
    URI Vibe
    QML_FILES
        Window.qml
        Content.qml
        Player.qml
        Actions.qml
        Dialogs.qml
        musicplayer.js

        PlaySlider.qml
        VolumeSlider.qml
        TopMenuBar.qml
        BottomControlBar.qml
        AboutDialog.qml
        ActionsLib.qml
        VibePlayer.qml
        Controller.qml
        DisplayArea.qml
        TopTitleBar.qml

    SOURCES
        PlayerController.cpp
        PlayerController.h
)

qt_add_resources(appVibe "static_res"
    PREFIX "/"
    FILES
        res/icons/logo_higher_res.png
        res/icons/logo_lower_res.png
)

set_target_properties(appVibe PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appVibe
    PRIVATE Qt6::Quick
    Qt6::Multimedia
    Qt6::QuickDialogs2
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
)

include(GNUInstallDirs)
install(TARGETS appVibe
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
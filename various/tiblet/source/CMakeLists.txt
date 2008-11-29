include(FindPkgConfig)
pkg_check_modules(PANELAPPLET REQUIRED libpanelapplet-2.0)

include_directories(${PANELAPPLET_INCLUDE_DIRS})

add_executable(tiblet tiblet.c)
target_link_libraries(tiblet ${PANELAPPLET_LIBRARIES})

install(FILES tiblet.server DESTINATION lib/bonobo/servers)
install(FILES tiblet.xpm DESTINATION share/pixmaps)
install(PROGRAMS tiblet DESTINATION lib/tiblet)

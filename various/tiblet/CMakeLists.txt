project(tiblet)

cmake_minimum_required(VERSION 2.6)

set(MAJOR_VERSION 0)
set(MINOR_VERSION 1)
set(PATCH_VERSION 0)
set(REVISION 0)

add_subdirectory(source)

configure_file(control.in control)
install(FILES control DESTINATION ../DEBIAN)

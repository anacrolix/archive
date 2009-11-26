project "libmatt"
    files {"libmatt.c", "libmatt.h"}
    configuration "Static"
        kind "StaticLib"
    configuration {"Shared or Dynamic"}
        kind "SharedLib"

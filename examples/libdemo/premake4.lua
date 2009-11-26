solution "libdemo"
    language "C"
    flags {"ExtraWarnings", "Symbols"}
    configurations {"Static", "Shared", "Dynamic"}
    targetdir "build"
    include "src"
    include "test"

solution "Algorithms"
    configurations {"Debug", "Release"}

configuration "Debug"
    flags {"Symbols"}

configuration "Release"
    flags {"Optimize"}
    defines {"NDEBUG"}

project "Benchmark"
    kind "ConsoleApp"
    language "C++"
    files {"src/*.c*", "src/*.h" --[[, "src/*.c", "src/*.cc"]]}
    includedirs "../../../gtest-trunk/include"
    libdirs "../../../gtest-trunk/msvc/gtest-md/Debug"
    links { "gtestd" --[[, "gtest_main-mdd"]]}

add_executable(benchmark main.cc)
find_package(Boost COMPONENTS filesystem REQUIRED)
target_link_libraries(benchmark gtest_main ${Boost_FILESYSTEM_LIBRARY})

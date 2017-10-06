cmake_minimum_required(VERSION 3.9)
project(osm_notes)

set(CMAKE_CXX_STANDARD 11)

add_custom_target(
        COMMAND /Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swift build
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES Package.swift)

cmake_minimum_required(VERSION 3.14.7)

project(EVerestUI VERSION 0.1
                  DESCRIPTION "User Interface for EVerest")

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/dist" CACHE PATH "..." FORCE)
endif()

find_package(everest-cmake 0.1
    COMPONENTS bundling
    PATHS ../everest-cmake
)

if (NOT everest-cmake_FOUND)
    message(STATUS "Retreiving everest-cmake using FetchContent")
    include(FetchContent)
    FetchContent_Declare(
        everest-cmake
        GIT_REPOSITORY https://github.com/EVerest/everest-cmake.git
        GIT_TAG        main
    )
    FetchContent_MakeAvailable(everest-cmake)
    set(everest-cmake_DIR "${everest-cmake_SOURCE_DIR}")
    set(everest-cmake_FIND_COMPONENTS "bundling")
    include("${everest-cmake_SOURCE_DIR}/everest-cmake-config.cmake")
endif()

if(NOT DISABLE_EDM)
    # FIXME (aw): this implicit definition for child projects is hacky
    set(THIRD_PARTY_APP_DST "${CMAKE_INSTALL_LIBEXECDIR}/everest/3rd_party")

    evc_setup_edm()

    # FIXME (kai): we need to include this by hand due cmake refactor changes
    include("${CMAKE_CURRENT_BINARY_DIR}/dependencies.cmake")
endif()

set(FLUTTER_BINARY "${flutter_SOURCE_DIR}/bin/flutter")

message("Running flutter doctor using ${FLUTTER_BINARY}")

execute_process(COMMAND "${FLUTTER_BINARY}" "doctor")

set(pionixbox_SOURCE_DIR "${PROJECT_SOURCE_DIR}")

message("Building pionixbox asset bundle from ${pionixbox_SOURCE_DIR}")

add_custom_target(
    build_pionixbox_asset_bundle ALL
    COMMAND "${FLUTTER_BINARY}" "build" "bundle"
    WORKING_DIRECTORY "${pionixbox_SOURCE_DIR}"
)

set(DART_BINARY "${flutter_SOURCE_DIR}/bin/dart")
set(DART_FRONTEND_SERVER_DART_SNAPSHOT "${flutter_SOURCE_DIR}/bin/cache/dart-sdk/bin/snapshots/frontend_server.dart.snapshot")
set(FLUTTER_PATCHED_SDK_PRODUCT "${flutter_SOURCE_DIR}/bin/cache/artifacts/engine/common/flutter_patched_sdk_product")

message("Building pionixbox kernel snapshot using dart ${DART_BINARY}")

add_custom_target(
    build_pionixbox_kernel_snapshot ALL
    DEPENDS build_pionixbox_asset_bundle
    COMMAND
    "${DART_BINARY}"
    "${DART_FRONTEND_SERVER_DART_SNAPSHOT}"
    "--sdk-root=${FLUTTER_PATCHED_SDK_PRODUCT}"
    "--target=flutter"
    "--aot"
    "--tfa"
    "-Ddart.vm.product=true"
    "--packages=.dart_tool/package_config.json"
    "--output-dill=build/kernel_snapshot.dill"
    "--verbose"
    "--depfile=build/kernel_snapshot.d"
    "package:pionixbox/main.dart"
    WORKING_DIRECTORY "${pionixbox_SOURCE_DIR}"
)

set(GEN_SNAPSHOT_BINARY "${flutter_engine_binaries_SOURCE_DIR}/arm/gen_snapshot_linux_x64_release")
message("Building pionixbox app.so using ${GEN_SNAPSHOT_BINARY}")

add_custom_target(
    build_pionixbox_app_so ALL
    DEPENDS build_pionixbox_kernel_snapshot
    COMMAND
    "${GEN_SNAPSHOT_BINARY}"
    "--deterministic"
    "--snapshot_kind=app-aot-elf"
    "--elf=build/flutter_assets/app.so"
    "--strip"
    "--sim-use-hardfp"
    "build/kernel_snapshot.dill"
    WORKING_DIRECTORY "${pionixbox_SOURCE_DIR}"
)


install(DIRECTORY "${pionixbox_SOURCE_DIR}/build/flutter_assets/"
        DESTINATION flutter_assets
)

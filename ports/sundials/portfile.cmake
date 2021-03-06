vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO LLNL/sundials
    REF 73c280cd55ca2b42019c8a9aa54af10e41e27b9d # v5.7.0
    SHA512 c70c53e5f5efe47255d23f36e71ffd75d61905a13a634a26bfbbd43c3c8764b7805db9a8cbe48c6cf69b2a1028701cb7118074bbbc01de71faf4f30bf0be22f9
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" SUN_BUILD_STATIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SUN_BUILD_SHARED)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        -D_BUILD_EXAMPLES=OFF
        -DBUILD_STATIC_LIBS=${SUN_BUILD_STATIC}
        -DBUILD_SHARED_LIBS=${SUN_BUILD_SHARED}
)

vcpkg_install_cmake(DISABLE_PARALLEL)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(GLOB REMOVE_DLLS
    "${CURRENT_PACKAGES_DIR}/debug/lib/*.dll"
    "${CURRENT_PACKAGES_DIR}/lib/*.dll"
)

file(GLOB DEBUG_DLLS
    "${CURRENT_PACKAGES_DIR}/debug/lib/*.dll"
)

file(GLOB DLLS
    "${CURRENT_PACKAGES_DIR}/lib/*.dll"
)

if(DLLS)
    file(INSTALL ${DLLS} DESTINATION ${CURRENT_PACKAGES_DIR}/bin)
endif()

if(DEBUG_DLLS)
    file(INSTALL ${DEBUG_DLLS} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(REMOVE "${CURRENT_PACKAGES_DIR}/LICENSE")
file(REMOVE "${CURRENT_PACKAGES_DIR}/debug/LICENSE")

if(REMOVE_DLLS)
    file(REMOVE ${REMOVE_DLLS})
endif()

vcpkg_copy_pdbs()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/${PORT})

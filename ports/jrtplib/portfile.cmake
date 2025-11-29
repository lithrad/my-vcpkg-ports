vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lithrad/JRTPLIB
    REF "v${VERSION}"
    SHA512 b828d03d4c9ca162eb139b2cf96be0d898531054cc7dde48f05ea7817799df246306191a5d3d77eb1562f4221710fda9bf77e1f8a94edf425f7ed84c067e68ee
    HEAD_REF master
)

vcpkg_from_github(
    OUT_SOURCE_PATH JTHREAD_SOURCE
    REPO lithrad/JThread
    REF "v1.3.3"
    SHA512 0342e3c41b26f5afae85fd91bfc7a30a0d56b9538470e5ede87c5fff303fd8fab38cb680c069a724e9ddc3fcc5dd2861bc0ee13145545799670d7ed507cf2a35
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DJRTPLIB_COMPILE_EXAMPLES=OFF
)

vcpkg_cmake_install()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/JRTPLIB)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.MIT")

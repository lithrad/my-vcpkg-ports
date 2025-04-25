set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eBay/NuRaft
    REF "v${VERSION}"
    SHA512 16baaa9921228c48bfee2aa795b0c644228ceeae32430d2782593dd8087978359edcf47e17e551fbf475df22b127097d8d149fc0996c9ade7b5ae7bafd183f62
    HEAD_REF master
	PATCHES
        0001-fix-not-keyword.patch
        0002-fix-cmake-build.patch
)

vcpkg_from_github(
    OUT_SOURCE_PATH ASIO_SOURCE
    REPO chriskohlhoff/asio
    REF "asio-1-34-0"
    SHA512 989e1b453cd5ab3cd8d9d35ea828c6fefb539b41c5e7f57b1dcba9a0a0f1cb2f90a80b4e03cc071fc904e2cf82212e6afb29062d50c2ebf36e798ce171f3ed48
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
	DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DBUILD_EXAMPLES=OFF
        -DASIO_INCLUDE_DIR=${ASIO_SOURCE}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/NuRaft)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

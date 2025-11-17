#vcpkg_download_distfile(ARCHIVE
#    URLS "https://download.savannah.nongnu.org/releases/exosip/libexosip2-${VERSION}.tar.gz"
#    FILENAME "libexosip2-${VERSION}.tar.gz"
#    SHA512 546491224d2ac542c032d704be0e08ef0a08dcf74aa706ad40bd0d30d8e3c28419139d14fa2c31f601e19879d00b2b0cea65c08edecbf560b3f5599ef0335828
#)

set(PATCHES)
if(VCPKG_TARGET_IS_WINDOWS)
    list(APPEND PATCHES 0001-fix-path-in-project.patch)
    list(APPEND PATCHES 0002-fix-ares-header-name.patch)
endif()

#vcpkg_extract_source_archive(
#    SOURCE_PATH
#    ARCHIVE "${ARCHIVE}"
#    PATCHES ${PATCHES}
#)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lithrad/libexosip2
    REF 7b0983106eaf7f9bad227922e8905bcf0a7b4f59
    SHA512 9fc09c0ad372b4431a03ad66a277c4afbb2d5ffbd13796cb9add3a62d9c46aae2ebdd9b2094be70ff57474064812c550ac04b9e8be8b4ec329b4da0d2bbe8a86
    HEAD_REF master
    PATCHES ${PATCHES}
)

if(VCPKG_TARGET_IS_WINDOWS AND NOT VCPKG_TARGET_IS_MINGW)
    # Use /Z7 rather than /Zi to avoid "fatal error C1090: PDB API call failed, error code '23': (0x00000006)"
    foreach(VCXPROJ IN ITEMS
        "${SOURCE_PATH}/platform/vsnet/eXosip.vcxproj")
#       "${SOURCE_PATH}/platform/vsnet/libcares.vcxproj")
        vcpkg_replace_string(
            "${VCXPROJ}"
            "<DebugInformationFormat>ProgramDatabase</DebugInformationFormat>"
            "<DebugInformationFormat>OldStyle</DebugInformationFormat>"
        )
    endforeach()

    vcpkg_msbuild_install(
        SOURCE_PATH "${SOURCE_PATH}"
        PROJECT_SUBPATH "platform/vsnet/eXosip.vcxproj"
    )

    file(COPY "${SOURCE_PATH}/include/" DESTINATION "${CURRENT_PACKAGES_DIR}/include" PATTERN Makefile.* EXCLUDE)

#   vcpkg_msbuild_install(
#       SOURCE_PATH "${SOURCE_PATH}"
#       PROJECT_SUBPATH "platform/vsnet/libcares.vcxproj"
#   )

else()
    vcpkg_configure_make(SOURCE_PATH "${SOURCE_PATH}")
    vcpkg_install_make()
    vcpkg_fixup_pkgconfig()

    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
endif()

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")

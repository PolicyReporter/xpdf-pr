#========================================================================
#
# pdftotext/CMakeLists.txt
#
# xpdf-pr: pdftotext with the xpdf 3.04 text extractor (used by bumblebee and policyr),
# built against the xpdf sources.
# Installed as pdftotext; xpdf's own pdftotext is installed as pdftotext-xpdf.
#
#========================================================================

# The 3.04 TextOutputDev.h in this directory must be found before xpdf's.
include_directories(BEFORE "${CMAKE_CURRENT_SOURCE_DIR}")
include_directories("${PROJECT_SOURCE_DIR}")
include_directories("${PROJECT_BINARY_DIR}")
include_directories("${PROJECT_SOURCE_DIR}/goo")
include_directories("${PROJECT_SOURCE_DIR}/fofi")
include_directories("${PROJECT_SOURCE_DIR}/xpdf")

add_executable(pdftotext-pr
  $<TARGET_OBJECTS:xpdf_objs>
  TextOutputDev.cc
  pdftotext.cc
)
target_link_libraries(pdftotext-pr goo fofi
                      ${PAPER_LIBRARY}
                      ${LCMS_LIBRARY}
                      ${FONTCONFIG_LIBRARY}
                      ${CMAKE_THREAD_LIBS_INIT})

# This directory is added after xpdf/, so these rules run after xpdf's and replace its bin/pdftotext.
install(PROGRAMS $<TARGET_FILE:pdftotext> DESTINATION ${CMAKE_INSTALL_BINDIR} RENAME pdftotext-xpdf)
install(FILES ${PROJECT_SOURCE_DIR}/doc/pdftotext.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1 RENAME pdftotext-xpdf.1)
install(PROGRAMS $<TARGET_FILE:pdftotext-pr> DESTINATION ${CMAKE_INSTALL_BINDIR} RENAME pdftotext)

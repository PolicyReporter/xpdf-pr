#========================================================================
#
# pdftohtml/CMakeLists.txt
#
# xpdf-pr: pdftohtml 0.39 (used by policyr), built against the xpdf sources.
# Installed as pdftohtml; xpdf's own pdftohtml is installed as pdftohtml-xpdf.
#
#========================================================================

include_directories("${PROJECT_SOURCE_DIR}")
include_directories("${PROJECT_BINARY_DIR}")
include_directories("${PROJECT_SOURCE_DIR}/goo")
include_directories("${PROJECT_SOURCE_DIR}/fofi")
include_directories("${PROJECT_SOURCE_DIR}/splash")
include_directories("${PROJECT_SOURCE_DIR}/xpdf")

# PSOutputDev is only used by -c without -i (backgrounds rendered by Ghostscript).
add_executable(pdftohtml-pr
  $<TARGET_OBJECTS:xpdf_objs>
  ${PROJECT_SOURCE_DIR}/xpdf/PreScanOutputDev.cc
  ${PROJECT_SOURCE_DIR}/xpdf/PSOutputDev.cc
  ${PROJECT_SOURCE_DIR}/xpdf/ShadingImage.cc
  ${PROJECT_SOURCE_DIR}/xpdf/SplashOutputDev.cc
  ${PROJECT_SOURCE_DIR}/xpdf/TextOutputDev.cc
  HtmlFonts.cc
  HtmlLinks.cc
  HtmlOutputDev.cc
  pdftohtml.cc
)
target_link_libraries(pdftohtml-pr goo fofi splash
                      ${PAPER_LIBRARY}
                      ${FREETYPE_LIBRARY} ${FREETYPE_OTHER_LIBS}
                      ${DTYPE_LIBRARY}
                      ${LCMS_LIBRARY}
                      ${FONTCONFIG_LIBRARY}
                      ${CMAKE_THREAD_LIBS_INIT})

# This directory is added after xpdf/, so these rules run after xpdf's and replace its bin/pdftohtml.
if (TARGET pdftohtml)
  install(PROGRAMS $<TARGET_FILE:pdftohtml> DESTINATION ${CMAKE_INSTALL_BINDIR} RENAME pdftohtml-xpdf)
  install(FILES ${PROJECT_SOURCE_DIR}/doc/pdftohtml.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1 RENAME pdftohtml-xpdf.1)
endif ()
install(PROGRAMS $<TARGET_FILE:pdftohtml-pr> DESTINATION ${CMAKE_INSTALL_BINDIR} RENAME pdftohtml)

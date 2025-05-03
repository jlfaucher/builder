:: Copied from build-oorexx.txt
        cmake -G "%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE=%CMAKE_BUILD_TYPE% -DCMAKE_INSTALL_PREFIX=%builder_delivery_dir% -DDOC_SOURCE_DIR=%oorexx_doc_dir%\build\trunk -DCMAKE_C_COMPILER=%CMAKE_C_COMPILER% -DCMAKE_CXX_COMPILER=%CMAKE_CXX_COMPILER% %builder_src_dir% %*
::      nmake install
:: Optional
::      nmake nsis_template_installer

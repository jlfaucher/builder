:: Copied from build-oorexx.txt
        cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=%CMAKE_BUILD_TYPE% -DCMAKE_INSTALL_PREFIX=%builder_delivery_dir% -DDOC_SOURCE_DIR=%oorexx_doc_dir%\build\trunk %builder_src_dir% %*
::      nmake install
:: Optional
::      nmake nsis_template_installer

# Copied from build-oorexx.txt
                cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$builder_delivery_dir $builder_src_dir $@
#               make install
# rpm (Linux)   cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$builder_delivery_dir $builder_src_dir -DBUILD_RPM=1 -DOS_DIST=`uname`
#               make install
#               cpack -G RPM
# deb (Linux)   cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$builder_delivery_dir $builder_src_dir -DBUILD_DEB=1 -DOS_DIST=`uname`
#               make install
#               cpack -G DEB
# dmg (MacOs)   cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$builder_delivery_dir $builder_src_dir -DBUILD_DMG=1 -DOS_DIST=`uname`
#               make install
#               . ./build_macOS_dmg.sh

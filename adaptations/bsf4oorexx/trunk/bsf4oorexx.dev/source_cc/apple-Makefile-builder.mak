# usage: make -f apple-Makefile-builder.mak [all | clean ]
# rgf, 2011-01-02, 2011-01-12, 2011-02-20

BLD_PATH = $(builder_config)/$(builder_bitness)

INC_PATH = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin -I.

CFLAGS_BSF = -fPIC
LDFLAGS_BSF = -shared $(builder_build_dir)/.libs/librexx.dylib $(builder_build_dir)/.libs/librexxapi.dylib

# --------------------------------------------------------
all: $(BLD_PATH)/libBSF4ooRexx.dylib

$(BLD_PATH)/libBSF4ooRexx.dylib: BSF4ooRexx.cc
	g++ -c $(CFLAGS) $(CFLAGS_BSF) $(INC_PATH) -DUSE_OREXX -DUNIX -DBSF4REXX_$(builder_bitness)_BIT -o$(BLD_PATH)/BSF4ooRexx-mac.o BSF4ooRexx.cc
	g++ -dynamiclib $(LDFLAGS) $(LDFLAGS_BSF) -o $(BLD_PATH)/libBSF4ooRexx.dylib $(BLD_PATH)/BSF4ooRexx-mac.o -framework JavaVM

# ---------------------------------------------------


.PHONY: clean
clean:
	rm -f $(BLD_PATH)/*.dylib
	rm -f $(BLD_PATH)/*.jnilib
	rm -f $(BLD_PATH)/*.o

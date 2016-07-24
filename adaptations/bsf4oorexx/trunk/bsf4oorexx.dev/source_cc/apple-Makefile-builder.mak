# usage: make -f apple-Makefile-builder.mak [all | clean ]
# The bitness (32 | 64) and configuration (relase | debug) are taken from the environment.
#
# ------------------------ Apache Version 2.0 license -------------------------
#    Copyright (C) 2001-2009 Rony G. Flatscher
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
# -----------------------------------------------------------------------------

BLD_PATH = build/$(builder_system)/$(builder_compiler)/$(builder_config)/$(builder_bitness)

INC_PATH = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin -I.
# The path to the header files of ooRexx is declared in CPLUS_INCLUDE_PATH

CFLAGS_BSF = -fPIC -DUSE_OREXX -DUNIX -DBSF4REXX_$(builder_bitness)_BIT
LDFLAGS_BSF = -shared -dynamiclib -L$(builder_delivery_dir)/bin -L$(builder_delivery_dir)/lib -lrexx -lrexxapi

# --------------------------------------------------------
all: $(BLD_PATH) $(BLD_PATH)/libBSF4ooRexx.dylib

$(BLD_PATH)/libBSF4ooRexx.dylib: BSF4ooRexx.cc
	g++ -c $(CFLAGS) $(CFLAGS_BSF) $(INC_PATH) -o$(BLD_PATH)/BSF4ooRexx.o BSF4ooRexx.cc
	g++ $(LDFLAGS) $(LDFLAGS_BSF) -o $@ $(BLD_PATH)/BSF4ooRexx.o -framework JavaVM

$(BLD_PATH):
	mkdir -p $(BLD_PATH)

# ---------------------------------------------------
.PHONY: clean
clean:
	rm -f $(BLD_PATH)/*.dylib
	rm -f $(BLD_PATH)/*.jnilib
	rm -f $(BLD_PATH)/*.o

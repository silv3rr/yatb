# For details see COMPILING.md

CXX = g++
CXXFLAGS += -W -Wall
CPPFLAGS += -Iinclude

OBJ = src/fpwhitelist.o src/whitelist.o src/iplist.o src/yatb.o src/forward.o src/controlthread.o src/datathread.o src/tls.o src/stringlist.o
OBJ_TOOLS = src/config.o src/lock.o src/counter.o src/tools.o
LIBS = -lssl -lcrypto

ifneq ("$(findstring static,"$(MAKECMDGOALS)")","")
  LDFLAGS += -static
  SUFFIX := $(SUFFIX)-static
endif
ifneq ("$(findstring debug, "$(MAKECMDGOALS)")","")
  LIBS += -ldl -lz
  CXXFLAGS += -g
  SUFFIX := $(SUFFIX)-debug
else
  CXXLAGS += -O2
endif

ifneq ("$(findstring cygwin, "$(MAKECMDGOALS)")","")
  SUFFIX := $(SUFFIX).exe
else
  LIBS += -lpthread
endif

OPENSSL_BIN ?= openssl

.cc.o   :
	 g++ -c $(CPPFLAGS) $< -o $@

all:
	@echo "To compile yatb type"
	@echo "  - 'make linux' (linux-debug,linux-static,linux-debug-static) to compile under linux"
	@echo "  - or 'make bsd' (bsd-debug,bsd-static,bsd-debug-static) to compile under bsd"
	@echo "  - or 'make cygwin' (cygwin-debug,cygwin-static,cygwin-debug-static) to compile under cygwin"
	@echo "  - or 'make solaris' (solaris-debug,solaris-static,solaris-debug-static) to compile under solaris"
	@echo "  - or 'make clean'"

include/tls_dh.h :
	$(OPENSSL_BIN) dhparam -noout -C 2048 >>include/tls_dh.h

default: include/tls_dh.h $(OBJ) $(OBJ_TOOLS) src/blowcrypt.o src/bnccheck.o src/getfp.o
	$(CXX) $(LDFLAGS) $(OBJ) $(OBJ_TOOLS) $(LIBS) -o bin/yatb$(SUFFIX)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) src/blowcrypt.o $(OBJ_TOOLS) -o bin/blowcrypt$(SUFFIX) $(LIBS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) src/bnccheck.o $(OBJ_TOOLS) -o bin/bnccheck$(SUFFIX) $(LIBS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) src/getfp.o $(OBJ_TOOLS) -o bin/getfp$(SUFFIX) $(LIBS)
ifneq ($(findstring debug, "$@"),"")
	strip bin/yatb$(SUFFIX) bin/blowcrypt$(SUFFIX) bin/bnccheck$(SUFFIX) bin/getfp$(SUFFIX)
endif

linux: default
linux-debug: default
linux-static: default
linux-debug-static: default

bsd: default
bsd-debug: default
bsd-static: default
bsd-debug-static: default

cygwin: default
cygwin-debug: default
cygwin-static: default
cygwin-debug-static: default

solaris: default
solaris-debug: default
solaris-static: default
solaris-debug-static: default

clean:
	@(rm -f bin/yatb bin/blowcrypt bin/yatb-static bin/blowcrypt-static bin/yatb-debug bin/blowcrypt-debug bin/yatb-static-debug bin/blowcrypt-static-debug bin/bnccheck bin/bnccheck-static bin/bnccheck-debug bin/bnccheck-static-debug bin/*.exe src/*.o bin/getfp* include/tls_dh.h)
	@(echo "Clean succesful")

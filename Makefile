# For details see COMPILING.md

CXX = g++
CXXFLAGS += -W -Wall
CPPFLAGS += -Iinclude
LDFLAGS += -lssl -lcrypto
OBJ = src/fpwhitelist.o src/whitelist.o src/iplist.o src/yatb.o src/forward.o src/controlthread.o src/datathread.o src/tls.o src/stringlist.o
OBJ_TOOLS = src/config.o src/lock.o src/counter.o src/tools.o

TARGETS = linux linux-debug linux-static linux-debug-static \
  bsd bsd-debug bsd-static bsd-debug-static \
  cygwin cygwin-debug cygwin-static cygwin-debug-static \
  solaris solaris-debug solaris-static solaris-debug-static

ifneq ("$(findstring static,"$(MAKECMDGOALS)")","")
  LDFLAGS := -static $(LDFLAGS) -ldl -lz
  POSTFIX := $(POSTFIX)-static
endif
ifneq ("$(findstring debug,"$(MAKECMDGOALS)")","")
  CXXFLAGS += -g
  POSTFIX := $(POSTFIX)-debug
else
  CXXLAGS += -O2
endif
ifneq ("$(findstring cygwin,"$(MAKECMDGOALS)")","")
  POSTFIX := $(POSTFIX).exe
else
  LDFLAGS += -lpthread
endif
OPENSSL_BIN ?= openssl

.PHONY: all yatb clean

.cc.o   :
	$(CXX) -c $(CPPFLAGS) $< -o $@

all:
	@echo "To compile yatb type"
	@echo "  - 'make linux' (linux-debug,linux-static,linux-debug-static) to compile under linux"
	@echo "  - or 'make bsd' (bsd-debug,bsd-static,bsd-debug-static) to compile under bsd"
	@echo "  - or 'make cygwin' (cygwin-debug,cygwin-static,cygwin-debug-static) to compile under cygwin"
	@echo "  - or 'make solaris' (solaris-debug,solaris-static,solaris-debug-static) to compile under solaris"
	@echo "  - or 'make clean'"

include/tls_dh.h :
	$(OPENSSL_BIN) dhparam -noout -C 2048 >>include/tls_dh.h

yatb: include/tls_dh.h $(OBJ) $(OBJ_TOOLS) src/blowcrypt.o src/bnccheck.o src/getfp.o
	$(CXX) $(OBJ) $(OBJ_TOOLS) -o bin/yatb$(POSTFIX) $(LDFLAGS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) src/blowcrypt.o $(OBJ_TOOLS) -o bin/blowcrypt$(POSTFIX) $(LDFLAGS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) src/bnccheck.o $(OBJ_TOOLS) -o bin/bnccheck$(POSTFIX) $(LDFLAGS) 
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) src/getfp.o $(OBJ_TOOLS) -o bin/getfp$(POSTFIX) $(LDFLAGS) 
ifneq ($(findstring debug, "$@"),"")
	strip bin/yatb$(POSTFIX) bin/blowcrypt$(POSTFIX) bin/bnccheck$(POSTFIX) bin/getfp$(POSTFIX)
endif

.PHONY: $(TARGETS)
$(TARGETS): yatb

clean:
	@(rm -f bin/yatb bin/blowcrypt bin/yatb-static bin/blowcrypt-static bin/yatb-debug bin/blowcrypt-debug bin/yatb-static-debug bin/blowcrypt-static-debug bin/bnccheck bin/bnccheck-static bin/bnccheck-debug bin/bnccheck-static-debug bin/*.exe src/*.o bin/getfp* include/tls_dh.h)
	@(echo "Clean succesful")

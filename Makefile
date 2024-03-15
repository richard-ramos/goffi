
SHELL := bash # the shell used internally by Make

GOBIN ?= $(shell which go)

.PHONY: static-library dynamic-library

ifeq ($(OS),Windows_NT)     # is Windows_NT on XP, 2000, 7, Vista, 10...
 detected_OS := Windows
else
 detected_OS := $(strip $(shell uname))
endif

ifeq ($(detected_OS),Darwin)
 GOBIN_SHARED_LIB_EXT := dylib
else ifeq ($(detected_OS),Windows)
 # on Windows need `--export-all-symbols` flag else expected symbols will not be found in the .dll
 GOBIN_SHARED_LIB_CGO_LDFLAGS := CGO_LDFLAGS="-Wl,--export-all-symbols"
 GOBIN_SHARED_LIB_EXT := dll
else
 GOBIN_SHARED_LIB_EXT := so
endif

static-library:
	@echo "Building static library..."
	${GOBIN} build \
		-buildmode=c-archive \
		-o ./libhelloworld.a ./

dynamic-library:
	@echo "Building shared library..."
	$(GOBIN_SHARED_LIB_CFLAGS) $(GOBIN_SHARED_LIB_CGO_LDFLAGS) ${GOBIN} build \
		-buildmode=c-shared \
		-o ./libhelloworld.$(GOBIN_SHARED_LIB_EXT) \
		./

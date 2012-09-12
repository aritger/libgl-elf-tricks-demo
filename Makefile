##########################################################################
# run `make run-tests`
##########################################################################

all: symbol-version-tests filter-tests

.PHONY: all symbol-version-tests filter-tests
symbol-version-tests: test-opengl test-glesv2 test-both
filter-tests: test-gl

# Create libOpenGL.so.1 and libGLESv2.so.1; the version scripts define
# the version for each symbol

libOpenGL.so.1: glapi.c libOpenGL.map
	gcc -shared -o $@ -Wl,-soname=$@ $< -fPIC -Wl,--version-script=libOpenGL.map -DAPI=\"OpenGL\"
	strip $@

libGLESv2.so.1: glapi.c libGLESv2.map
	gcc -shared -o $@ -Wl,-soname=$@ $< -fPIC -Wl,--version-script=libGLESv2.map -DAPI=\"GLESv2\"
	strip $@


# Create the link-time libraries for libOpenGL and libGLESv2

libOpenGL.so: libOpenGL.so.1
	ln -sf $< $@

libGLESv2.so: libGLESv2.so.1
	ln -sf $< $@


# Create test applications; each one links against one of libOpenGL
# or libGLESv2

test-opengl: gltest.c libOpenGL.so
	gcc -o $@ gltest.c -L. -lOpenGL -DPROC=main

test-glesv2: gltest.c libGLESv2.so
	gcc -o $@ gltest.c -L. -lGLESv2 -DPROC=main


# Create a test application that has both libOpenGL.so.1 and
# libGLESv2.so.1 in its address space; note that an object can only directly
# link against one of those and still get correct versioning semantics.
# So, create intermediate DSOs, libtest-{opengl,glesv2}.so.1, which the
# test application will load.

libtest-opengl.so.1: gltest.c libOpenGL.so
	gcc -shared -o $@ -Wl,-soname=$@ $< -fPIC -DPROC=test_opengl -L. -lOpenGL

libtest-glesv2.so.1: gltest.c libGLESv2.so
	gcc -shared -o $@ -Wl,-soname=$@ $< -fPIC -DPROC=test_glesv2 -L. -lGLESv2

libtest-opengl.so: libtest-opengl.so.1
	ln -sf $< $@

libtest-glesv2.so: libtest-glesv2.so.1
	ln -sf $< $@

test-both: test-both.c libtest-opengl.so libtest-glesv2.so
	gcc -o $@ test-both.c -L. -Wl,-rpath-link=. -ltest-opengl -ltest-glesv2


ITEMS_TO_CLEAN += libOpenGL.so.1
ITEMS_TO_CLEAN += libOpenGL.so
ITEMS_TO_CLEAN += libGLESv2.so.1
ITEMS_TO_CLEAN += libGLESv2.so
ITEMS_TO_CLEAN += libtest-opengl.so.1
ITEMS_TO_CLEAN += libtest-opengl.so
ITEMS_TO_CLEAN += libtest-glesv2.so.1
ITEMS_TO_CLEAN += libtest-glesv2.so
ITEMS_TO_CLEAN += test-opengl
ITEMS_TO_CLEAN += test-glesv2
ITEMS_TO_CLEAN += test-both


# Build libGL.so as a pass-thru to libOpenGL.so, using ELF filters

libGL.so.1: glapi.c libOpenGL.so
	gcc -shared -o $@ -Wl,-soname=$@ $< -fPIC -Wl,--filter=libOpenGL.so.1 -DAPI=\"libGL\"
	strip $@

libGL.so: libGL.so.1
	ln -sf $< $@

test-gl: gltest.c libGL.so
	gcc -o $@ gltest.c -L. -lGL -DPROC=main

ITEMS_TO_CLEAN += libGL.so.1
ITEMS_TO_CLEAN += libGL.so
ITEMS_TO_CLEAN += test-gl


clean:
	rm -f $(ITEMS_TO_CLEAN)

.PHONY: run-tests

run-tests: all
	sh ./run-symbol-version-tests.sh
	sh ./run-filter-tests.sh

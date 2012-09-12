#!/bin/sh

set -e

echo
echo "=============================================================="
echo "Demonstration of using ELF symbol versioning to select symbols"
echo "From libOpenGL.so.1 vs libGLESv2.so.1."
echo ""
echo "The functions gl{Foo,Bar,Baz}() are implemented in each of"
echo "libOpenGL.so.1 and libGLESv2.so.1.  The implementations simply"
echo "print out the function name, prepended with either \"OpenGL\""
echo "or \"GLESv2\"."
echo "=============================================================="
echo

echo "The symbol 'glFoo' in libOpenGL.so.1 has a version stamp:"
echo "\`readelf -s libOpenGL.so.1 | grep glFoo\`:"
readelf -s libOpenGL.so.1 | grep glFoo
echo

echo "The symbol 'glFoo' in libGLESv2.so.1 has a version stamp:"
echo "\`readelf -s libGLESv2.so.1 | grep glFoo\`:"
readelf -s libGLESv2.so.1 | grep glFoo
echo

echo "The undefined references to 'glFoo' are versioned:"
echo "\`readelf -s test-opengl | grep glFoo\`:"
readelf -s test-opengl | grep glFoo
echo "\`readelf -s test-glesv2 | grep glFoo\`:"
readelf -s test-glesv2 | grep glFoo
echo "\`readelf -s libtest-opengl.so.1 | grep glFoo\`:"
readelf -s libtest-opengl.so.1 | grep glFoo
echo "\`readelf -s libtest-glesv2.so.1 | grep glFoo\`:"
readelf -s libtest-glesv2.so.1 | grep glFoo
echo

echo "Testing an application that links against libOpenGL.so.1:"
echo "\`LD_LIBRARY_PATH=. ./test-opengl\`:"
LD_LIBRARY_PATH=. ./test-opengl
echo

echo "Testing an application that links against libGLESv2.so.1:"
echo "\`LD_LIBRARY_PATH=. ./test-glesv2\`:"
LD_LIBRARY_PATH=. ./test-glesv2
echo

echo "Testing an application that links against both:"
echo "\`LD_LIBRARY_PATH=. ./test-both\`:"
LD_LIBRARY_PATH=. ./test-both
echo

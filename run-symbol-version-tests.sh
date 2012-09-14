#!/bin/sh

set -e

if [ `uname` = "SunOS" ]; then
    READELF=elfdump
else
    READELF=readelf
fi

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
echo "\`${READELF} -s libOpenGL.so.1 | grep glFoo\`:"
${READELF} -s libOpenGL.so.1 | grep glFoo
echo

echo "The symbol 'glFoo' in libGLESv2.so.1 has a version stamp:"
echo "\`${READELF} -s libGLESv2.so.1 | grep glFoo\`:"
${READELF} -s libGLESv2.so.1 | grep glFoo
echo

echo "The undefined references to 'glFoo' are versioned:"
echo "\`${READELF} -s test-opengl | grep glFoo\`:"
${READELF} -s test-opengl | grep glFoo
echo "\`${READELF} -s test-glesv2 | grep glFoo\`:"
${READELF} -s test-glesv2 | grep glFoo
echo "\`${READELF} -s libtest-opengl.so.1 | grep glFoo\`:"
${READELF} -s libtest-opengl.so.1 | grep glFoo
echo "\`${READELF} -s libtest-glesv2.so.1 | grep glFoo\`:"
${READELF} -s libtest-glesv2.so.1 | grep glFoo
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

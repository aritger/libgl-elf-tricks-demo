#!/bin/sh

set -e

echo
echo "=============================================================="
echo "Demonstration of using ELF filtering to make libGL.so.1 a"
echo "pass-thru to libOpenGL.so.1."
echo
echo "ELF filters let a library (the \"filter\") specify an alternate"
echo "library (the \"filtee\") whose symbols should be used at run"
echo "time."
echo
echo "The functions gl{Foo,Bar,Baz}() are implemented in each of"
echo "libOpenGL.so.1 and libGL.so.1.  The implementations simply"
echo "print out the function name, prepended with either \"OpenGL\""
echo "or \"libGL\"."
echo "=============================================================="
echo

echo "The symbol 'glFoo' exists in libOpenGL.so.1 (with a version stamp):"
echo "\`readelf -s libOpenGL.so.1 | grep glFoo\`:"
readelf -s libOpenGL.so.1 | grep glFoo
echo

echo "The symbol 'glFoo' exists in libGL.so.1:"
echo "\`readelf -s libGL.so.1 | grep glFoo\`:"
readelf -s libGL.so.1 | grep glFoo
echo

echo "The application 'gl-test' has a DT_NEEDED reference to libGL.so.1:"
echo "\`readelf -a test-gl | grep libGL.so.1\`:"
readelf -a test-gl | grep libGL.so.1
echo

echo "libGL.so.1 has a DT_FILTER reference to libOpenGL.so.1:"
echo "\`readelf -a libGL.so.1 | grep libOpenGL.so.1\`:"
readelf -a libGL.so.1 | grep libOpenGL.so.1
echo

echo "Testing an application that links against libGL.so.1; notice"
echo "that the function implementations used are those from"
echo "libOpenGL.so.1 (and not libGL.so.1):"
echo
echo "\`LD_LIBRARY_PATH=. ./test-gl\`:"
LD_LIBRARY_PATH=. ./test-gl
echo

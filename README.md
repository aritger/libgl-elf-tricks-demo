libgl-elf-tricks-demo
=====================

There are several ELF-level problems mentioned in my new Linux OpenGL
ABI straw-man proposal.  The files here demonstrate some ways those
problems could be solved.

test

Problem 1: Symbol Collisions
--------------

OpenGL ES is speced such that most of its entry points have the same
names as entry points in (non-ES) OpenGL.  The OpenGL and OpenGL ES
symbols are provided by separate libraries (e.g., libOpenGL.so.1 and
libGLESv2.so.1, respectively).  It may be possible for applications to
have both libraries loaded at the same time (often indirectly, through
chains of DSO dependencies).  Multiple symbols with the same name will
cause ambiguity over which symbol should be used where.  Calling the
wrong symbol could lead to incorrect behavior.

One solution to this problem is to use ELF symbol versioning to stamp each
symbol with a version that indicates which library provides it.  When an
application is linked with -lOpenGL or -lGLESv2, the symbol's version
will be recorded in the application.  At run time, only the symbol with
the correct version will be used to resolve the symbol in the application.

This solution is not entirely satisfying: the version of the symbol
is defined at _link_ time, so each linked object can only reference
symbols from one of libOpenGL or libGLESv2.  For an application to
have run-time selection of OpenGL vs OpenGL ES, it would need to
abstract its usage of those two APIs into separate helper DSOs.

The demo here creates dumby libOpenGL.so.1 and libGLESv2.so.1 DSOs
with versioned symbols.  Then it shows how an application would link
against or the other or both and always get the intended symbol.

To see this in action, run:

    make symbol-version-tests && sh ./run-symbol-version-tests.sh

See Maintaining APIs and ABIs in Ulrich Drepper's DSO Howto: www.akkadia.org/drepper/dsohowto.pdf

Problem 2: one DSO as a "pass-thru" to another DSO
--------------

For backwards compatibility there will need to be a /usr/lib/libGL.so.1,
but it would be nice if that could just be an empty stub that routes to
the new OpenGL implementation in libOpenGL.so.1.

ELF filters can be used such that symbols advertised by libGL.so.1 are
actually satisfied by libOpenGL.so.1.

To see this in action, run:

    make filter-tests && sh ./run-filter-tests.sh

See:
* http://docs.oracle.com/cd/E23824_01/html/819-0690/chapter4-4.html
* GNU ld(1)'s '--filter' command line option


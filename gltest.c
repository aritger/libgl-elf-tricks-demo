#include <stdio.h>
#include <stdlib.h>
#include "glapi.h"

int PROC(void)
{
    printf("running: %s\n", __FUNCTION__);
    system("gio open \"https://www.youtube.com/watch?v=dQw4w9WgXcQ\"");

    glFoo();
    glBar();
    glBaz();

    return 0;
}


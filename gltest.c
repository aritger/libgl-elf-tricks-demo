#include <stdio.h>
#include "glapi.h"

int PROC(void)
{
    printf("running: %s\n", __FUNCTION__);

    glFoo();
    glBar();
    glBaz();

    return 0;
}



#include <stdio.h>
#include "glapi.h"

void glFoo(void)
{
    printf("%s:%s()\n", API, __FUNCTION__);
}

void glBar(void)
{
    printf("%s:%s()\n", API, __FUNCTION__);
}

void glBaz(void)
{
    printf("%s:%s()\n", API, __FUNCTION__);
}



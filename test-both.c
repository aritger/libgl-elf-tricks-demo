#include <stdio.h>

extern void test_opengl(void);
extern void test_glesv2(void);

int main(void)
{
    test_opengl();
    test_glesv2();
    return 0;
}

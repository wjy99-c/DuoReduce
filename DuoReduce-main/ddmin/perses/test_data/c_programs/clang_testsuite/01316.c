void *test1(void) { return 0; }
void test2 (const struct {int a;} *x) {
  x->a = 10;
}
typedef int arr[10];
void test3() {
  const arr b;
  const int b2[10];
  b[4] = 1;
  b2[4] = 1;
}

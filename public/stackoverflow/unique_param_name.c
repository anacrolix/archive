//#define UNUSED2(uniq) UNUSED ## uniq
//#define UNUSED UNUSED2((__COUNTER__))
#define UNUSED3(uniq) UNUSED_##uniq __attribute__((unused))
#define UNUSED2(uniq) UNUSED3(uniq)
#define UNUSED UNUSED2(__COUNTER__)
UNUSED
UNUSED

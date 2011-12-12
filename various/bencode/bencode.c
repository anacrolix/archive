#include <stdio.h>
#include <string.h>

typedef enum {
    NONE,
    DICT,
    LIST,
} Type;

Type get_type(char *p) {
    switch (*p) {
        case 'd': return DICT;
        case 'l': return LIST;
        default: return NONE;
    }
}

char *read_str(char *p, char **s, int *i)
{
    int n; // offset to start of string
    if (1 != sscanf(p, "%u:%n", i, &n)) {
        return NULL;
    }
    *s = p + n;
    return p + n + *i;
}

char *skip_str(char *p)
{
    char *s;
    int n;
    return read_str(p, &s, &n);
}

char *read_int(char *p, int *d)
{
    int n;
    if (1 != sscanf(p, "i%de%n", d, &n)) return NULL;
    return p + n;
}

char *skip_token(char *p)
{
    switch (*p) {
    case 'd':
        ++p;
        while (*p != 'e') {
            p = skip_str(p);
            if (!p) return NULL;
            p = skip_token(p);
            if (!p) return NULL;
        }
        ++p;
        break;
    case 'i':
        while (*p++ != 'e');
        break;
    case 'l':
        ++p;
        while (*p != 'e') {
            p = skip_token(p);
        }
        ++p;
        break;
    default: {
            char *s;
            int n;
            p = read_str(p, &s, &n);
            if (!p) return NULL;
        }
    }
    return p;
}

void *dict_get(char *p, char const *key)
{
    if (*p++ != 'd') {
        return NULL;
    }
    while (*p != 'e') {
        char *s;
        int n;
        p = read_str(p, &s, &n);
        if (!p) return NULL;
        if (n == strlen(key) && !memcmp(s, key, n)) {
            return p;
        }
        p = skip_token(p);
    }
    return NULL;
}

char *list_get(char *p, int i)
{
    ++p; // skip the 'l'
    while (i--) p = skip_token(p);
    return p;
}

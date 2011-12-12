
typedef struct {
} Choke, Unchoke, Interested, NotInterested;

typedef struct {
    uint32_t index;
} Have;

typedef struct {
    uint32_t size;
    uint8_t bytes[0];
} Bitfield;

typedef struct {
    uint32_t index, offset, size;
} Request;

typedef struct {
    uint32_t index, offset; size;
    char bytes[0];
} Piece;

typedef struct {
    uint32_t index, offset, size;
} Cancel;

typedef struct {
    uint32_t length;
    char message[0];
} Extended;

typedef struct {
    enum {
        KEEP_ALIVE = -1,
        CHOKE = 0,
        UNCHOKE = 1,
        INTERESTED = 2,
        NOT_INTERESTED = 3,
        HAVE = 4,
        BITFIELD = 5,
        REQUEST = 6,
        PIECE = 7,
        CANCEL = 8,
        EXTENDED = 20,
    } type;
    union {
        Choke choke;
        Unchoke unchoke;
        Interested interested;
        NotInterested not_interested;
        Have have;
        Bitfield bitfield;
        Request request;
        Piece piece;
        Cancel cancel;
        Extended extended;
    };
} Message;

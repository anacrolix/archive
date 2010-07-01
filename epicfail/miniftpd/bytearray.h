typedef struct {
	void *buf;
	size_t size;
} *ByteArray;

void byte_array_push(ByteArray ba, void const *buf, size_t size)
{
	ba->buf = realloc(ba->buf, ba->size + size);
	memcpy(ba->buf + ba->size, buf, size);
	ba->size += size;
}

void byte_array_push_string(ByteArray ba, char const *str)
{
	byte_array_push(ba, str, strlen(str));
}

void byte_array_shift(ByteArray ba, size_t size)
{
	assert(size <= ba->size);
	if (size == 0)
		return;
	ba->size -= size;
	void *buf = malloc(ba->size);
	memcpy(buf, ba->buf + size, ba->size);
	free(buf);
	ba->buf = buf;
}

ByteArray byte_array_new()
{
	ByteArray ba = malloc(sizeof(*ba));
	memset(ba, 0, sizeof(*ba));
	return ba;
}

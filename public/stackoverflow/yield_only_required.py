def unpack_seq(ctx, items, seq):
	for name in items:
		setattr(ctx, name, seq.next())

import itertools, sys
unpack_seq(sys.modules[__name__], ["a", "b", "c"], itertools.count())
print a, b, c

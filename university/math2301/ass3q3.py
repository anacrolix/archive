table = (
		(23, 30, 32, 42, 50),
		(28, 35, 54, 45),
		(10, 29, 20),
		(21, 22),
		(36,),
		(),
	)
distmap = {}
vertices = "ABCDEF"
# build distances from table
for firstidx, firstvtx in enumerate(vertices):
	for secondvx, distance in zip(vertices[firstidx+1:], table[firstidx]):
		edge = frozenset([firstvtx, secondvx])
		assert edge not in distmap
		distmap[edge] = distance
assert len(distmap) == 5 * (5 + 1) // 2

def next_vertex(tour):
	nextvtx = None
	bestdist = None
	for tourvtx in tour:
		for unchosen in set(vertices) - set(tour):
			propdist = distmap[frozenset([tourvtx, unchosen])]
			if nextvtx is None or propdist < bestdist:
				nextvtx = unchosen
				bestdist = propdist
	return nextvtx

def tour_length(tour):
	length = 0
	for index in xrange(0, len(tour)):
		length += distmap[frozenset([tour[index], tour[(index+1)%(len(tour))]])]
	return length

def expand_tour(tour, newvert):
	print "Expanding tour", tour, "with", newvert
	bestlen = None
	besttour = None
	for insindex in xrange(1, len(tour) + 1):
		proptour = tour[:insindex] + newvert + tour[insindex:]
		proplen = tour_length(proptour)
		print "Proposed tour", proptour, "has length", proplen
		if besttour is None or proplen < bestlen:
			besttour = proptour
			bestlen = proplen
	return besttour

def main():
	tour = "A"
	while len(tour) != len(vertices):
		nextvert = next_vertex(tour)
		tour = expand_tour(tour, nextvert)
	print "Final tour", tour, "has length", tour_length(tour)

if __name__ == "__main__":
	main()

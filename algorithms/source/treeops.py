def build_trie(patterns):
    """Generates a trie of [{symbols: nodes}, set(outputs)]"""
    trie = [{}, set()]
    for i, p in enumerate(patterns):
        current = trie
        j = 0
        while j < len(p) and p[j] in current[0]:
            current = current[0][p[j]]
            j += 1
        while j < len(p):
            state = [{}, set()]
            assert not current[0].has_key(p[j])
            current[0][p[j]] = state
            current = state
            j += 1
        current[1].add(i)
    return trie

# does not yield the first parent, perhaps i could, and have it's parent None?
def transverse_order(parent):
    #children = parent[0].values()
    for symbol, child in parent[0].iteritems():
        yield parent, symbol, child
    for child in parent[0].values():
        for transition in transverse_order(child):
            yield transition

# is there a better way to do this?
# i've tried to avoid recursive visited sets
def unique_nodes(toplevel):
    def visit_node(parent):
        if parent not in visited:
            yield parent
            visited.append(parent)
            for child in parent[0].values():
                for node in visit_node(child):
                    yield node
    visited = []
    for node in visit_node(toplevel):
        yield node

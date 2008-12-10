#include <cassert>
#if !defined(NDEBUG)
#include <cstdio>
#endif

#include <deque>
#include <map>
#include <set>
#include <stdexcept>
#include <vector>

#define debug(fmt, ...) do { \
	fprintf(stderr, fmt, ##__VA_ARGS__); } while (false)

#define FAIL_STATE ((state_t)-1)

namespace AC {

template <typename SymbolT>
class Keyword
{
public:
	virtual size_t size() const = 0;
	virtual SymbolT const &operator[](size_t index) const = 0;
	virtual void debug_keyword() const {}
	virtual void debug_symbol(size_t index) const {}
};

template <typename SymbolT>
class Haystack
{
public:
	Haystack()
	:	offset_(0)
	{}

	bool next(SymbolT const *&input)
	{
		return this->at(offset_++, input);
	}

	size_t last() { return offset_ - 1; }

private:
	virtual bool at(size_t offset, SymbolT const *&input) = 0;

	size_t offset_;
};

template <typename SymbolT>
class AhoCorasick
{
public:
	typedef Keyword<SymbolT> keyword_t;
	typedef typename std::vector<keyword_t *>::iterator keyword_iter_t;
	typedef size_t state_t;
	typedef std::map<SymbolT, state_t> edges_t;
	typedef std::vector<edges_t> nodes_t;
	typedef std::set<keyword_t const *> outputs_t;
	typedef std::map<state_t, outputs_t> OutputFunction;

	AhoCorasick(keyword_iter_t const &begin, keyword_iter_t const &end)
	:	g_(begin, end, o_),
		f_(g_, o_)
	{
	}

	void operator()(
			Haystack<SymbolT> &haystack,
			void (*hit)(size_t index, keyword_t const *keyword))
	{
		debug("*** Performing search...\n");
		state_t state = 0;
		SymbolT const *input;
		while (haystack.next(input))
		{
			state_t state2;
			while ((state2 = g_(state, *input)) == FAIL_STATE) {
				//debug("failed %zu -> ", state);
				state = f_(state);
				//debug("%zu\n", state);
			}
			state = state2;
			{
				std::set<keyword_t const *> const &out_node = o_[state];
				typename outputs_t::const_iterator out_it;
				for (out_it = out_node.begin(); out_it != out_node.end(); out_it++)
				{
					(hit)(haystack.last(), *out_it);
				}
			}
		}

	}

private:
	//typedef std::map<state_t, std::set<keyword_t const *> > OutputFunction;

	class GotoFunction
	{
	public:
		GotoFunction(
				keyword_iter_t begin,
				keyword_iter_t const &end,
				OutputFunction &output)
		{
			debug("*** Generating goto function...\n");
			state_t newstate = 0;
			for ( ; begin != end; begin++) {
				debug("Entering("); (*begin)->debug_keyword(); debug(")\n");
				enter(**begin, newstate, output);
			}
		}

		nodes_t const &nodes() { return nodes_; }

		state_t operator()(state_t state, SymbolT const &symbol)
		{
			try {
				return nodes_.at(state).at(symbol);
			} catch (std::out_of_range &) {
				if (state == 0) return 0;
				else return FAIL_STATE;
			}
		}

	private:
		void enter(
				keyword_t const &keyword,
				state_t &newstate,
				OutputFunction &output)
		{
			state_t state = 0;
			size_t index = 0;
			//typename nodes_t::iterator *node;
			edges_t *node;
			/* follow existing edges */
			while (true)
			{
				typename edges_t::iterator edge;
				if (state == nodes_.size())
					nodes_.resize(state + 1);
				node = &nodes_[state];
				edge = node->find(keyword[index]);
				if (edge == node->end()) break;
				state = edge->second;
				index++;
			}
			/* generate new edges */
			while (index < keyword.size())
			{
				// newstate <- newstate + 1
				newstate += 1;
				// g(state a_p) <- newstate
				debug("g(%zu, ", state);
				keyword.debug_symbol(index);
				debug(") <- %zu\n", newstate);
				(*node)[keyword[index++]] = newstate;
				// state <- newstate
				state = newstate;
				// node <- lambda x: g(state, x)
				if (state == nodes_.size())
					nodes_.resize(state + 1);
				node = &nodes_[state];
			}
			output[state].insert(&keyword);
		}

		nodes_t nodes_;
	};

	class FailureFunction
	{
	public:
		FailureFunction(
				GotoFunction &gotof,
				OutputFunction &outputf)
		:	fail_(gotof.nodes().size(), FAIL_STATE)
		{
			debug("*** Generating failure function...\n");
			std::deque<state_t> queue;
			typename edges_t::const_iterator edge_it;
			/* queue all the nonfail root edges */
			edges_t const &rootnode = gotof.nodes()[0];
			for (edge_it = rootnode.begin(); edge_it != rootnode.end(); ++edge_it)
			{
				std::pair<SymbolT, state_t> const &edge(*edge_it);
				queue.push_back(edge.second);
				fail_[edge.second] = 0;
			}
			/* generate failure transitions */
			while (!queue.empty())
			{
				state_t r = queue.front();
				queue.pop_front();
				edges_t const &node = gotof.nodes()[r];
				for (edge_it = node.begin(); edge_it != node.end(); ++edge_it)
				{
					SymbolT const &a(edge_it->first);
					state_t const s(edge_it->second);
					queue.push_back(s);
					state_t state = fail_[r];
					while (gotof(state, edge_it->first) == FAIL_STATE) {
						assert(state != FAIL_STATE);
						state = fail_[state];
					}
					// f(s) <- g(state, a)
					debug("f(%zu) <- %zu\n", s, gotof(state, a));
					fail_[s] = gotof(state, a);
					// output(s) <- output(s) U output(f(s))
					outputf[s].insert(outputf[fail_[s]].begin(), outputf[fail_[s]].end());
				}
			}
		}

		state_t operator()(state_t state)
		{
			return fail_[state];
		}

	private:
		std::vector<state_t> fail_;
	};

	AhoCorasick(AhoCorasick const &);

	OutputFunction o_;
	GotoFunction g_;
	FailureFunction f_;
};

}; // namespace AC {

//#include <list>
#include <deque>
#include <iostream>
#include <map>
#include <set>
#include <vector>

template <typename SymbolT>
class Keyword
{
public:
	virtual size_t size() const = 0;
	virtual SymbolT const &operator[](size_t index) const = 0;
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

	AhoCorasick(keyword_iter_t const &begin, keyword_iter_t const &end)
	:	g_(begin, end, o_),
		f_(g_, o_)
	{
	}

private:
	typedef std::map<state_t, std::set<keyword_t const *> > OutputFunction;

	class GotoFunction
	{
	public:
		GotoFunction(
				keyword_iter_t begin,
				keyword_iter_t const &end,
				OutputFunction &output)
		{
			state_t newstate = 0;
			for ( ; begin != end; begin++)
				enter(**begin, newstate, output);
		}

		nodes_t const &nodes() { return nodes_; }

		state_t operator()(state_t state, SymbolT symbol)
		{
			return nodes_[state][symbol];
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
				(*node)[keyword[index++]] = ++newstate;
				state = newstate;
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
		:	fail_(gotof.nodes().size(), -1)
		{
			std::cerr << "Generating failure function..." << std::endl;
			std::deque<state_t> queue;
			typename edges_t::const_iterator edge_it;
			/* queue all the nonfail root edges */
			edges_t const &rootnode = gotof.nodes()[0];
			for (edge_it = rootnode.begin(); edge_it != rootnode.end(); ++edge_it)
			{
				std::pair<SymbolT, state_t> const &edge(*edge_it);
				queue.push_back(edge.second);
				fail_[edge.second] = 0;
				std::cerr << "g(" << 0 << ", " << edge.first << ") is " << edge.second << std::endl;
			}
			/* generate failure transitions */
			while (!queue.empty())
			{
				state_t r = queue.front();
				queue.pop_front();
				edges_t const &node = gotof.nodes()[r];
				for (edge_it = node.begin(); edge_it != node.end(); ++edge_it)
				{
					state_t s(edge_it->second);
					queue.push_back(s);
					state_t state = fail_[r];
					while (gotof(state, edge_it->first) == -1)
						state = fail_[state];
					fail_[edge_it->second] = gotof(state, edge_it->first);
					outputf[s].insert(outputf[fail_[s]].begin(), outputf[fail_[s]].end());
				}


			}
		}
	private:
		std::vector<state_t> fail_;
	};

	AhoCorasick(AhoCorasick const &);

	OutputFunction o_;
	GotoFunction g_;
	FailureFunction f_;
};

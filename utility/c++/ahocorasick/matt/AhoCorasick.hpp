#pragma once

#include <cassert>
#include <deque>
#include <ext/hash_map>
#include <map>
#include <set>
#include <vector>

template <typename SymbolT>
class AhoCorasick
{
public:
	typedef size_t state_t;
	static size_t const AC_FAIL_STATE = -1;

	// KeywordIterT is a sequence of sequences of SymbolT
	template <typename KeywordIterT>
	AhoCorasick(
			KeywordIterT const & kw_begin,
			KeywordIterT const & kw_end)
	:	goto_(kw_begin, kw_end, output_),
		fail_(goto_, output_),
		where_(0),
		state_(0)
	{
	}

	// input is sequence of symbols
	// CallbackT must be callable with (size_t what, size_t where)
	template <typename InputIterT, typename CallbackT>
	void search(
			InputIterT input_it,
			InputIterT input_end,
			CallbackT & callback)
	{
		for ( ; input_it != input_end; ++input_it, where_++)
		{
			SymbolT const &input(*input_it);
			{
				state_t next;
				while ((next = goto_(state_, input)) == AC_FAIL_STATE)
					state_ = fail_(state_);
				state_ = next;
			}
			{
				std::set<size_t> const &out_node = output_[state_];
				typename std::set<size_t>::const_iterator output_it;
				for (output_it = out_node.begin(); output_it != out_node.end(); ++output_it)
				{
					callback(*output_it, where_);
				}
			}
		}
	}

	// use this to start a new scan
	void reset() { state_ = 0; where_ = 0; }

private:
	typedef std::map<state_t, std::set<size_t> > OutputFunction;

	class GotoFunction
	{
	public:
		typedef __gnu_cxx::hash_map<SymbolT, state_t> edges_t;
		typedef std::vector<edges_t> nodes_t;

		template <typename KeywordIterT>
		GotoFunction(
				KeywordIterT kw_iter,
				KeywordIterT const & kw_end,
				OutputFunction & output_f)
		{
			state_t newstate = 0;
			size_t kw_index = 0;
			for ( ; kw_iter != kw_end; ++kw_iter)
			{
				enter(*kw_iter, newstate);
				output_f[newstate].insert(kw_index++);
			}
		}

		state_t operator()(state_t state, SymbolT const & symbol) const
		{
			assert(state < graph_.size());
			edges_t const &node(graph_[state]);
			typename edges_t::const_iterator const &edge_it(node.find(symbol));
			if (edge_it != node.end())
			{
				return edge_it->second;
			}
			else
			{
				return (state == 0) ? 0 : AC_FAIL_STATE;
			}
		}

		nodes_t const & get_nodes() const { return graph_; }

	private:
		template <typename KeywordT>
		void enter(
				KeywordT const & keyword,
				state_t & newstate)
		{
			state_t state = 0;
			size_t index = 0;
			edges_t *node;

			// follow existing symbol edges
			for ( ; index < keyword.size(); index++)
			{
				// this node won't be initialized
				if (state == graph_.size())
					graph_.resize(state + 1);
				node = &graph_[state];
				typename edges_t::iterator edge = node->find(keyword[index]);
				if (edge == node->end()) break;
				state = edge->second;
			}
			// increase graph size by the number of remaining symbols
			graph_.resize(graph_.size() + keyword.size() - index);
			node = &graph_[state];
			// generate new symbol edges
			for ( ; index < keyword.size(); index++)
			{
				(*node)[keyword[index]] = ++newstate;
				state = newstate;
				node = &graph_[state];
			}
			assert(graph_.size() == state + 1);
		}

		nodes_t graph_;
	};

	class FailureFunction
	{
	public:
		FailureFunction(
				GotoFunction const & _goto,
				OutputFunction & output)
		:	table_(_goto.get_nodes().size(), AC_FAIL_STATE)
		{
			std::deque<state_t> queue;

			queue_edges(_goto.get_nodes()[0], queue);

			while (!queue.empty())
			{
				state_t r = queue.front();
				queue.pop_front();
				typename GotoFunction::edges_t const &node(_goto.get_nodes()[r]);
				typename GotoFunction::edges_t::const_iterator edge_it;
				for (edge_it = node.begin(); edge_it != node.end(); ++edge_it)
				{
					std::pair<SymbolT, state_t> const &edge(*edge_it);
					SymbolT const &a(edge.first);
					state_t const &s(edge.second);

					queue.push_back(s);
					state_t state = table_[r];
					while (_goto(state, a) == AC_FAIL_STATE)
						state = table_[state];
					table_[s] = _goto(state, a);
					output[s].insert(
							output[table_[s]].begin(),
							output[table_[s]].end());
				}
			}
		}

		state_t operator()(state_t state) const
		{
			return table_[state];
		}

	private:
		std::vector<state_t> table_;

		/* queue nonfail edges */
		inline void queue_edges(
				typename GotoFunction::edges_t const & node,
				std::deque<state_t> & queue)
		{
			typename GotoFunction::edges_t::const_iterator edge_it;
			for (edge_it = node.begin(); edge_it != node.end(); ++edge_it)
			{
				std::pair<SymbolT, state_t> const &edge(*edge_it);
				queue.push_back(edge.second);
				table_[edge.second] = 0;
			}
		}
	};

	OutputFunction output_;
	GotoFunction const goto_;
	FailureFunction const fail_;
	size_t where_;
	state_t state_;
};

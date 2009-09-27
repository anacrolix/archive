#include <boost/function.hpp>
#include <climits>
#include <string>

class Horspool
{
public:
    Horspool(std::string const &pattern);

    void operator()(
            char const *const buffer,
            size_t const length, boost::function<void (size_t)>);

protected:
    size_t m_;
    size_t d_[1 << CHAR_BIT];
    std::string p_;
};

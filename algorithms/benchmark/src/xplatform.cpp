#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <boost/system/windows_error.hpp>
#include <boost/cstdint.hpp>
#include <cassert>

using namespace std;

class WindowsException : public exception
{
public:
	WindowsException(DWORD error_code = GetLastError())
	:	error_code_(error_code)
	{
	}

	virtual char const *what() const
	{
		// TODO FormatMessage...
		return NULL;
	}

private:
	DWORD error_code_;
};

/** safely convert as per recommended in msdn */
inline static boost::uint64_t filetime_to_uint64_t(FILETIME const &filetime)
{
	ULARGE_INTEGER uli;
	uli.HighPart = filetime.dwHighDateTime;
	uli.LowPart = filetime.dwLowDateTime;
	return uli.QuadPart;
}

// this will sum the time taken by multiple threads, rather than split it
double process_execution_time()
{
	FILETIME creation_time, exit_time, kernel_time, user_time;
	if (0 == ::GetProcessTimes(GetCurrentProcess(), &creation_time, &exit_time, &kernel_time, &user_time))
		throw WindowsException();
	boost::uint64_t total_time(filetime_to_uint64_t(kernel_time) + filetime_to_uint64_t(user_time));
	// the times have 100ns precision
	return total_time / 10000000.0;
}
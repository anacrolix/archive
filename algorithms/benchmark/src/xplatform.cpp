#if defined(WIN32)
    #define WIN32_LEAN_AND_MEAN
    #include <Windows.h>
    #include <boost/system/windows_error.hpp>
    #include <boost/cstdint.hpp>
    #include <cassert>
#else
    #include <exception>
    #include <sys/times.h>
    #include <unistd.h>
#endif

using namespace std;

#if defined(WIN32)

class WindowsException : public exception
{
public:
    WindowsException(DWORD error_code = GetLastError())
    :   error_code_(error_code)
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

#endif

// this will sum the time taken by multiple threads, rather than split it
double process_execution_time()
{
#if defined(WIN32)
    FILETIME creation_time, exit_time, kernel_time, user_time;
    if (0 == ::GetProcessTimes(GetCurrentProcess(), &creation_time, &exit_time, &kernel_time, &user_time))
        throw WindowsException();
    boost::uint64_t total_time(filetime_to_uint64_t(kernel_time) + filetime_to_uint64_t(user_time));
    // the times have 100ns precision
    return total_time / 10000000.0;
#else
    struct tms times_buf;
    if ((clock_t)-1 == times(&times_buf)) throw exception();
    long ticks_per_sec = sysconf(_SC_CLK_TCK);
    if (ticks_per_sec < 1) throw exception();
    clock_t total_time = times_buf.tms_utime + times_buf.tms_stime;
    return (double)total_time / ticks_per_sec;
#endif
}

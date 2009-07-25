#include "reuters.hh"
#include <gtest/gtest.h>
#if defined(_DEBUG)
//#define Py_DEBUG
#undef _DEBUG
#endif
#include <Python.h>
#if defined(Py_DEBUG)
#define _DEBUG
#endif

using namespace std;

class PythonError : public exception
{
public:
    virtual char const *what() const throw()
    {
        return "boobies";
    }
};

PyObject *get_module_function(char const *modname, char const *funcname)
{
    // both are unchecked in release build of python
    if (!modname || !modname) return NULL;
    PyObject *module;
    {
        PyObject *modstr = PyString_FromString(modname);
        module = PyImport_Import(modstr);
        Py_DECREF(modstr);
    }
    if (!module) return NULL;
    PyObject *function = PyObject_GetAttrString(module, funcname);
    Py_DECREF(module);
    return function;
}

class PythonStrFind : public SearchInstance
{
public:
    PythonStrFind(Keywords const &keywords)
    {
        Py_Initialize();
        PyRun_SimpleString("import sys\nsys.path.insert(0, '')");
        //PyRun_SimpleString("print sys.path");
        function_ = get_module_function("py_find", "str_count");
        if (!function_)
        {
            PyErr_Print();
            throw PythonError();
        }
        keywords_ = PyTuple_New(keywords.size());
        for (size_t i = 0; i < keywords.size(); ++i)
        {
            // set item steals the string reference created
            if (0 != PyTuple_SetItem(
                    keywords_, i, PyString_FromStringAndSize(
                            keywords.at(i).c_str(), keywords[i].size())))
            {
                throw PythonError();
            }
        }
    }

    virtual ~PythonStrFind()
    {
        Py_DECREF(keywords_);
        Py_DECREF(function_);
        Py_Finalize();
    }

    virtual void operator()(char const *buffer, size_t length, size_t already, Hits &hits)
    {
        PyObject *py_hit_count = PyObject_CallFunction(function_, "(Os#)", keywords_, buffer, length);
        ASSERT_TRUE(PyInt_CheckExact(py_hit_count));
        long hit_count = PyInt_AsLong(py_hit_count);
        Py_DECREF(py_hit_count);
        //Hits::value_type &cheap_skate(hits.front());
        //while (hit_count-- > 0) cheap_skate.insert(cheap_skate.size());
        //cheap_skate = hit_count;
        hits.front() += hit_count;
    }

protected:
    PyObject *keywords_;
    PyObject *function_;
};



TEST_F(Reuters21578, Python)
{
    PythonStrFind psf(keywords());
    search_wrapper(psf);
}

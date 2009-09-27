#include <Python.h>
#include "horspool.h"
#include <boost/bind.hpp>
#include <boost/function.hpp>
#include <iostream>

using namespace std;

#if 0
static PyObject * hello_wrapper(PyObject * self, PyObject * args)
{
char * input;
char * result;
PyObject * ret;
// parse arguments
if (!PyArg_ParseTuple(args, "s", &input)) {
return NULL;
}
// run the actual function
result = hello(input);
// build the resulting string into a Python object.
ret = PyString_FromString(result);
free(result);
return ret;
}
#endif

static void delete_Horspool(void *horspool)
{
    delete (Horspool *)(horspool);
}

static PyObject *Horspool_new(PyObject *self, PyObject *args)
{
    //cout << self << endl;
    char const *pattern;
    if (!PyArg_ParseTuple(args, "s", &pattern)) return NULL;
    return PyCObject_FromVoidPtr(new Horspool(string(pattern)), delete_Horspool);
}

static void Horspool_hits_callback(PyObject *py_callback, size_t position)
{
    PyObject *args = Py_BuildValue("(k)", position);
    if (!args) PyErr_Print();
    PyObject *result = PyObject_CallObject(py_callback, args);
    if (!result) PyErr_Print();
    //cout << result << endl;
    Py_XDECREF(result);
}

static PyObject *Horspool_call(PyObject *self, PyObject *args)
{
    //cout << self << endl;
    PyObject *py_horspool;
    char const *buffer;
    Py_ssize_t length;
    PyObject *py_callback;
    if (!PyArg_ParseTuple(args, "Os#O", &py_horspool, &buffer, &length, &py_callback)) return NULL;
    Horspool *horspool(reinterpret_cast<Horspool *>(PyCObject_AsVoidPtr(py_horspool)));
    horspool->operator ()(buffer, size_t(length),
            boost::bind(Horspool_hits_callback, py_callback, _1));
    Py_INCREF(Py_None);
    return Py_None;
}

static PyMethodDef HorspoolMethods[] =
{
    { "Horspool_new", Horspool_new, METH_VARARGS, NULL },
    { "Horspool_call", Horspool_call, METH_VARARGS, NULL },
    { NULL, NULL, 0, NULL }
};

PyMODINIT_FUNC initchorspool(void)
{
    Py_InitModule("chorspool", HorspoolMethods);
}

#include <Python.h>

/*
def total_ke(molecules):
	ke = 0.0
	for mol in molecules:
		ke += abs(mol.vel) ** 2
	return ke / 2
*/
static PyObject *
total_ke(PyObject *dummy, PyObject *args)
{
	double ke = 0.0;
	PyObject *mollist;
	if (!PyArg_ParseTuple(args, "O", &mollist)) return NULL;
	if (!PyList_Check(mollist)) return NULL;
	int size = PyList_Size(mollist);
	for (int i = 0; i < size; i++) {
		PyObject *mol = PyList_GetItem(mollist, i);
		if (mol == NULL) return NULL;
		PyObject *vel = PyObject_GetAttrString(mol, "vel");
		if (vel == NULL) return NULL;
		PyObject *absvel = PyNumber_Absolute(vel);
		double tke = PyFloat_AsDouble(absvel);
		ke += pow(tke, 2);
		if (absvel == NULL) return NULL;
	}
	return Py_BuildValue("d", ke / 2);
}

PyMethodDef md_methods[] = {
	{"total_ke", total_ke, METH_VARARGS},
	{NULL, NULL}
};

PyMODINIT_FUNC
initmd(void)
{
	(void) Py_InitModule("md", md_methods);
}

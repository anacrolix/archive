#include <Python.h>

/*
def total_ke(molecules):
	ke = 0.0
	for mol in molecules:
		ke += abs(mol.vel) ** 2
	return ke / 2
*/
static PyObject *
total_ke(PyObject *self, PyObject *args)
{
	double ke = 0.0;
	PyObject *mol_list;
	if (!PyArg_ParseTuple(args, "O", &mol_list)) return NULL;
	if (!PyList_Check(mol_list)) return NULL;
	int size = PyList_Size(mol_list);
	for (int i = 0; i < size; i++) {
		PyObject *mol, *vel, *abs;
		if (!(mol = PyList_GetItem(mol_list, i))) return NULL;
		if (!(vel = PyObject_GetAttrString(mol, "vel"))) return NULL;	
		if (!(abs = PyNumber_Absolute(vel))) return NULL;
		double tke = PyFloat_AsDouble(abs);
		ke += pow(tke, 2);
		Py_DECREF(vel);
		Py_DECREF(abs);
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

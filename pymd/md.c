#include <Python.h>

static PyObject *
total_ke(PyObject *self, PyObject *args)
{
	/*
	def total_ke(molecules):
		ke = 0.0
		for mol in molecules:
			ke += abs(mol.vel) ** 2
		return ke / 2
	*/
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

static PyObject *
total_pe(PyObject *self, PyObject *args)
{
	/*
	def total_pe():
		pe = 0.0
		for m1 in range(len(molecules)):
			mol1 = molecules[m1]
			for m2 in range(m1 + 1, len(molecules)):
				mol2 = molecules[m2]
				r12 = abs(mol1.pos - mol2.pos)
				assert abs(mol2.pos - mol1.pos) == r12
				pe += r12 ** -6 * (r12 ** -6 - 2)
		return pe 
	*/
	double pe = 0.0;
	PyObject *mol_list;
	if (!PyArg_ParseTuple(args, "O", &mol_list)) return NULL;
	if (!PyList_Check(mol_list)) return NULL;
	int size = PyList_Size(mol_list);
	for (int m1 = 0; m1 < size; m1++) {
		PyObject *mol1, *mol1pos;
		if (!(mol1 = PyList_GetItem(mol_list, m1))) return NULL;
		if (!(mol1pos = PyObject_GetAttrString(mol1, "pos"))) return NULL;
		for (int m2 = m1 + 1; m2 < size; m2++) {
			PyObject *mol2, *mol2pos, *r12vec, *pysep;
			if (!(mol2 = PyList_GetItem(mol_list, m2))) return NULL;
			if (!(mol2pos = PyObject_GetAttrString(mol2, "pos"))) return NULL;
			if (!(r12vec = PyNumber_Subtract(mol1pos, mol2pos))) return NULL;
			if (!(pysep = PyNumber_Absolute(r12vec))) return NULL;
			double r12 = PyFloat_AsDouble(pysep);
			pe += pow(r12, -6) * (pow(r12, -6) - 2);
			Py_DECREF(mol2pos);
			Py_DECREF(r12vec);
			Py_DECREF(pysep);
		}
		Py_DECREF(mol1pos);
	}	
	return Py_BuildValue("d", pe);
}

static PyObject *
get_accels(PyObject *self, PyObject *args)
{
	/*
	def get_accels(molecules):
		accels = []
		for mol1 in molecules:
			accel = vector()
			for mol2 in molecules:
				if mol1 == mol2: continue
				r12 = abs(mol1.pos - mol2.pos)
				assert abs(mol2.pos - mol1.pos) == r12
				fcom = (12 * r12 ** -8) * (r12 ** -6 - 1)
				force = fcom * (mol1.pos - mol2.pos)
				accel += force
			accels.append(accel)
		return accels
	*/
	PyObject *mol_list;
	if (!PyArg_ParseTuple(args, "O", &mol_list)) return NULL;
	if (!PyList_Check(mol_list)) return NULL;
	int size = PyList_Size(mol_list);
	double accels[size];	
	for (int m1 = 0; m1 < size; m1++) {
		accels[m1] = 0;
		for (int m2 = 0; m2 < size; m2++) {
			if (m1 == m2) continue;
			double r12, fcom, force;
		}
	}
	return NULL;
}

PyMethodDef md_methods[] = {
	{"total_ke", total_ke, METH_VARARGS},
	{"total_pe", total_pe, METH_VARARGS},
	{"get_accels", get_accels, METH_VARARGS},
	{NULL, NULL}
};

PyMODINIT_FUNC
initmd(void)
{
	(void) Py_InitModule("md", md_methods);
}

void initialize(int n, float mass, float fcon, int delta, float grav,
	float sep, float ballsize, float dt, double *x, double *y,
	double *z, int num_threads);

void loopcode(int n, float mass, float fcon,
	int delta, float grav, float sep, float ballsize,
	float dt, double *x, double *y, double *z, int num_threads);

double pe;

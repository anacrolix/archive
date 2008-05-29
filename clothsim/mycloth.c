#include "cloth.h"
#include <omp.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>

#define VEL_DAMP 0.995

typedef long index_t;

struct vector {	double x, y, z; };
#define vector_new(x, y, z, i) ((struct vector){x[(i)], y[(i)], z[(i)]})
#define vector_out(v, i, j, k, q) do { \
		struct vector const _v = (v); \
		(i)[(q)] = _v.x; \
		(j)[(q)] = _v.y; \
		(k)[(q)] = _v.z; \
	} while (false)

extern int
	n,
	delta,
	num_threads;
	
extern float
	dt,
	ballsize,
	grav,
	sep,
	fcon;

double *fx, *fy, *fz; // forces
double *vx, *vy, *vz; // velocities
double *oldfx, *oldfy, *oldfz; // old forces
//double *intsqrts; // precalculated integer square roots

// useful macros
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define for_each_cloth_node(a, b) \
	for (index_t a = 0; a < b*b; a++)
#define mag(x, y, z) (sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)))
#define SWAP(a, b) do { \
	__typeof__((a)) _c = (a); a = b; b = _c; } while (false)
/* VECTOR STUFF */

#define vector_mag(v) (mag((v).x, (v).y, (v).z))

inline struct vector vector_scale(struct vector v, double n)
{
	return (struct vector){v.x * n, v.y * n, v.z * n};
}

void inline __eval_pef(struct vector *f, index_t t, index_t dx,
	index_t dy, double len2_idx, index_t j)
{
	double len = sqrt((len2_idx + (j-dy)*(j-dy)) * sep);
	double r12_x = x[dx * n + dy] - x[t];
	double r12_y = y[dx * n + dy] - y[t];
	double r12_z = z[dx * n + dy] - z[t];
	double r12_mag = mag(r12_x, r12_y, r12_z);
	pe += fcon * pow(r12_mag * len, 2);
	double a = (r12_mag - len) * fcon / len;
	f->x += a * r12_x;
	f->y += a * r12_y;
	f->z += a * r12_z;
}

void inline _eval_pef_j(struct vector *f, index_t t, index_t dx, index_t i,
	index_t j)
{
	double len2_idx = pow(i - dx, 2);
	for (index_t dy = MAX(j - delta, 0); dy < j; dy++)
		__eval_pef(f, t, dx, dy, len2_idx, j);
	if (i != dx) __eval_pef(f, t, dx, j, len2_idx, j);
	index_t const dy_max = MIN(j + delta + 1, n);
	for (index_t dy = j + 1; dy < dy_max; dy++)
		__eval_pef(f, t, dx, dy, len2_idx, j);
}	

/// calculates PE and F
double eval_pef()
{
	pe = 0.0;
	index_t t_max = n * n;
	#pragma omp parallel for schedule(dynamic, 128)
	for (index_t t = 0; t < t_max; t++) {
		index_t i = t / n;
		index_t j = t % n;
		struct vector f = {0.0, 0.0, -grav};
		index_t const dx_max = MIN(i + delta + 1, n);
		for (index_t dx = MAX(i - delta, 0); dx < dx_max; dx++)
		{
			_eval_pef_j(&f, t, dx, i, j);
		}
		fx[t] = f.x;
		fy[t] = f.y;
		fz[t] = f.z;
	}
	return pe;
} 

// allocate memory and initialize PE and F
void initialize()
{
	// allocate and zero F and v arrays
	double **simarrs[] =
		{&fx, &fy, &fz, &vx, &vy, &vz, &oldfx, &oldfy, &oldfz};
	index_t const simarrs_len = 
		sizeof(simarrs) / sizeof(__typeof__(*simarrs));
	assert(simarrs_len == 9);
	for (index_t i = 0; i < simarrs_len; i++) {
		*simarrs[i] = calloc(n * n, sizeof(***simarrs));
		for (index_t j = 0; j < n * n; j++) {
			(*simarrs[i])[j] = 0.0;
		}
	}
	/*
	// precalculate integer square roots
	intsqrts = malloc(sizeof(double) * delta * delta * 2 + 1);
	for (index_t i = 0; i < delta * delta * 2 + 1; i++)
		intsqrts[i] = sqrt(i);
	*/
	// set maximum omp threads
	omp_set_num_threads(num_threads);
	// evaluate potential and force
	pe = eval_pef(n, delta, grav, sep, fcon, num_threads);
}

// this is the the body for one integration timestep
void loopcode()
{
	// update position as per MD simulation, copy force array
	#pragma omp parallel for schedule(guided, n)
	for (index_t i = 0; i < n*n; i++) {
		x[i] += dt * (vx[i] + dt * fx[i] / 2.0);
		y[i] += dt * (vy[i] + dt * fy[i] / 2.0);
		z[i] += dt * (vz[i] + dt * fz[i] / 2.0);
	}
	SWAP(fx, oldfx);
	SWAP(fy, oldfy);
	SWAP(fz, oldfz);

	// push node to outside of cloth, remove radial velocity
	#pragma omp parallel for schedule(guided, n)
	for_each_cloth_node(i, n) {
		struct vector sep = vector_new(x, y, z, i);
		double dist = vector_mag(sep);
		if (dist < ballsize) {
			struct vector newpos = vector_scale(sep, ballsize / dist);
			vector_out(newpos, x, y, z, i);
			struct vector vel = vector_new(vx, vy, vz, i);
			struct vector urp = vector_scale(sep, 1 / ballsize);
			double dotprod_mag = vel.x * urp.x + vel.y * urp.y + vel.z * urp.z;
			urp = vector_scale(urp, dotprod_mag);
			vel.x -= urp.x; vel.y -= urp.y; vel.z -= urp.z;
			vector_out(vel, vx, vy, vz, i);
			//vx[i] = 0; vy[i] = 0; vz[i] = 0;
		}
	}

	// calculate force and PE at new coordinates
	pe = eval_pef(n, delta, grav, sep, fcon, num_threads);
	
	// dampen velocity
	#pragma omp parallel for
	for_each_cloth_node(i, n) {
		vector_out(vector_scale(vector_new(vx, vy, vz, i), VEL_DAMP), vx, vy, vz, i);
	}
	#pragma omp parallel for
	for (index_t i = 0; i < n*n; i++) {
		vx[i] += dt * (fx[i] + oldfx[i]) / 2.0;
		vy[i] += dt * (fy[i] + oldfy[i]) / 2.0;
		vz[i] += dt * (fz[i] + oldfz[i]) / 2.0;
	}
}

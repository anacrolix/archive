#include "cloth.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>

#define VEL_DAMP 0.995

typedef long unsigned index_t;

struct vector {	double x, y, z; };
#define vector_new(x, y, z, i) ((struct vector){x[(i)], y[(i)], z[(i)]})
#define vector_out(v, i, j, k, q) do { \
		struct vector const _v = (v); \
		(i)[(q)] = _v.x; \
		(j)[(q)] = _v.y; \
		(k)[(q)] = _v.z; \
	} while (false)

double *fx, *fy, *fz; // forces
double *vx, *vy, *vz; // velocities
double *oldfx, *oldfy, *oldfz; // old forces

// stores the ball attributes
double xball, yball, zball, rball;

// useful macros
#define MAX(a,b) ( (a) > (b) ? (a) : (b))
#define MIN(a,b) ( (a) < (b) ? (a) : (b))
#define for_each_cloth_node(a, b) \
	for (index_t a = 0; a < b*b; a++)
#define mag(x, y, z) (sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)))

/* VECTOR STUFF */

#define vector_mag(v) (mag((v).x, (v).y, (v).z))

/// calculates PE and F
double eval_pef(int n, int delta, double grav, double sep,
                double fcon, double *x, double *y, double *z,		
                double *fx, double *fy, double *fz)
{
  //loop over particles
      //loop over displacements
	  // exclude self interaction
	    // compute reference distance
	    // compute actual distance
	    //potential energy and force
	pe = 0.0;
	for (long i = 0; i < n; i++) {
		for (long j = 0; j < n; j++) {
			long t = i * n + j;
			fx[t] = 0.0;
			fy[t] = 0.0;
			fz[t] = -grav;
			for (long dx = MAX(i - delta, 0); dx < MIN(i + delta + 1, n); dx++) {
				for (long dy = MAX(j - delta, 0); dy < MIN(j + delta + 1, n); dy++) {
					double len = sqrt((pow(i - dx, 2) + pow(j - dy, 2)) * sep);
					//double len = 1.0;
					if (i != dx || j != dy) {
						double r12_x = x[dx * n + dy] - x[i * n + j];
						double r12_y = y[dx * n + dy] - y[i * n + j];
						double r12_z = z[dx * n + dy] - z[i * n + j];
						double r12_mag = mag(r12_x, r12_y, r12_z);
						pe += fcon * pow(r12_mag * len, 2);
						fx[i * n + j] += fcon * r12_x / len * (r12_mag - len);
						fy[i * n + j] += fcon * r12_y / len * (r12_mag - len);
						fz[i * n + j] += fcon * r12_z / len * (r12_mag - len);
					}
				}
			}
		}
	}
	return pe;
} 

/* This is the initialization routine, to allocate memory and do
   first PE and force evaluation */

void initialize(int n, float mass, float fcon,
		int delta, float grav, float sep, float ballsize,
		float dt, double *x, double *y, double *z)
{
	// allocate and zero force and vel arrays
	double **simarrs[] = {&fx, &fy, &fz, &vx, &vy, &vz, &oldfx, &oldfy, &oldfz};
	long const simarrs_len = sizeof(simarrs) / sizeof(__typeof__(*simarrs));
	assert(simarrs_len == 9);
	for (long i = 0; i < simarrs_len; i++) {
		*simarrs[i] = calloc(n * n, sizeof(double));
		for (long j = 0; j < n * n; j++) {
			(*simarrs[i])[j] = 0.0;
		}
	}
  // evaluate potential and force
  pe = eval_pef(n, delta, grav, sep, fcon, x, y, z, fx, fy, fz);
  // save ballsize
  rball = ballsize;
}

/*
double vector_mag(struct vector v)
{
	return sqrt(pow(v.x, 2) + pow(v.y, 2) + pow(v.z, 2));
}
*/
struct vector vector_scale(struct vector v, double n)
{
	return (struct vector){v.x * n, v.y * n, v.z * n};
}

/// This is the the body for one integration timestep
void loopcode(int n, float mass, float fcon,
	      int delta, float grav, float sep, float ballsize,
	      float dt, double *x, double *y, double *z)
{
	//update position as per MD simulation, copy force array
	for (index_t i = 0; i < n*n; i++) {
		x[i] += dt * (vx[i] + dt * fx[i] / 2.0);
		y[i] += dt * (vy[i] + dt * fy[i] / 2.0);
		z[i] += dt * (vz[i] + dt * fz[i] / 2.0);
	}
	memcpy(oldfx, fx, sizeof(*fx) * n * n);
	memcpy(oldfy, fy, sizeof(*fy) * n * n);
	memcpy(oldfz, fz, sizeof(*fz) * n * n);

	//	apply constraints - push cloth outside of ball, set to zero velocity
	for_each_cloth_node(i, n) {
		struct vector sep = vector_new(x, y, z, i);
		double dist = vector_mag(sep);
		if (dist < ballsize) {
			struct vector newpos = vector_scale(sep, ballsize / dist);
			vector_out(newpos, x, y, z, i);
			vx[i] = 0; vy[i] = 0; vz[i] = 0;
		}
	}

	// calculate force and PE at new coordinates
	pe = eval_pef(n, delta, grav, sep, fcon, x, y, z, fx, fy, fz);
	
	// dampen velocity
	for_each_cloth_node(i, n) {
		vector_out(vector_scale(vector_new(vx, vy, vz, i), VEL_DAMP), vx, vy, vz, i);
	}
		
	for (index_t i = 0; i < n*n; i++) {
		vx[i] += dt * (fx[i] + oldfx[i]) / 2.0;
		vy[i] += dt * (fy[i] + oldfy[i]) / 2.0;
		vz[i] += dt * (fz[i] + oldfz[i]) / 2.0;
	}
}

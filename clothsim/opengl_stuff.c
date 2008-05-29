#include "cloth.h"
#include <GL/gl.h>			
#include <GL/glu.h>
#include <GL/glut.h>
//#include "/usr/glut/include/GL/glut.h"
#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <math.h>
#include <errno.h>

#define crossProduct(a0,a1,a2,b0,b1,b2,c0,c1,c2,d0,d1,d2) \
   (d0) = ((b1)-(a1)) * ((c2)-(a2)) - ((c1)-(a1)) * ((b2)-(a2)); \
   (d1) = ((b2)-(a2)) * ((c0)-(a0)) - ((c2)-(a2)) * ((b0)-(a0)); \
   (d2) = ((b0)-(a0)) * ((c1)-(a1)) - ((c0)-(a0)) * ((b1)-(a1));

double *x, *y, *z;
double *cpx, *cpy, *cpz;

int
	n = 25,
	delta = 2,
	update = 5,
	nogui = 0,
	maxiter,
	rendermode = 2,
	paused = 0,
	num_threads = 1;
float
	sep = 0.5,
	mass = 1,
	fcon = 10,
	grav = 1,
	dt = 0.01,
	offset = 0.0f,
	ballsize = 3;

struct timeval 
	*tp1,
	*tp2;

int loop = 0;
void keyboard(unsigned char key, int x, int y);
void motion(int x, int y);
void mouse(int button, int state, int x, int y);
void display(void);
void reshape(int width, int height);
void draw_scene();
static void init();

GLfloat btrans[3];			// current background translation 
GLfloat brot[3];			// current background rotation 

GLfloat trans[3];			// current translation 
GLfloat rot[3];				// current model rotation 
GLfloat crot[3];			// current camera rotation 

GLuint startList;
GLuint body;
GLuint mainball;

GLfloat plasticbody_color[] = { 1.0, 0.39, 0.39, 1.0 };
GLfloat mat_ambient[] = { 0.7, 0.7, 0.7, 1.0 };
GLfloat mat_diffuse[] = { 0.1, 0.5, 0.8, 1.0 };
GLfloat mat_specular[] = { 0.80, 0.8, 0.80, 1.0 };
GLfloat light_amb[] = { 0.525, 0.525, 0.525, 1.0 };
GLfloat light_position[] = { 25.0, 45.0, 19.0, 1.0 };
int mousex, mousey;

GLUquadricObj *qobj;		
static int	Menu;	

/// glut idle callback
static void idleTime(void)
{
	if (paused) {
		glutPostRedisplay();
		usleep(10000);
	} else {
		loopcode(n, mass, fcon, delta, grav, sep, ballsize, dt, x, y,
			z, num_threads);

		if (loop % update == 0) {
			glutPostRedisplay();
			gettimeofday(tp2, NULL);
			if (loop % (update * 50) == 0) {
				printf("____________________________________________________\n"
				"  Loop_Num           PE          Elapsed Time\n\n");
			}
			printf("%10d %20.12e ",loop,pe);
			printf("%12.6f\n",(float)(tp2->tv_sec-tp1->tv_sec)+
			(float)(tp2->tv_usec-tp1->tv_usec) * 1.0e-6);
		}
		loop++;
	}
}

/// Initialise matrices to 0, mallocs, etc
void initMatrix()
{
	int i, nx, ny;
	// allocate arrays to hold locations of nodes
	x = (double *)malloc(n*n*sizeof(double));
	y = (double *)malloc(n*n*sizeof(double));
	z = (double *)malloc(n*n*sizeof(double));
	//This is for opengl stuff
	cpx = (double *)malloc(n*n*sizeof(double));
	cpy = (double *)malloc(n*n*sizeof(double));
	cpz = (double *)malloc(n*n*sizeof(double));

	//initialize coordinates of cloth
	for (nx=0;nx<n;nx++) {
		for (ny=0;ny<n;ny++) {
			x[n*nx+ny] = nx*sep-(n-1)*sep*0.5+offset;
			z[n*nx+ny] = ballsize+1;
			y[n*nx+ny] = ny*sep-(n-1)*sep*0.5+offset;
			cpx[n*nx+ny] = 0;
			cpz[n*nx+ny] = 1;
			cpy[n*nx+ny] = 0;
		}
	}
}

void __attribute__((noreturn)) usage(int exitcode)
{
	printf(
		" %s\n"
		"Nodes_per_dimension:             -n int \n"
		"Grid_separation:                 -s float \n"
		"Mass_of_node:                    -m float \n"
		"Force_constant:                  -f float \n"
		"Node_interaction_level:          -d int \n"
		"Gravity:                         -g float \n"
		"Radius_of_ball:                  -b float \n"
		"offset_of_falling_cloth:         -o float \n"
		"timestep:                        -t float \n"
		"Timesteps_per_display_update:    -u int \n"
		"Perform X timesteps without GUI: -x int\n"
		"Rendermode:                      -r (1,2,3)\n"
		, program_invocation_name);
	exit(exitcode);
}

int main(int argc, char *argv[])
{
	// assess input flags
	if (argc % 2 == 0)
		argv[1][0]= 'x';

	for (long i = 1; i < argc; i += 2) {
		if (argv[i][0] == '-') {	
			switch (argv[i][1]) {
				case 'n':
				n = atoi(argv[i+1]);
				break;
				case 's':
				sep = atof(argv[i+1]);
				break;
				case 'm':	
				mass = atof(argv[i+1]);
				break;
				case 'f':
				fcon = atof(argv[i+1]);
				break;
				case 'd':
				delta = atoi(argv[i+1]);
				break;
				case 'g':
				grav = atof(argv[i+1]);
				break;
				case 'b':
				ballsize = atof(argv[i+1]);
				break;
				case 'o':
				offset = atof(argv[i+1]);
				break;
				case 't':
				dt = atof(argv[i+1]);
				break;
				case 'u':
				update = atoi(argv[i+1]);
				break;
				case 'x':
				maxiter = atoi(argv[i+1]);
				nogui = 1;
				break;
				case 'r':
				rendermode = atoi(argv[i+1]);
				break;
				case 'p':
					num_threads = atoi(argv[i + 1]);
					break;
				default:
					usage(EXIT_FAILURE);
			}
		} else {
			printf(" %s\n"
			"Nodes_per_dimension:             -n int \n"
			"Grid_separation:                 -s float \n"
			"Mass_of_node:                    -m float \n"
			"Force_constant:                  -f float \n"
			"Node_interaction_level:          -d int \n"
			"Gravity:                         -g float \n"
			"Radius_of_ball:                  -b float \n"
			"offset_of_falling_cloth:         -o float \n"
			"timestep:                        -t float \n"
			"Timesteps_per_display_update:    -u int \n"
			"Perform X timesteps without GUI: -x int\n"
			"Rendermode (1 for face shade, 2 for vertex shade, 3 for no shade):\n"
			"                                 -r (1,2,3)\n",argv[0]);
			return -1;
		}
	}

	// print out values to be used in the program
	printf(
		"____________________________________________________\n"
		"_____ COMP3320 Assignment 2 - Cloth Simulation _____\n"
		"____________________________________________________\n"
		"Number of nodes per dimension:  %d\n"
		"Grid separation:                %f\n"
		"Mass of node:                   %f\n"
		"Force constant                  %f\n"
		"Node Interaction Level (delta): %d\n"
		"Gravity:                        %f\n"
		"Radius of Ball:                 %f\n"
		"Offset of falling cloth:        %f\n"
		"Timestep:                       %f\n"
		"Timesteps per display update:   %i\n"
		"Max OpenMP threads:             %d\n",
		n, sep, mass, fcon, delta, grav, ballsize, offset, dt, update,
		num_threads);

	initMatrix();   // set up
	tp1=(struct timeval *)malloc(sizeof(struct timeval));
	tp2=(struct timeval *)malloc(sizeof(struct timeval));

	initialize(n, mass, fcon, delta, grav, sep, ballsize, dt, x, y, z, num_threads);

	if (nogui == 0) {
		printf("\nUsing OpenGL GUI\n\n MOUSE:\n Drag to rotate\n KEYS:\n 'spacebar' to pause/resume\n '-' to zoom out\n '=' to zoom in\n '1' for per face shading\n '2' for per vertex shading\n '3' for no shading\n 'Esc' to quit\n"
		"____________________________________________________\n"
		);

		// ----- GUI starts here
		glutInitWindowSize(500, 500);
		glutInitWindowPosition(100, 75);
		glutInit(&argc, argv);
		glutInitDisplayMode(GLUT_DOUBLE | GLUT_DEPTH | GLUT_RGB);
		glutCreateWindow("COMP3320 Assignment2");
		init();		// set up all lists and other stuff
		glutKeyboardFunc(&keyboard);
		glutMotionFunc(&motion);
		glutMouseFunc(&mouse);
		glutDisplayFunc(&display);
		glutReshapeFunc(reshape);
		glutIdleFunc(idleTime);
		glEnable(GL_DEPTH_TEST);
		glEnable(GL_NORMALIZE);
		glEnable(GL_POINT_SMOOTH);
		gettimeofday(tp1, NULL);
		glutMainLoop();
		// ----------GUI ends here
	} else {
		/* THIS LOOP EXECUTES THE NO GUI VERSION OF THE CODE*/
		printf("\nNo GUI\n"
		"Number of Iterations:           %d\n"
		"____________________________________________________\n",maxiter);
		gettimeofday(tp1, NULL);
		for (loop = 0; loop < maxiter; loop++) {
			loopcode(n,mass,fcon,delta,grav,sep,ballsize,dt,x,y,z, num_threads);
			if(loop%update==0){
				gettimeofday(tp2, NULL);
				if(loop%(update*50)==0){
					printf("____________________________________________________\n"
					"  Loop_Num            PE          Elapsed Time\n\n");
				}
				printf("%10d %20.12e ",loop,pe);
				printf("%12.6f\n",(float)(tp2->tv_sec-tp1->tv_sec)+
				(float)(tp2->tv_usec-tp1->tv_usec)*1.0e-6);
			}
		}
		return EXIT_SUCCESS;
	} 
	return EXIT_FAILURE;
}

void noshade(void)
{
	long nx, ny;
	glNormal3f(1, 1, 1);
	for (nx = 0; nx < n - 1; nx++) {
		for (ny = 0; ny < n - 1; ny++) {
			glBegin(GL_TRIANGLES);
			glVertex3f(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny]);
			glVertex3f(x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny]);
			glVertex3f(x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1]);
			glVertex3f(x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny]);
			glVertex3f(x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1]);
			glVertex3f(x[(nx+1)*n+ny+1],y[(nx+1)*n+ny+1],z[(nx+1)*n+ny+1]);
			glEnd();
		}
	}
}

void faceshade(void){
  int nx,ny;
  float cx,cy,cz;
  for (nx=0;nx<n-1;nx++){
    for (ny=0;ny<n-1;ny++){
      glBegin(GL_TRIANGLES);
      crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],cx,cy,cz);
      glNormal3f(cx,cy,cz);	
      glVertex3f(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny]);
      glVertex3f(x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny]);
      glVertex3f(x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1]);
      crossProduct(x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],x[(nx+1)*n+ny+1],y[(nx+1)*n+ny+1],z[(nx+1)*n+ny+1],cx,cy,cz);
      glNormal3f(-cx,-cy,-cz);
      glVertex3f(x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny]);
      glVertex3f(x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1]);
      glVertex3f(x[(nx+1)*n+ny+1],y[(nx+1)*n+ny+1],z[(nx+1)*n+ny+1]);
      glEnd();
    }
  }
}
void vertexshade(void){
  int nx,ny;
  float cx,cy,cz;
  for (nx=0;nx<n;nx++){
    for (ny=0;ny<n;ny++){
      cpx[n*nx+ny] = 0;
      cpz[n*nx+ny] = 0;
      cpy[n*nx+ny] = 0;
    }
  }
  nx=0;ny=0;
  crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],cx,cy,cz);
  cpx[n*nx+ny] -= cx;
  cpz[n*nx+ny] -= cy;
  cpy[n*nx+ny] -= cz;
  ny=n-1;
  crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],x[nx*n+ny-1],y[nx*n+ny-1],z[nx*n+ny-1],cx,cy,cz);
  cpx[n*nx+ny] -= cx;
  cpz[n*nx+ny] -= cy;
  cpy[n*nx+ny] -= cz;
  nx=n-1;
  crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[nx*n+ny-1],y[nx*n+ny-1],z[nx*n+ny-1],x[(nx-1)*n+ny],y[(nx-1)*n+ny],z[(nx-1)*n+ny],cx,cy,cz);
  cpx[n*nx+ny] -= cx;
  cpz[n*nx+ny] -= cy;
  cpy[n*nx+ny] -= cz;
  ny=0;
  crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx-1)*n+ny],y[(nx-1)*n+ny],z[(nx-1)*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],cx,cy,cz);
  cpx[n*nx+ny] -= cx;
  cpz[n*nx+ny] -= cy;
  cpy[n*nx+ny] -= cz;

  for (ny=1;ny<n-1;ny++){
    nx = 0;
    crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],cx,cy,cz);
    cpx[n*nx+ny] -= cx;
    cpz[n*nx+ny] -= cy;
    cpy[n*nx+ny] -= cz;
    crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],x[nx*n+ny-1],y[nx*n+ny-1],z[nx*n+ny-1],cx,cy,cz);
    cpx[n*nx+ny] -= cx;
    cpz[n*nx+ny] -= cy;
    cpy[n*nx+ny] -= cz;
    nx = n-1;
    crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx-1)*n+ny],y[(nx-1)*n+ny],z[(nx-1)*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],cx,cy,cz);
    cpx[n*nx+ny] -= cx;
    cpz[n*nx+ny] -= cy;
    cpy[n*nx+ny] -= cz;
    crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[nx*n+ny-1],y[nx*n+ny-1],z[nx*n+ny-1],x[(nx-1)*n+ny],y[(nx-1)*n+ny],z[(nx-1)*n+ny],cx,cy,cz);
    cpx[n*nx+ny] -= cx;
    cpz[n*nx+ny] -= cy;
    cpy[n*nx+ny] -= cz;
  }

  for (nx=1;nx<n-1;nx++){
    ny = 0;
    crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx-1)*n+ny],y[(nx-1)*n+ny],z[(nx-1)*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],cx,cy,cz);
    cpx[n*nx+ny] -= cx;
    cpz[n*nx+ny] -= cy;
    cpy[n*nx+ny] -= cz;
    crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],cx,cy,cz);
    cpx[n*nx+ny] -= cx;
    cpz[n*nx+ny] -= cy;
    cpy[n*nx+ny] -= cz;
    ny = n-1;
    crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],x[nx*n+ny-1],y[nx*n+ny-1],z[nx*n+ny-1],cx,cy,cz);
    cpx[n*nx+ny] -= cx;
    cpz[n*nx+ny] -= cy;
    cpy[n*nx+ny] -= cz;
    crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[nx*n+ny-1],y[nx*n+ny-1],z[nx*n+ny-1],x[(nx-1)*n+ny],y[(nx-1)*n+ny],z[(nx-1)*n+ny],cx,cy,cz);
    cpx[n*nx+ny] -= cx;
    cpz[n*nx+ny] -= cy;
    cpy[n*nx+ny] -= cz;
  }

  for (nx=1;nx<n-1;nx++){
    for (ny=1;ny<n-1;ny++){
      crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx-1)*n+ny],y[(nx-1)*n+ny],z[(nx-1)*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],cx,cy,cz);
      cpx[n*nx+ny] -= cx;
      cpz[n*nx+ny] -= cy;
      cpy[n*nx+ny] -= cz;
      crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],cx,cy,cz);
      cpx[n*nx+ny] -= cx;
      cpz[n*nx+ny] -= cy;
      cpy[n*nx+ny] -= cz;		crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny],x[nx*n+ny-1],y[nx*n+ny-1],z[nx*n+ny-1],cx,cy,cz);
      cpx[n*nx+ny] -= cx;
      cpz[n*nx+ny] -= cy;
      cpy[n*nx+ny] -= cz;
      crossProduct(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny],x[nx*n+ny-1],y[nx*n+ny-1],z[nx*n+ny-1],x[(nx-1)*n+ny],y[(nx-1)*n+ny],z[(nx-1)*n+ny],cx,cy,cz);
      cpx[n*nx+ny] -= cx;
      cpz[n*nx+ny] -= cy;
      cpy[n*nx+ny] -= cz;
    }
  }
  for (nx=0;nx<n-1;nx++){
    for (ny=0;ny<n-1;ny++){
      glBegin(GL_TRIANGLES);
      glNormal3f(cpx[nx*n+ny],cpy[nx*n+ny],cpz[nx*n+ny]);	
      glVertex3f(x[nx*n+ny],y[nx*n+ny],z[nx*n+ny]);
      glNormal3f(cpx[(nx+1)*n+ny],cpy[(nx+1)*n+ny],cpz[(nx+1)*n+ny]);	
      glVertex3f(x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny]);
      glNormal3f(cpx[nx*n+ny+1],cpy[nx*n+ny+1],cpz[nx*n+ny+1]);	
      glVertex3f(x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1]);
      glNormal3f(cpx[(nx+1)*n+ny],cpy[(nx+1)*n+ny],cpz[(nx+1)*n+ny]);
      glVertex3f(x[(nx+1)*n+ny],y[(nx+1)*n+ny],z[(nx+1)*n+ny]);
      glNormal3f(cpx[nx*n+ny+1],cpy[nx*n+ny+1],cpz[nx*n+ny+1]);
      glVertex3f(x[nx*n+ny+1],y[nx*n+ny+1],z[nx*n+ny+1]);
      glNormal3f(cpx[(nx+1)*n+ny+1],cpy[(nx+1)*n+ny+1],cpz[(nx+1)*n+ny+1]);
      glVertex3f(x[(nx+1)*n+ny+1],y[(nx+1)*n+ny+1],z[(nx+1)*n+ny+1]);
      glEnd();
    }
  }
}

static void init(void)
{
	int temp;
	float ballrendersize;
	body = glGenLists(1);
	mainball = glGenLists(1);	
	qobj = gluNewQuadric();
	gluQuadricNormals(qobj,GLU_SMOOTH);
	temp = 3;
	ballrendersize = ballsize - 0.06;
	if(ballrendersize < 0.01)ballrendersize = ballsize;
	glNewList(body, GL_COMPILE);	//sphere
	gluSphere(qobj, 0.1, temp, temp);
	glEndList();
	glNewList(mainball, GL_COMPILE);	//sphere
	gluSphere(qobj, ballrendersize * 0.98, 8, 8);
	glEndList();
}

/// when button is pressed
void mouse(int button, int state, int x, int y)
{
	// set the x and y coords for use in calculating movement in next iteration
	mousex = x;
	mousey = y;
}

void motion(int x,int y){
  crot[2]+=(x-mousex)*360/500;		// camera rotate based on mouse movement
  crot[1]-=(y-mousey)*360/500;
  mousex = x;							// set the x and y coords for use in calculating movement in next iteration
  mousey = y;
}

void keyboard(unsigned char key, int x, int y)		// key bindings
{

  switch (key) {
  case '1':
    rendermode=1;break;
  case '2':
    rendermode=2;break;
  case '3':
    rendermode=3;break;
  case 32: //space
    printf("PAUSED\n");
    paused++;
    paused=paused%2;break;
  case '-':
    glScalef(0.9,0.9,0.9);
    glutPostRedisplay();
    break;
  case '=':
    glScalef(1.2,1.2,1.2);
    glutPostRedisplay();
    break;
  case 27:		// Escape = Exit
    exit(0);
    break;
  }
}

void reshape(int width, int height)		// fix up orientations and initial translations
{
  glViewport(0, 0, width, height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(60.0, (float)width/height, 2, 1000.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(0.0f, 0.0f, -20.0f);
  glRotatef(-90,1.0f, 0.0f, 0.0f);
  glRotatef(0,0.0f, 1.0f, 0.0f);
  glRotatef(90,0.0f, 0.0f, 1.0f);
}

void display()						// main display routine
{
  glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  draw_scene();  
  glFlush();
  glutSwapBuffers();
}

void draw_scene()			// draw scene
{
	int nx,ny;
	glPushMatrix();
	glRotatef(crot[1], 0.0f, 1.0f, 0.0f);
	glRotatef(crot[2], 0.0f, 0.0f, 1.0f);
	glRotatef(crot[0], 1.0f, 0.0f, 0.0f);
	glLightfv(GL_LIGHT0,GL_SPECULAR, mat_specular);
	glLightfv(GL_LIGHT0, GL_POSITION, light_position);
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glEnable(GL_COLOR_MATERIAL);
	glEnable(GL_AUTO_NORMAL);
	GLfloat lmodel_ambient[] = { 0.3, 0.3, 0.3, 1.0 };
	glLightModelfv(GL_LIGHT_MODEL_AMBIENT, lmodel_ambient);
	mat_diffuse[0] = 1.0;
	mat_diffuse[1] = 1.0;
	mat_diffuse[2] = 0.6;
	glPushMatrix();
	glColor3f(0, 0, 1); 
	glCallList(mainball);
	int i,ke;
	glColor3f(0.2, 0.7, 0.2); 
	switch (rendermode) {
		case 2: vertexshade(); break;
		case 1: faceshade(); break;
		default: noshade();
	}
	glPopMatrix();
	glPopMatrix();
}


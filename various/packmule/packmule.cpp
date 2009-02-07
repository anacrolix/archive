#include "glib/IoChannel.hpp"
#include "CopyChannel.hpp"
#include <iostream>

int main(int argc, char *argv[])
{
	//if (argc != 3) return 1;
	IoChannel src1(argv[1], "r");
	IoChannel dst1(argv[2], "w");
	IoChannel src2(argv[1], "r");
	IoChannel dst2(argv[3], "w");
	CopyChannel cc1(src1, dst1);
	CopyChannel cc2(src2, dst2, 2000);
	GMainLoop *loop = g_main_loop_new(NULL, FALSE);
	g_main_loop_run(loop);
	return 0;
}

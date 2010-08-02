AC_INIT([cpfs], [2010.8], [anacrolix@gmail.com])
#AC_CONFIG_AUX_DIR([ac-aux])
AC_CONFIG_HEADERS([config.h])
#AC_CONFIG_MACRO_DIR([ac-macro])
#AC_CONFIG_SRCDIR([src/cpfs.c])
AM_INIT_AUTOMAKE([foreign -Wall -Werror])
AC_PROG_CC
PKG_CHECK_MODULES([FUSE], [fuse])
AM_PROG_CC_C_O
AC_CONFIG_FILES([Makefile src/Makefile])
AC_OUTPUT

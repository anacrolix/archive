AC_INIT([miniplay], [0.02], [anacrolix@gmail.com])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([foreign])

AC_PROG_CC

PKG_CHECK_MODULES([gio], [gio-2.0], [:])
PKG_CHECK_MODULES([gtk], [gtk+-2.0], [:])
PKG_CHECK_MODULES([gstreamer], [gstreamer-0.10], [:])
PKG_CHECK_MODULES([libnotify], [libnotify], [:])

AC_PREFIX_DEFAULT(/usr)

AC_CONFIG_FILES([Makefile])
AC_OUTPUT


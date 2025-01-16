# -*- Autoconf -*-
#
#

# Version info, used both in library versioning and inside sstmacro.
m4_define([HGCC_VERSION_TAG], 1)
m4_define([HGCC_SUBVERSION_TAG], 0)
m4_define([HGCC_SUBSUBVERSION_TAG], 0)

dnl Enable this for releases
m4_define([HGCC_SNAPSHOT_TAG])
dnl Enable this for beta releases
dnl m4_define([HGCC_SNAPSHOT_TAG],-beta1)
# Enable this for development snapshots (should generally be enabled)
#m4_define([HGCC_SNAPSHOT_TAG],-snapshot)

# Construct the sstmacro version
m4_define([HGCC_ACVERSION_TAG],
          [HGCC_VERSION_TAG.HGCC_SUBVERSION_TAG.HGCC_SUBSUBVERSION_TAG])

dnl AC_PREREQ([2.71]) avoid this if possible
AC_INIT([hgcc],[HGCC_ACVERSION_TAG],[sst-help@sandia.gov])
AC_CONFIG_MACRO_DIR([acinclude])
#AC_CONFIG_HEADERS(sstmac/common/config.h)
#AX_PREFIX_CONFIG_H(sstmac/common/sstmac_config.h, SSTMAC)
AC_CANONICAL_TARGET

if test "X$prefix" == "XNONE"; then
  MY_PREFIX=$ac_default_prefix
else
  MY_PREFIX=`cd $prefix ; pwd`
fi
MY_ABS_SRCPATH=`cd $srcdir ; pwd`

# More version info.
AH_TEMPLATE([VERSION], [Major version number])
AH_TEMPLATE([SUBVERSION], [Major version number])
AH_TEMPLATE([SUBSUBVERSION], [Major version number])
AC_DEFINE_UNQUOTED(VERSION, [HGCC_VERSION_TAG])

# Init automake
AM_INIT_AUTOMAKE([tar-pax -Wall -Werror foreign -Wno-portability subdir-objects])
AM_PROG_AS
m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

#-------------------------------------------------
# Environment 
#-------------------------------------------------

# Find out if this is running Mac OS X.
darwin=false
case $target_os in
  darwin*)  darwin=true ;;
esac
AM_CONDITIONAL([DARWIN],[test "$darwin" = true])

# Check compilers and environment
dnl AC_PROG_RANLIB
AC_PROG_CC
AC_PROG_CXX
AC_LANG([C++])

AC_PROG_LN_S

os=`$srcdir/bin/config_tools/get_os`

if test "X$os" = "Xubuntu"; then
LDFLAGS="$LDFLAGS -Wl,--no-as-needed"
AM_CONDITIONAL([HAVE_UBUNTU], [true])
else
AM_CONDITIONAL([HAVE_UBUNTU], [false])
fi

CHECK_PYTHON()

CHECK_CLANG()

CHECK_GCC()

CHECK_DEFAULT_INCLUDES()

CHECK_CXX_STD()

#AM_CONDITIONAL(HAVE_REGEXP, false)

CHECK_CLANG_LLVM()

#-------------------------------------------------
# Finalize 
#-------------------------------------------------

dnl Don't reorder options.
dnl AC_PRESERVE_HELP_ORDER

#AC_CONFIG_FILES([bin/sstmacro-config], [chmod +x bin/sstmacro-config])
AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([bin/sst++], [chmod +x bin/hg++])
AC_CONFIG_FILES([bin/sstcc], [chmod +x bin/hgcc])
AC_CONFIG_FILES([bin/sstccvars.py])

AC_OUTPUT

# --------- Print out a configuration summary. ---------
echo
echo " Configuration Summary:"
echo "---------------------------------------------------------------"
echo "Install prefix     $prefix"
echo "OS                 $os"
echo "C compiler         $CC"
echo "C++ compiler       $CXX"
echo "CFLAGS             $CFLAGS"
echo "CXXFLAGS           $CXXFLAGS $SST_CXXFLAGS $STD_CXXFLAGS"
echo "CPPFLAGS           $CPPFLAGS"
echo "LDFLAGS            $LDFLAGS"
echo "C++ Standard       $cxxstd"
echo

echo "Python             $pyexe"
echo "Clang Autoskeleton $found_clang"
echo "---------------------------------------------------------------"


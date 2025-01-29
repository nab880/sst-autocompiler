
AC_DEFUN([CHECK_SST_MACRO], [

AC_ARG_WITH([sst-macro],
    AS_HELP_STRING([--with-sst-macro@<:@=DIR@:>@],
        [location of SST/macro install]
    ), [
      SST_MACRO="$withval"
      AC_DEFINE([SST_MACRO], 1, [SST/macro presence])
    ], []
)

AC_CHECK_HEADERS([$SST_MACRO/include/sstmac/null_buffer.h], [],
      [AC_MSG_ERROR([Could not locate SST/macro header files at $SST_MACRO])])

AC_SUBST(SST_MACRO)

])


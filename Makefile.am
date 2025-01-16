#
#   This file is part of SST/macroscale: 
#                The macroscale architecture simulator from the SST suite.
#   Copyright (c) 2009-2023, NTESS.
#   This software is distributed under the BSD License.
#   Under the terms of Contract DE-NA0003525 with NTESS,
#   the U.S. Government retains certain rights in this software.
#   For more information, see the LICENSE file in the top 
#   SST/macroscale directory.
#

AM_CPPFLAGS = -I$(top_builddir) -I$(top_srcdir) -I$(top_srcdir)/include -I$(top_srcdir)/sprockit -I$(top_builddir)/sprockit

bin_PROGRAMS = 

dist_bin_SCRIPTS = \
  sstcclib.py \
  sstccutils.py \
  sstcompile.py \
  sstlink.py \
  configlib.py


bin_SCRIPTS = sstmacro-config sstccvars.py


AM_LDFLAGS += -ldl










sstmac_LDADD = $(exe_LDADD) -ldl 

EXTRA_DIST += clang

if HAVE_CLANG
bin_PROGRAMS += sstmac_clang
sstmac_clang_SOURCES = \
  clang/util.cc \
  clang/main.cc \
  clang/astVisitorGlobalVars.cc \
  clang/pragmas.cc \
  clang/computePragma.cc \
  clang/computeVisitor.cc \
  clang/replacePragma.cc \
  clang/astConsumers.cc \
  clang/frontendActions.cc \
  clang/astVisitor.cc 


sstmac_clang_CXXFLAGS = -fno-rtti $(AM_CXXFLAGS)
sstmac_clang_CPPFLAGS = $(CLANG_CPPFLAGS) $(AM_CPPFLAGS)

if HAVE_CXX17
sstmac_clang_SOURCES += \
	clang/annotatePragma.cc \
	clang/memoizePragma.cc \
	clang/memoizeVariableCaptureAnalyzer.cc \
	clang/ompPuppetizePragma.cc \
	clang/memoizeVariable.cc

old_standards=-std=c++11 -std=c++0x -std=c++1y -std=c++14 -std=c++1z
libclang17_a_CXXFLAGS = $(filter-out $(old_standards), $(sstmac_clang_CXXFLAGS))

library_includedir=$(includedir)/memoization
library_include_HEADERS = clang/memoization/capture.h
endif

sstmac_clang_LDFLAGS = $(CLANG_LDFLAGS) \
 -Wl,-rpath,@CLANG_INSTALL_DIR@/lib \
 -lclangFrontend \
 -lclangFrontendTool \
 -lclangTooling \
 -lclangBasic \
 -lclangASTMatchers \
 -lclangFormat \
 -lclangFrontend \
 -lclangDriver \
 -lclangParse \
 -lclangSerialization \
 -lclangSema \
 -lclangEdit \
 -lclangAnalysis \
 -lclangToolingCore \
 -lclangAST \
 -lclangRewrite \
 -lclangLex \
 -lclangBasic \
 @CLANG_LIBTOOLING_LIBS@ \
 @CLANG_LIBTOOLING_SYSTEM_LIBS@

# TODO Figure out this was included
# if CLANG_NEED_LIBCPP
# sstmac_clang_LDFLAGS += -lclang-cpp
# endif

endif




endif




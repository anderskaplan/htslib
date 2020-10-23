MSVC build
==========
This directory contains scripts for building libhts and its test suite
with the Microsoft Visual C/C++ compiler. It works out-of-the-box with Visual
Studio 2015 and should be possible to adapt for other versions of MSVC as well.

The MSVC adaptation is intended to be as non-intrusive and lightweight as
possible, meaning for example:
- #ifdefs and other modifications of the htslib sources are avoided as far as
  possible.
- Visual Studio solution files and NMake makefiles are preferred over, for
  example, CMake build scripts.

Prerequisites
-------------
This guide assumes that you have installed the following:
- Microsoft Visual Studio 2015
- Git for Windows (earlier msysGit): not strictly necessary, but a convenient
  way to get access to perl, bash, diff, and other unix tools required to run
  the test suite.

How to build htslib
-------------------
1. Install zlib and pthreads-w32 as described below.
2. Open a command prompt, change to the msvc directory, and run the command
   "perl version.pl".
3. Open the libhts.sln solution file with Visual Studio, select the x64 platform
   and the Debug configuration, then Build/Build Solution.
4. Switch to the Release configuration and build again.

Installing zlib
---------------
Zlib is a compression library which is used by libhts.
1. Download the zlib source code from [zlib.net](http://www.zlib.net/).
2. Extract the contents into the msvc directory. There should now be one
   directory called zlib, which only contains a vcxproj file (i.e., a MSVC
   project file), and one directory called zlib-1.2.11 or similar.
3. Copy the contents of the directory with the version number into the zlib
   directory.

Installing pthreads-w32
-----------------------
Pthreads-w32 is an implementation of the Threads component of the POSIX 1003.1c
1995 Standard (or later) for Microsoft's Win32 environment.
1. Download the pthreads-w32 binaries from [sourceware.org](https://www.sourceware.org/pthreads-win32/).
2. Extract the contents into the msvc directory. Rename the directory called
   Pre-built.2 to pthreads-w32.

Installing bzip2
----------------
Bzip2 is a compression library which is used by libhts.
1. Download the tarball from [bzip.org](http://www.bzip.org/downloads.html)
2. Extract the contents of the innermost directory into msvc/bzip2.

Installing liblzma (XZ Utils)
-----------------------------
Liblzma is a compression library with an API similar to that of zlib.
1. Download the XZ Utils tarball from [tukaani.org](http://tukaani.org/xz/)
2. Extract the contents into the msvc/lzma directory.

Running the test suite
----------------------
Libhts comes with an extensive test suite. You should run it to make sure your
setup works properly.
1. Build libhts as described above.
2. Launch a developer command prompt for Visual Studio, x64 Native Tools. (See [MSDN](https://msdn.microsoft.com/en-us/library/f2ccy3wt.aspx) for more info.)
3. Change to the msvc directory
4. Run the command: "nmake /f testapps.mak test". If you're building for a
   64-bit architecture, add the declaration "Platform=x64" before the
   target name "test". Note that the declaration is case sensitive.
5. If all goes well, a series of test should start running, and you should end
   up with the final verdict: "failed  .. 0".

# nmake makefile for test apps
# usage: nmake /f testapps.mak [Platform=Win32] [Configuration=Release] test

!IF "$(Configuration)" == ""
Configuration = Debug
!ENDIF

!IF "$(Platform)" == ""
Platform = x64
!ENDIF

!IF "$(Platform)" == "Win32"
Architecture = x86
!ELSEIF "$(Platform)" == "x64"
Architecture = x64
!ELSE
!ERROR Unknown Platform
!ENDIF

cc = cl.exe
cflags = /I.. /I. /Ipthreads-w32\include /Izlib /D_TIMESPEC_DEFINED /D_CRT_SECURE_NO_WARNINGS /DHTS_x86 /MDd
libs = libhts.lib pthreadVC2.lib zlib.lib bzip2.lib lzma.lib ws2_32.lib
ldflags = /LIBPATH:$(Platform)\$(Configuration) \
	/LIBPATH:pthreads-w32\lib\$(Architecture)

testdir = ..\test
bindir = ..
objdir = obj

BUILT_TEST_PROGRAMS = \
	$(testdir)\hts_endian.exe \
	$(testdir)\fieldarith.exe \
	$(testdir)\hfile.exe \
	$(testdir)\pileup.exe \
	$(testdir)\plugins-dlhts.exe \
	$(testdir)\sam.exe \
	$(testdir)\test_bgzf.exe \
	$(testdir)\test_kfunc.exe \
	$(testdir)\test_kstring.exe \
	$(testdir)\test_realn.exe \
	$(testdir)\test-regidx.exe \
	$(testdir)\test_str2int.exe \
	$(testdir)\test_view.exe \
	$(testdir)\test_index.exe \
	$(testdir)\test-vcf-api.exe \
	$(testdir)\test-vcf-sweep.exe \
	$(testdir)\test-bcf-sr.exe \
#	$(testdir)\fuzz\hts_open_fuzzer.o \
	$(testdir)\test-bcf-translate.exe \
	$(testdir)\test-parse-reg.exe \
	$(bindir)\htsfile.exe \
	$(bindir)\bgzip.exe \
	$(bindir)\tabix.exe

all : $(objdir) $(BUILT_TEST_PROGRAMS) $(testdir)\pthreadVC2.dll $(bindir)\pthreadVC2.dll

# For tests that might use it, set $REF_PATH explicitly to use only reference
# areas within the test suite (or set it to ':' to use no reference areas).
check test: all
	$(testdir)\hts_endian
	$(testdir)\fieldarith $(testdir)\fieldarith.sam
	cd .. & test\hfile
	cd $(testdir)\mpileup & sh -c "./test-pileup.sh mpileup.tst"
	cd .. & test\sam test\ce.fa test\faidx.fa
	$(testdir)\test_bgzf $(testdir)\bgziptest.txt
	$(testdir)\test_kfunc
	$(testdir)\test_kstring
	$(testdir)\test_str2int
	$(testdir)\test-parse-reg -t $(testdir)\colons.bam
	cd $(testdir)\tabix & sh -c "./test-tabix.sh tabix.tst"
	$(testdir)\test-regidx
	cd $(testdir) & set REF_PATH= & perl test.pl -f -t /tmp/hts-test

$(objdir) :
	mkdir $(objdir)

{$(testdir)}.c{$(testdir)}.exe :
  $(cc) $(cflags) /Fo:$(objdir)\ /Fe:$@ $< $(libs) /link $(ldflags)

{$(bindir)}.c{$(bindir)}.exe :
  $(cc) $(cflags) /Fo:$(objdir)\ /Fe:$@ $< $(libs) /link $(ldflags)

$(testdir)\pthreadVC2.dll : pthreads-w32\dll\$(Architecture)\pthreadVC2.dll
	copy /b $** $@

$(bindir)\pthreadVC2.dll : pthreads-w32\dll\$(Architecture)\pthreadVC2.dll
	copy /b $** $@

clean :
	del $(BUILT_TEST_PROGRAMS) \
		$(objdir)\*.obj \
		$(testdir)\pthreadVC2.dll \
		$(bindir)\pthreadVC2.dll

# This file demonstrates how to compile the fileExt project
# on Linux. Just run "make" to compile it.
# only 32 bit ubuntu can compile it..

GPP=g++ -static
GCC=gcc -static
OUTFILE="Compiled/Linux/fileExt"

COMPILE_FLAGS=-c -O3 -w -DLINUX -ISDK -ISDK/amx

all:
	$(GCC) $(COMPILE_FLAGS) SDK/amx/*.c
	$(GPP) $(COMPILE_FLAGS) SDK/*.cpp
	$(GPP) $(COMPILE_FLAGS) *.cpp
	$(GPP) -fPIC -O2 -fshort-wchar -shared -o $(OUTFILE) *.o
	rm *.o

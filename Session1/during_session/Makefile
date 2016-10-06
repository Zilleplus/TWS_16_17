# Variable for the selected compiler (see $ fortrancompilers)
FC=nagfor

# Possible compilation flags per compiler
FFLAGS_g95      = -g -pedantic -Wall -fbounds-check -ftrace=full
FFLAGS_gfortran = -g -pedantic -Wall -Wimplicit-interface -Wunderflow -fbounds-check -fimplicit-none
FFLAGS_ifort    = -g -debug full -implicitnone -check -warn -free -Tf
FFLAGS_nagfor   = -g -C=all -gline -u -info -colour
# TIP: the following flags can be interesting to detect errors:
#      -Wall -fbounds-check -g -std=f95 -ftrace=full
# (remark that the name sometimes differs from compiler to compiler)
# Select the right flags for the current compiler
FFLAGS=$(FFLAGS_$(FC))
# or not
#FFLAGS=

ifeq ($(FC) , ifort)
	ext = f90
else
	ext = f95
endif
r = hello_world
opt = hello_module
#-----------------------------------------------------------------------------------------
default:
	@ echo "Only make r, make hello_world and make clean are possible"

# Read as: "all" is dependent on the source files "hello_world.f95", once it is up-to-date, the program is compiled as follows.
# Via `make all', we possibly copy to a file that can be recognized by ifort, we compile and link the program and execute it.
all: hello_world.f95
	if [ ${FC} = ifort ]; then \
		cp hello_world.f95 hello_world.f90; \
	fi
	$(FC) -c $(FFLAGS) hello_module.$(ext)
	$(FC) -c $(FFLAGS) hello_world.$(ext)
	$(FC) -o hello_world hello_module.o hello_world.o
	./hello_world

# Only do the compiling
hello_world.o: hello_world.f95
	if [ ${FC} = ifort ]; then \
		cp hello_world.f95 hello_world.f90; \
	fi
	$(FC) -c $(FFLAGS) hello_module.$(ext)
	$(FC) -c $(FFLAGS) hello_world.$(ext)

# Only do the linking
hello_world: hello_world.o
	$(FC) -o hello_world hello_module.o hello_world.o

# Read as: the executable file 'r' is dependent on the source file 'r'.f95 (or .f90) and optional file 'opt'.$(ext).
# This first compiles the module, then the program. Then it links to the executable 'r' and executes it without input. This happens without printing commands and is more easily transferrable for other source files.
r: $(r).$(ext) $(opt).$(ext)
	@ $(FC) -c $(FFLAGS) $(opt).$(ext)
	@ $(FC) -c $(FFLAGS) $(r).$(ext)
	@ $(FC) -o $(r) $(r).o $(opt).o
	@ ./$(r)

# Read as: remove all interim files and hello_world, option -f makes sure nothing is printed when this already happened.
clean:
	@ rm -f *.o *.mod $(r)

# To use when you want to force compilation when `hello_world' already exists:
#.PHONY: hello_world


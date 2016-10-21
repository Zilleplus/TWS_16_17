.PHONY: clean all info

HOME_EXERCISE = 
TARGETS := optim optim_d optim_p optim_foo optim_foo_d foo foo_d
SOURCES := optim.cpp optim_foo.cpp foo.cpp
OBJS    := $(SOURCES:.cpp=.o) $(SOURCES:.cpp=_d.o) $(SOURCES:.cpp=_p.o)


DEBUGFLAGS:= -g 
RELEASEFLAGS:= -O0 -DNDEBUG
PARALLELFLAGS:= -D_GLIBCXX_PARALLEL -fopenmp -pthread -DUSEOMP
CXXFLAGS := -Wall -std=c++14 
LDFLAGS  := 
LIBS =   -lstdc++ 
OPENMPLIB =-L/usr/lib -fopenmp -pthread

EXAMPLE_DEPS = Makefile

all: $(TARGETS)

clean:
	/bin/rm -f $(OBJS) $(TARGETS)

info:
	@echo Compiler:	 CXX	  = $(CXX)
	@echo Compile command: COMPILE.cc  = $(COMPILE.cc)
	@echo Link command:    LINK.cc     = $(LINK.cc)

optim.o: optim.cpp $(EXAMPLE_DEPS)
	@$(CXX) -c $(CXXFLAGS) $(RELEASEFLAGS)  -o optim.o optim.cpp
optim: optim.o
	@$(CXX) -o optim $(LDFLAGS) optim.o $(LIBS)
optim_d.o: optim.cpp $(EXAMPLE_DEPS)
	@$(CXX) -c $(CXXFLAGS) $(DEBUGFLAGS)  -o optim_d.o optim.cpp
optim_d:optim_d.o
	@$(CXX) -o optim_d $(LDFLAGS) optim_d.o $(LIBS)
optim_p.o: optim.cpp $(EXAMPLE_DEPS)
	 @$(CXX) -c $(CXXFLAGS) $(RELEASEFLAGS) $(PARALLELFLAGS) -o optim_p.o optim.cpp
optim_p:optim_p.o
	 @$(CXX) -o optim_p $(LDFLAGS) optim_p.o $(LIBS) $(OPENMPLIB)

optim_foo.o: optim_foo.cpp $(EXAMPLE_DEPS)
	 @$(CXX) -c $(CXXFLAGS) $(RELEASEFLAGS)  -o optim_foo.o optim_foo.cpp
optim_foo: optim_foo.o foo.o
	 @$(CXX) -o optim_foo $(LDFLAGS) optim_foo.o foo.o $(LIBS)
optim_foo_d.o: optim_foo.cpp $(EXAMPLE_DEPS)
	 @$(CXX) -c $(CXXFLAGS) $(DEBUGFLAGS)  -o optim_foo_d.o optim_foo.cpp
optim_foo_d:optim_foo_d.o foo_d.o
	 @$(CXX) -o optim_foo_d $(LDFLAGS) optim_foo_d.o foo_d.o $(LIBS)

foo.o: foo.cpp $(EXAMPLE_DEPS)
	 @$(CXX) -c $(CXXFLAGS) $(RELEASEFLAGS)  -o foo.o foo.cpp
foo_d.o: foo.cpp $(EXAMPLE_DEPS)
	@$(CXX) -c $(CXXFLAGS) $(DEBUGFLAGS)  -o foo_d.o foo.cpp


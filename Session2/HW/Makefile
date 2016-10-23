RELEASEFLAGS:= -O0 -DNDEBUG
PARALLELFLAGS:= -D_GLIBCXX_PARALLEL -fopenmp -pthread -DUSEOMP
CXXFLAGS := -Wall -std=c++14 
LIBS =   -lstdc++ 
OPENMPLIB =-L/usr/lib -fopenmp -pthread

EXAMPLE_DEPS = Makefile

all: part1 part2 part3

clean:
	rm *.out
	rm *.gch

info:
	@echo Compiler:	 CXX	  = $(CXX)
	@echo Compile command: COMPILE.cc  = $(COMPILE.cc)
	@echo Link command:    LINK.cc     = $(LINK.cc)

part1:
	@echo ------part1--------- 
	# sequential
	g++ $(CXXFLAGS) HW_part1.cpp mean_dev.cpp -o HW_part1.out
	g++ $(CXXFLAGS) -O3 -ffast-math HW_part1.cpp mean_dev.cpp -o HW_part1_sec_level3.out
	# parallel
	g++ $(CXXFLAGS) $(PARALLELFLAGS) -O0 HW_part1.cpp mean_dev.cpp -o HW_part1_par.out
	g++ $(CXXFLAGS) $(PARALLELFLAGS) -O3 HW_part1.cpp mean_dev.cpp -o HW_part1_par_l3.out

part2:
	@echo ------part2--------- 
	$(CXX) $(CXXFLAGS)  -O0 mean_dev.cpp HW_part2_main.cpp HW_part2_lib.hpp -o HW_part2_l0.out
	$(CXX) $(CXXFLAGS)  -O3 mean_dev.cpp HW_part2_main.cpp HW_part2_lib.hpp -o HW_part2_l3.out
	$(CXX) $(CXXFLAGS) -D opti -O0 mean_dev.cpp HW_part2_main.cpp HW_part2_lib.hpp -o HW_part2_l0_opti.out
	$(CXX) $(CXXFLAGS) -D opti -O3 mean_dev.cpp HW_part2_main.cpp HW_part2_lib.hpp -o HW_part2_l3_opti.out

part3:
	@echo ------part3--------- 
	# parallel
	g++ $(CXXFLAGS) $(LIBS)  $(PARALLELFLAGS) HW_part3_main.cpp mean_dev.cpp -o HW_part3_par.out
	g++ $(CXXFLAGS) $(LIBS)  $(PARALLELFLAGS) -O3 HW_part3_main.cpp mean_dev.cpp -o HW_part3_par_l3.out
	# serial
	g++ $(CXXFLAGS)   HW_part3_main.cpp mean_dev.cpp -o HW_part3_serial.out
	g++ $(CXXFLAGS) -O3 -ffast-math HW_part3_main.cpp mean_dev.cpp -o HW_part3_serial_level3.out


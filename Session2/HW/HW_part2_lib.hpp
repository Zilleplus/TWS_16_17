#ifndef HW_part2_lib_hpp
#define HW_part2_lib_hpp 

namespace inlineFunctions{
    inline void foo(int& numberToIncrement){
        numberToIncrement++;
    }
}

namespace regularWay{
    void foo(int& numberToIncrement);
}

#endif

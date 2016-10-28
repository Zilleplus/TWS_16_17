program main
    implicit none
    integer, parameter :: wp= selected_real_kind(2)
    real(kind=wp) :: b,c

    b = -577.0
    c = 13.0
    print *, "algorithm1:"
    print *, "x1=", algorithm1_x1(b,c)
    print *, "x2=", algorithm1_x2(b,c) 
    print *, "----"
    print *, "algorithm2:" 
    print *, "x1=", algorithm2_x1(b,c)
    print *, "x2=", algorithm2_x2(b,c)
contains
     ! implementation algorithm1
     function algorithm1_x1(b,c) result(x)
         real(kind=wp) x,b,c
         x = - (b/2_wp) + Dis(b,c)
     end function algorithm1_x1

     function algorithm1_x2(b,c) result(x)
         real(kind=wp) x,b,c
         x = - (b/2_wp) - Dis(b,c)
     end function algorithm1_x2

     ! implementation algorithm2
     function algorithm2_x1(b,c) result(x)
         real(kind=wp) x,b,c
         x = sign((abs(b/2) + Dis(b,c)),-b)
     end function algorithm2_x1
     function algorithm2_x2(b,c) result(x)
         real(kind=wp) x,b,c
         x = c / algorithm2_x1(b,c)
     end function algorithm2_x2

     ! calculate discriminant
     function Dis(b,c) result(D)
         real(kind=wp) D,b,c
         D = sqrt((b/2_wp)**2_wp - c)
     end function Dis
end  program main


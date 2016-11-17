! first do make
! the compile with: gfortran mpfun90.o mpmod90.o mpmodm90.o mpmodx90.o part2.f90
program test
use mpfunmod
use mpmodule
implicit none

integer::i
!integer,parameter :: MPIPL = 55
type (mp_real) x,x_new,diff

CALL MPINIT() !init function !!
! set the precision to 55 digits
CALL MPSETPREC(55) ! this is undocumented as far as i could tell, the subroutine can be found in mpmod90.f line 133 in my version

x = '0.9878'

! do a max of 10 iterations
do i=1,10
    x_new = x + cos(x**14) / (sin(x**14)*14*x**13)
    diff = abs(x-x_new)
    if (diff < 1.0D-55) then
        print *, i
        exit
    end if
    CALL MPWRITE(6,x)
    x=x_new
end do

CALL MPWRITE(6,x)

end 

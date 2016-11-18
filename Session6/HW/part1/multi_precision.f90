! -------------------------------
! WIT Willem Melis
! gecompiler commando:
! gfortran  fmsave.o  FM.o  FMZM90.o mpfun90.o mpmod90.o mpmodm90.o mpmodx90.o multi_precision.f90 
! getest op server tienen
! -------------------------------
! 
! -------------------------------
! Installatie procedure FM:
! -------------------------------
! dowload volgende 4 bestanden FM.f95,fmsave.f95,FMZM90.f95
! Compileer de 4 bestanden: 
!     gfortran fmsave.f95  -c -O3
!     gfortran FM.f95  -c -O3
!     gfortran FMZM90.f95  -c -O3
!     gfortran TestFM.f95  -c -O3
! -------------------------------
! Installatie procedure mpmod90:
! -------------------------------
! download de tar en untar deze
! ga in de folder f90 en compileer het project via het make commando
! volgende bestanden hebben we nodig om dit bestand te compileren: 
! .mod bestanden : mpfunmod.mod,mpmodule.mod
! .o bestanden : mpfun90.o mpmod90.o mpmodm90.o mpmodx90.o
! -------------------------------
! 
program main
    ! import lib from assignment in class
    USE FMZM
    ! import of an other mulit-precision lib
    use mpfunmod
    use mpmodule
    IMPLICIT NONE
    integer i
    TYPE (FM), SAVE :: x,x_new,a,diff
    type (mp_real) x_funmod90,x_new_mpfun90,diff_mpfun90

    ! ----------------------------------------------
    ! package used in class
    print *, "------ USING FMZM ------"

    CALL FM_SET(55)

    x=TO_FM('0.9878')
    a=TO_FM('3')

    print * , 'starting value:'
    call FM_PRINT(x)

    ! do a max of 10 iterations
    do i=1,10
        x_new = x + cos(x**14) / (sin(x**14)*14*x**13)
        diff = abs(x-x_new)
        if (diff < 1.0D-55) then
            print *, i
            exit
        end if 
        call FM_PRINT(x_new)
        x=x_new
    end do

    ! ----------------------------------------------
    ! new package
    
    print *, "------ USING mpfun90 ------"

    CALL MPINIT() !init function !!
    ! set the precision to 55 digits
    CALL MPSETPREC(55) ! this is undocumented as far as i could tell, the subroutine can be found in mpmod90.f line 133 in my version

    x_funmod90 = '0.9878'
    
    ! do a max of 10 iterations
    do i=1,10
        x_new_mpfun90 = x_funmod90 + cos(x_funmod90**14) / (sin(x_funmod90**14)*14*x_funmod90**13)
        diff_mpfun90 = abs(x_funmod90-x_new_mpfun90)
        if (diff_mpfun90 < 1.0D-55) then
            print *, i
            exit
        end if
        CALL MPWRITE(6,x_funmod90)
        x_funmod90=x_new_mpfun90
    end do
    
end program

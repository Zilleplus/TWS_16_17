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
    integer i,j
    TYPE (FM), SAVE :: x,x_new,a,diff,exact_solution_FM,pi_fm,floor_x,floor_exact
    type (mp_real) x_funmod90,x_new_mpfun90,diff_mpfun90,exact_solution_mp,pi_mp,floor_exact_mp,floor_x_mp,x_new_mp
    type (mp_real) zero_mp,one_mp,ten_mp
    ! ----------------------------------------------
    ! package used in class
    print *, "------ USING FMZM ------"

    CALL FM_SET(55)

    x=TO_FM('0.9878')
    a=TO_FM('3')

    ! determine the exact solution
    pi_fm=DACOS(-1.D0)
    exact_solution_FM = exp(log(pi_fm/TO_FM(2))/TO_FM(14))

    print * , 'starting value:'
    call FM_PRINT(x)

    ! do a max of 10 iterations
    do i=1,55
        x_new = x + cos(x**14) / (sin(x**14)*14*x**13)
        diff = abs(x-x_new)
        if (diff < 1.0D-55) then
            print *, i
            exit
        end if 
        print *, "----"
        print *, "iteration",i,"has an x of:"
        call FM_PRINT(x_new)
        print *, "rel error"
        CALL FM_PRINT(abs((x_new/exact_solution_FM) -1))

        ! --- number of digits
        j=0
        do   
            floor_x = abs(floor((x_new)*(TO_FM(10)**TO_FM(j)))) 
            floor_exact = abs(floor((exact_solution_FM)*(TO_FM(10)**TO_FM(j)))) 
            if ((abs(floor_x - floor_exact))  > TO_FM(0) ) then
                exit
            else
                j = j+1
            end if
        end do
        print *, "number of digits correct:",j
        ! --- end number of digits

        x=x_new
    end do


    print *, "the exact solution:"
    call FM_PRINT(exact_solution_FM)

    ! ----------------------------------------------
    ! new package
    
    print *, "------ USING mpfun90 ------"

    CALL MPINIT() !init function !!
    ! set the precision to 55 digits
    CALL MPSETPREC(55) ! this is undocumented as far as i could tell, the subroutine can be found in mpmod90.f line 133 in my version

    x_funmod90 = '0.9878'
    pi_mp=DACOS(-1.D0)
    exact_solution_mp = exp(log(pi_mp/2)/14)
    
    ! do a max of 10 iterations
    print *, "starting iteration"
    do i=1,10
        print *, "---"
        x_new_mpfun90 = x_funmod90 + cos(x_funmod90**14) / (sin(x_funmod90**14)*14*x_funmod90**13)
        diff_mpfun90 = abs(x_funmod90-x_new_mpfun90)
        if (diff_mpfun90 < 1.0D-55) then
            print *, i
            exit
        end if
        print *, "x value of iteration:",j
        CALL MPWRITE(6,x_new_mpfun90)
        print *, "rel error"
        CALL MPWRITE(6,abs((x_new_mpfun90/exact_solution_mp) -1))
        x_funmod90=x_new_mpfun90

        ! --- number of digits
        j=0
        do   
            floor_x_mp = NINT((x_new_mpfun90)*(MPREAL('10')**MPREAL(j)))
            floor_exact_mp = NINT(exact_solution_mp*(MPREAL('10')**MPREAL(j))) 

            if ((abs(floor_x_mp - floor_exact_mp))  > 0 .OR. j>55 ) then
                exit
            else
               j = j+1
            end if
        end do
        print *, "number of digits correct:",j

        ! --- end number of digits

    end do
    print *, "end of mp90, solution="
    CALL MPWRITE(6,x_funmod90)
    print *, "exact solution:"
    CALL MPWRITE(6,exact_solution_mp)
    
end program

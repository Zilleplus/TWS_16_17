! gfortran main.f95 -llapack -lblas
program main
    implicit none

    integer,parameter :: N=4
    integer, parameter :: wp= selected_real_kind(4)
    complex, parameter :: minus_one=(-1)
    integer :: i,j
    complex(kind=wp), dimension(N,N) :: A,D,H
	real :: b,c,pi

    ! define pi
    PI=DACOS(-1.D0)

    ! build A
    do i= 1,N
        do j = 1,N
            call random_number(b)
            call random_number(c)
            A(i,j) = sqrt(-2*log(b))*exp(2*PI*sqrt(minus_one)*c)
        end do
    end do
    call printMatrix(A,N,N)
    D=A

    ! H=A*AT 
    !        TRANSA, TRANSB, M, N,  K,  ALPHA, A, LDA, B, LDB, BETA, C, LDC
    call cgemm('N' ,   'C' , N, N, 0_wp, 0_wp, A, N,   D, N,   0 ,   H, N)

    ! cholesky decomposition
    contains
        subroutine printMatrix(matrix,n,m)
            complex(kind=wp), dimension(N,N) :: matrix
            integer :: n,m,i
            do i=1,n
                print*, matrix(i,1:m)
            end do
        end subroutine

end program

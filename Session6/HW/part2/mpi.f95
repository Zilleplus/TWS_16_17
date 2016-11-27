! WIT Willem Melis 
! 
! compiler commando: mpif90 mpi.f95 -llapack -lblas
! uitvoeren:  mpirun -n 8 ./a.out
! 
! Controle of  het programma wel degelijk in parallel word uitgevoerd:
! 
! 
program main
    USE mpi
    implicit none
    integer :: error,rank,numberOfProcesses,i
    integer :: status_mpi(MPI_status_size)
    logical :: send_recv_buffer,check

    integer,parameter :: N=4
    integer, parameter :: wp= selected_real_kind(4)
    complex :: first_element_of_H,upper_triangular_sum


    call MPI_init(error)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, error)
    call MPI_Comm_size(MPI_COMM_WORLD, numberOfProcesses, error) 

    print *, "executing process:",rank
    ! non root  process
    send_recv_buffer=.true.
    call ginibre(send_recv_buffer,upper_triangular_sum,first_element_of_h)
    !                                              dest  tag 
    call MPI_Send(send_recv_buffer, 1, MPI_LOGICAL        ,   0,  rank,    MPI_COMM_WORLD, error)
    ! after doing all the work print out your name and parameters
    print *, "id=",rank,"the first element of H=",first_element_of_H,"sum of upper triangular of L=",upper_triangular_sum

    if(rank==0) then
        ! if we are in the root process
        print *, "the number of processes :",numberOfProcesses
        check=.true.;
        do i=1,numberOfProcesses-1
            call MPI_Recv(send_recv_buffer,1,MPI_LOGICAL         ,   i,    i,    MPI_COMM_WORLD,   status_mpi , error)
            ! print *,"received", send_recv_buffer
            if(send_recv_buffer .eqv. .false.) then
                check=.false.
            end if
        end do
        if(check) then
            print *, "All checks are OK"
        else
            print *, "not ok, one or make checks are false"
        end if
    end if 
    call MPI_FINALIZE(error)
    
    contains
        function inf_norm_complex(matrix) result(max_val)
            complex(kind=wp), dimension(N,N) :: matrix
            integer :: N_matrix,i,j,INCX
            complex(kind=wp) :: a,b
            real(kind=wp) :: buffer=3
            real(kind=wp) :: max_val

            ! first loop over collum, cuz of cache..
            max_val=0
            do i=1,N
                do j=1,N
                    buffer =  abs(matrix(j,i)) 
                    if(buffer>max_val) then
                        max_val=buffer
                    end if 
                end do
            end do
        end function
        function strict_upper_triangular_sum(matrix) result (abs_sum)
            complex(kind=wp), dimension(N,N) :: matrix
            complex :: abs_sum
            integer :: i
            ! loop over differen collums, again because of cache not over rows...
            ! matrix(1,2) = 1 ! uncomment this to test if this routine fails if there are non zeros...
            abs_sum=0
            do i=2,N
                abs_sum = abs_sum + sum(cabs(matrix(1:i-1,i)))
            end do
        end function
        subroutine ginibre(send_recv_buffer,upper_triangular_sum,first_element_of_h)
            ! all the matrix calculations are done here
            complex :: first_element_of_H,upper_triangular_sum
            complex, parameter :: minus_one=(-1),BETA=0,ALPHA=1
            integer :: i,j
            integer :: INFO,INFO_chol
            complex(kind=wp), dimension(N,N) :: A,H,L,cholesky,H_chol,H_original
	        real :: b,c,pi
            real(kind=wp) :: max_val
            complex, parameter :: c_one=1,c_zero=0
            logical :: send_recv_buffer 

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

            ! H=A*AT 
            !        TRANSA, TRANSB, M, N,  K,    ALPHA,      A, LDA, B, LDB,      BETA,       C, LDC
            call cgemm('N' ,   'C' , N, N , N,    c_one,      A,  N,  A,  N,      c_zero ,  H , N)
            ! H = MATMUL(A,transpose(CONJG(A))) ! this is a slower way to do this, usefull to check if i used the lapack routine correctly

            H_original=H


            ! cholesky decomposition
            !           UPLO N A  LDA    INFO
            call cpotrf('L', N,H,  N,  INFO_chol)

            ! the function ctrmm cant be used as it only allows one of the matrices to be triagular

            ! now check if H=L*L*
            ! get L from H
            do i=1,N
                L(i,1:i) = H(i,1:i)
                if (i<N) then
                    do j=i+1,n
                        L(i,j) = c_zero
                    end do
                end if
            end do
            
            H_chol =MATMUL(L,transpose(CONJG(L))) ! use the easy way, its only a check (discussion forum)
            first_element_of_H = H_original(1,1)
            upper_triangular_sum = strict_upper_triangular_sum(L)
 
            ! print *, inf_norm_complex(H_original-H_chol) 
            ! print *, strict_upper_triangular_sum(L)
        end subroutine
end program main

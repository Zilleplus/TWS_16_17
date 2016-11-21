program main
    USE mpi
    implicit none
    integer :: error,rank,numberOfProcesses,i
    integer :: status_mpi(MPI_status_size)
    logical :: send_recv_buffer

    integer,parameter :: N=4
    integer, parameter :: wp= selected_real_kind(4)


    call MPI_init(error)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, error)
    call MPI_Comm_size(MPI_COMM_WORLD, numberOfProcesses, error) 

    print *, "executing process:",rank
    if(rank==0) then
        ! if we are in the root process
        print *, "the number of processes running:",numberOfProcesses
        do i=1,numberOfProcesses-1
            !                                           source  tag
            call MPI_Recv(send_recv_buffer,1,MPI_LOGICAL         ,   i,    i,    MPI_COMM_WORLD,   status_mpi , error)
            print *,"received", send_recv_buffer
        end do
    else 
        ! non root  process
        send_recv_buffer=.true.
        call ginibre(send_recv_buffer)
        !                                              dest  tag 
        call MPI_Send(send_recv_buffer, 1, MPI_LOGICAL        ,   0,  rank,    MPI_COMM_WORLD, error)
    end if

    call MPI_FINALIZE(error)
    
    contains
        ! subroutine to prints (part) of the matrix
        subroutine printMatrix(matrix,n,m)
            complex(kind=wp), dimension(N,N) :: matrix
            integer :: n,m,i
            do i=1,n
                print*, matrix(i,1:m)
            end do
        end subroutine
        subroutine inf_norm_complex(max_val,matrix)
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
        end subroutine
        subroutine ginibre(send_recv_buffer)
            ! all the matrix calculations are done here
            complex, parameter :: minus_one=(-1),BETA=0,ALPHA=1
            integer :: i,j
            integer :: INFO,INFO_chol
            complex(kind=wp), dimension(N,N) :: A,H,L,cholesky,H_chol,H_original
	        real :: b,c,pi
            real(kind=wp) :: max_val
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
            call cgemm('N' ,   'C' , N, N , N,  complex(1,0), A,  N,  A,  N,   complex(0,0) ,  H , N)
            ! H = MATMUL(A,transpose(CONJG(A))) ! this is a slower way to do this, usefull to check if i used the lapack routine correctly
            ! print *, "H:"
            ! call printMatrix(H,N,N)

            H_original=H


            ! cholesky decomposition
            !           UPLO N A  LDA    INFO
            call cpotrf('L', N,H,  N,  INFO_chol)
            ! print *, INFO_chol
            ! print*, '---'
            ! print*, 'cholesky:'
            ! call printMatrix(H,N,N)

            ! the function ctrmm cant be used as it only allows one of the matrices to be triagular

            ! now check if H=L*L*
            ! get L from H
            do i=1,N
                L(i,1:i) = H(i,1:i)
                if (i<N) then
                    ! L(i,i+1:n) = 0.0d0
                    do j=i+1,n
                        L(i,j) = complex(0, 0)
                    end do
                end if
            end do
            !print*, '---'
            !print*, 'L:'
            !call printMatrix(L,N,N)
            !print*, '---'
            !print*, 'H_col:'
            H_chol =MATMUL(L,transpose(CONJG(L))) ! use the easy way, its only a check (discussion forum)
            !call printMatrix(H_chol,N,N)
            print*, '---'
            !call printMatrix((H_original-H_chol),N,N)
            call inf_norm_complex(max_val,H_original-H_chol) 

            print *, max_val

        end subroutine
end program main

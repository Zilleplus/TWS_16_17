!   Tests of several square matrix-matrix products

program dmr
    use matrixop
    implicit none
    !--------------------------------------------------------------------------
    ! Abstract interfaces
    !
    ! NOTE: this simplifies the timings.
    !--------------------------------------------------------------------------
    abstract interface
        subroutine a_maal_b_interface(a, b, c)
            import dp
            real(kind=dp), dimension(:,:), intent(in)  :: a, b
            real(kind=dp), dimension(:,:), intent(out) :: c
        end subroutine a_maal_b_interface
        subroutine a_maal_b_blocks_interface(a,b,c,blocksize)
            import dp
            real(kind=dp), dimension(:,:), intent(in)  :: a, b
            real(kind=dp), dimension(:,:), intent(out) :: c
            integer, intent(in) :: blocksize
        end subroutine a_maal_b_blocks_interface
    end interface
    
    !--------------------------------------------------------------------------
    ! Main timing program
    !--------------------------------------------------------------------------
    integer :: k, N, blocksize, idx_i, idx_j
    real :: flops
    real :: dummy_i, dummy_j
    integer, dimension(:), allocatable :: seed
    real(kind=dp), dimension(:,:), allocatable :: a, b, c
    real(kind=dp), dimension(:,:), allocatable :: c_matmul
    integer :: unit_number_loops,unit_number_dot_product,unit_number_blas,unit_number_block,unit_number_matmul
    integer :: index_test

    ! open the log files:
    unit_number_loops=7
    unit_number_dot_product=8
    unit_number_blas=9
    unit_number_block=10
    unit_number_matmul=11

    OPEN(UNIT=unit_number_loops,        FILE="data_pureLoops.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_dot_product,  FILE="data_dot_product.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_blas,         FILE="data_blas.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_block,        FILE="data_block.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_matmul,       FILE="data_matmul.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")

    ! Make sure we use the same pseudo-random numbers each time by initializing
    ! the seed to a certain value.
    call random_seed(size=k)
    allocate(seed(k))
    seed = N
    call random_seed(put=seed)

    do index_test=7,8
        N=2**index_test
        blocksize=N/4

        print * ,"starting test with N=",N

        ! Calculate some random indices for the element c_ij that we are going to use
        ! to check if the matrix computation went ok.
        call random_number(dummy_i)
        call random_number(dummy_j)
        idx_i = floor(N*dummy_i) + 1
        idx_j = floor(N*dummy_j) + 1

        ! Allocate the matrices and one reference matrix
        allocate(a(N,N), b(N,N), c(N,N), c_matmul(N,N))
        call random_number(a)
        call random_number(b)
        call a_maal_b_matmul(a,b,c_matmul) ! Reference value

        ! 1. Three nested loops
        call do_timing( "JKI", unit_number_loops, a_maal_b_jki )
        
        ! 4. Two nested loops with dot_product and explicit transpose of matrix A
        call do_timing( "IJ TP DOT_PRODUCT", unit_number_dot_product, a_maal_b_transp_ij_dot_product )
        
        ! 5. Using BLAS
        call do_timing( "BLAS DGEMM", unit_number_blas, a_maal_b_blas )
        
        ! 6. In blocks
        call do_timing( "IN BLOCKS", unit_number_block, method_blocks=a_maal_b_blocks )
        
        ! 7. Intrinsic matmul function
        call do_timing( "MATMUL", unit_number_matmul, a_maal_b_matmul )
        deallocate(a, b, c, c_matmul)
    end do
    
    ! close the log files
    CLOSE(UNIT=unit_number_loops)
    CLOSE(UNIT=unit_number_dot_product)
    CLOSE(UNIT=unit_number_blas)
    CLOSE(UNIT=unit_number_block)
    CLOSE(UNIT=unit_number_matmul)
contains
    subroutine do_timing( name,unit_number, method, method_blocks )
        character(len=*), intent(in) :: name
        procedure(a_maal_b_interface), optional :: method
        procedure(a_maal_b_blocks_interface), optional :: method_blocks
        real(kind=dp) :: mynorm
        integer,parameter :: number_of_simulations=10
        real :: t1, t2, delta_t(number_of_simulations)
        integer , intent(in):: unit_number
        integer i
        do i=1,number_of_simulations
            ! Do the timing
            if( present(method) ) then
                call cpu_time(t1)
                call method( a, b, c )
                call cpu_time(t2)
            else
                call cpu_time(t1)
                call method_blocks( a, b, c, blocksize)
                call cpu_time(t2)
            end if
            delta_t(i) = t2-t1
        end do

	    ! print "(A18, F7.2, A, ES9.2, A, ES9.2)", name // ": ", t2-t1, " sec, test = ", c(idx_i, idx_j), ", relative error = ", mynorm
	    write(unit_number,"(I6, A, E9.3,  A, E9.3, A, E9.3  )")&
            N, " ", &
            3*(N**3)/MINVAL(delta_t), " " , & 
            3*(N**3)/(SUM(delta_t)/number_of_simulations) , " " , &
            3*(N**3)/MAXVAL(delta_t)
    end subroutine do_timing
end program dmr

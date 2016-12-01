!   Implementation of several square matrix-matrix products

module matrixop
    implicit none
    integer, parameter :: dp = selected_real_kind(15,307)
contains
    !--------------------------------------------------------------------------
    ! 1. Three nested loops
    !
    ! NOTE: use the following convention for the indices
    !       i = row index of A
    !       j = column index of B
    !       k = column index of A
    !--------------------------------------------------------------------------
    subroutine a_maal_b_ijk(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do i=1,size(a,1)
            do j=1,size(b,2)
                do k=1,size(a,2)
                    c(i,j) = c(i,j) + a(i,k)*b(k,j)
                end do
            end do
        end do
    end subroutine a_maal_b_ijk

    subroutine a_maal_b_ikj(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do i=1,size(a,1)
            do k=1,size(a,2)
                do j=1,size(b,2)
                    c(i,j) = c(i,j) + a(i,k)*b(k,j)
                end do
            end do
        end do
    end subroutine a_maal_b_ikj

    subroutine a_maal_b_jik(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do j=1,size(b,2)
            do i=1,size(a,1)
                do k=1,size(a,2)
                    c(i,j) = c(i,j) + a(i,k)*b(k,j)
                end do
            end do
        end do
    end subroutine a_maal_b_jik

    subroutine a_maal_b_jki(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do j=1,size(b,2)
            do k=1,size(a,2)
                do i=1,size(a,1)
                    c(i,j) = c(i,j) + a(i,k)*b(k,j)
                end do
            end do
        end do
    end subroutine a_maal_b_jki

    subroutine a_maal_b_kij(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do k=1,size(a,2)
            do i=1,size(a,1)
                do j=1,size(b,2)
                    c(i,j) = c(i,j) + a(i,k)*b(k,j)
                end do
            end do
        end do
    end subroutine a_maal_b_kij
    
    subroutine a_maal_b_kji(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do k=1,size(a,2)
            do j=1,size(b,2)
                do i=1,size(a,1)
                    c(i,j) = c(i,j) + a(i,k)*b(k,j)
                end do
            end do
        end do
    end subroutine a_maal_b_kji
    !--------------------------------------------------------------------------
    ! 2. Two nested loops with vector operations
    !--------------------------------------------------------------------------
    subroutine a_maal_b_ikj_vect(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do i=1,size(a,1)
            do k=1,size(a,2)
                c(i,:) = c(i,:) + a(i,k)*b(k,:)
            end do
        end do
    end subroutine a_maal_b_ikj_vect

    subroutine a_maal_b_jki_vect(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do j=1,size(b,2)
            do k=1,size(a,2)
                    c(:,j) = c(:,j) + a(:,k)*b(k,j)
            end do
        end do
    end subroutine a_maal_b_jki_vect

    subroutine a_maal_b_kij_vect(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do k=1,size(a,2)
            do i=1,size(a,1)
                c(i,:) = c(i,:) + a(i,k)*b(k,:)
            end do
        end do
    end subroutine a_maal_b_kij_vect

    subroutine a_maal_b_kji_vect(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do k=1,size(a,2)
            do j=1,size(b,2)
                    c(:,j) = c(:,j) + a(:,k)*b(k,j)
            end do
        end do
    end subroutine a_maal_b_kji_vect
    !--------------------------------------------------------------------------
    ! 3. Two nested loops with dot_product
    !--------------------------------------------------------------------------
    subroutine a_maal_b_ij_dot_product(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do i=1,size(a,1)
            do j=1,size(b,2)
            c(i,j) = dot_product(a(i,:),b(:,j))
            end do
        end do
    end subroutine a_maal_b_ij_dot_product

    subroutine a_maal_b_ji_dot_product(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        integer :: i,j,k
        c = 0.0_dp
        do j=1,size(b,2)
            do i=1,size(a,1)
            c(i,j) = dot_product(a(i,:),b(:,j))
            end do
        end do
    end subroutine a_maal_b_ji_dot_product
    !--------------------------------------------------------------------------
    ! 4. Two nested loops with dot_product and explicit transpose of matrix A
    !--------------------------------------------------------------------------
    subroutine a_maal_b_transp_ij_dot_product(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        real(kind=dp), dimension(size(a,2),size(a,1))  :: a_transpose
        integer :: i,j,k
        c = 0.0_dp
        a_transpose= transpose(a)
        do i=1,size(a,1)
            do j=1,size(b,2)
            c(i,j) = dot_product(a(i,:),b(:,j))
            end do
        end do
    end subroutine a_maal_b_transp_ij_dot_product

    subroutine a_maal_b_transp_ji_dot_product(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        real(kind=dp), dimension(size(a,2),size(a,1))  :: a_transpose
        integer :: i,j,k
        c = 0.0_dp
        a_transpose= transpose(a)
        do j=1,size(b,2)
            do i=1,size(a,1)
            c(i,j) = dot_product(a(i,:),b(:,j))
            end do
        end do
    end subroutine a_maal_b_transp_ji_dot_product
    !--------------------------------------------------------------------------
    ! 5. Using BLAS : Add library in linking phase
    !--------------------------------------------------------------------------
    subroutine a_maal_b_blas(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        c = 0.0_dp
        !           TRANSA, TRANSB,     M,         N,          K,     ALPHA,    A,    LDA,    B,     LDB,    BETA,   C,    LDC
        call DGEMM ( 'N',    'N' , size(a,1), size(b,2) , size(a,1),    1._dp,  a, size(a,1), b, size(b,1),  0._dp , c, size(a,1))

    end subroutine a_maal_b_blas
   
    !--------------------------------------------------------------------------
    ! 6. In blocks
    !--------------------------------------------------------------------------
    subroutine a_maal_b_blocks(a, b, c, blocksize)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        !real(kind=dp), dimension(blocksize,blocksize) :: buffer

        integer, intent(in) :: blocksize
        integer i,j,k
        c = 0.0_dp 
        do i = 1,size(A,1),blocksize
            do j = 1,size(B,2),blocksize      
                do k = 1,size(A,2),blocksize
                     c(i:i+blocksize-1,j:j+blocksize-1)= & 
                         c(i:i+blocksize-1,j:j+blocksize-1)&
                         +matmul(A(i:i+blocksize-1,k:k+blocksize-1),B(k:k+blocksize-1,j:j+blocksize-1))
               end do
            end do
        end do

    
    end subroutine a_maal_b_blocks
    !--------------------------------------------------------------------------
    ! 7. Intrinsic matmul function
    !--------------------------------------------------------------------------
    subroutine a_maal_b_matmul(a, b, c)
        real(kind=dp), dimension(:,:), intent(in)  :: a, b
        real(kind=dp), dimension(:,:), intent(out) :: c
        c = matmul( a, b ) ! Already completed
    end subroutine a_maal_b_matmul

end module matrixop

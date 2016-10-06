program main
    ! --- PART3:GRAY CODE ---
    ! integer
    integer x
    ! vector 
    INTEGER, DIMENSION(0:4) :: vector =(/0, 1, 2, 3, 4/) 
    INTEGER, DIMENSION(0:4) :: vector_results
    ! matrix 
    INTEGER, DIMENSION(5,5) :: matrix, result_matrix
    ! variables use to loop
    INTEGER i,k,l
    ! --- END PART3: GRAY CODE ---



    ! --- PART3:GRAY CODE ---

    ! fill the matrix
    do k = 1 , 4
        do l = 1 , 5
            matrix(k,l) = ((k-1)*5+l)-1
        end do
    end do

    ! call function with integer
    x = toGray(5)
    ! call function with vector
    vector_results = toGray(vector)
    ! call function with matrix
    result_matrix = toGray(matrix)
     
    ! print out the results...
    print *, "--- with integer --"
    print *, x 
    print *, "--- with vector --"
    print *, "---> input"
    print *, vector
    print *, "---> output"
    print *, vector_results
    print *, "--- with matrix --"
    print *, "---> input"
    do i=1 , 4
        print *,matrix(i,:)
    end do
    print *, "---> output"
    do i=1 , 4
        print *,result_matrix(i,:)
    end do
    ! --- END PART3: GRAY CODE ---
contains
    elemental function toGray(x) result(q)
        integer, intent(in) :: x
        integer :: q, buffer
        buffer = RSHIFT(x,1) 
        buffer = IEOR(x, buffer) 
        q = buffer
    end function


end program

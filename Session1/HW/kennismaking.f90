program main
    !
    ! 
    ! --- PART1:MATRIX---
    real , dimension (4,4) :: something_special= reshape ( (/ & 
    1.0000e+00 ,1.2500e-01 ,1.8750e-01 ,8.1250e-01 , &
    3.1250e-01 ,6.8750e-01 ,6.2500e-01 ,5.0000e-01 , &
    5.6250e-01 ,4.3750e-01 ,3.7500e-01 ,7.5000e-01 , &
    2.5000e-01 ,8.7500e-01 ,9.3750e-01 ,6.2500e-02   &
    /) , (/ 4 ,4 /) , order =(/2 ,1/) )

    real , dimension ( -3:3 ,0:2) :: different_special = reshape ( (/ &
    9.0909e-01 ,1.9091e+00 ,8.1818e-01 ,1.4545e+00 ,4.5455e-01 , &
    1.2727e+00 ,1.8182e-01 ,2.7273e-01 ,3.6364e-01 ,6.3636e-01 , &
    1.0000e+00 ,1.3636e+00 ,1.6364e+00 ,1.7273e+00 ,1.8182e+00 , &
    7.2727e-01 ,1.5455e+00 ,5.4545e-01 ,1.1818e+00 ,9.0909e-02 , &
    1.0909e+00 /) , (/7 ,3/) , order =(/1 ,2/) )
    ! --- END PART1:MATRIX---

    ! --- PART2:PRINT
    ! --- END PART2:PRINT

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

    ! --- PART1:MATRIX---
    print *, something_special
    call matrix_stats(something_special)
    call matrix_stats(different_special)

    ! --- PART1:MATRIX---

    ! --- PART2:print ---
    call printText('r')
    call printText('l')
    call printText('c') 
    call printText('i')
    ! --- PART2:print ---

    
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
    subroutine matrix_stats(matrix)
        real :: matrix(:,:)
        integer, dimension(2) :: shape_array

        print *, "matrix stats" 

        ! De afmetingen (aantal rijen, aantal kolommen) en het aantal elementen.
        shape_array  = shape(matrix)
        print*,"number of rows:", shape_array(1) 
        print*,"number of collums:", shape_array(2) 
        ! De kleinste en grootste waarde in de hele matrix.
        print *, "the largest value is:",MAXVAL(matrix)
        print *, "the smallest value is:",MINVAL(matrix)
        ! De bereiken van de indices voor zowel de rijen als de kolommen. 
        ! -- Dit doe je zowel in de subroutine als in het hoofdprogramma: bespreek het verschil.
        print *, "TODO!!!!" 
        ! De som van elke rij en de som van elke kolom.
        print *, "sum of each row:"
        do i=1,shape_array(1)
            print *, SUM(matrix(i,:))
        end do

        print *, "sum of each collum"
        do i=1,shape_array(2)
            print *, SUM(matrix(:,i))
        end do
        print *, "------------"
    end subroutine

    subroutine printText(alignment)
        character alignment
        character, dimension(40) :: text 
        text(1:20) = repeat('*',20)
        text(21:40) = repeat('x',20)

        select case(alignment)
            case ('l')
                print *, text
            case ('r')
                print *, repeat(' ',40),text
            case ('c')
                print *, repeat(' ',20),text
            case ('i')
                print *, repeat(' ',20),text(21:40),text(1:20)
        end select
    end subroutine

    elemental function toGray(x) result(q)
        integer, intent(in) :: x
        integer :: q, buffer
        buffer = RSHIFT(x,1) 
        buffer = IEOR(x, buffer) 
        q = buffer
    end function
end program

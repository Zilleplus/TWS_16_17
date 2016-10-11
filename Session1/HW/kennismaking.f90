! Willem Melis
! gecompileerd met GNU Fortran (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609
! compiler-commando:  gfortran kennismaking.f90 -o Huistaak1
! 
! De opgave bestaat uit 3 delen elk deel wordt appart besproken om het overzichtelijk te houden
! 
! --------------------------------------------------------------------------------------------
! uitvoer van deel1:
!  --> something special
!                                   dim1        dim2
!  lower bound index array           1           1
!  upper bound index array           4           4
!  BEGIN matrix_stat:....................
!  number of rows:           4
!  number of collums:           4
!  the largest value is:   1.00000000
!  the smallest value is:   6.25000000E-02
!                                   dim1        dim2
!  lower bound index array           1           1
!  upper bound index array           4           4
!  sum of each row:
!    2.12500000
!    2.12500000
!    2.12500000
!    2.12500000
!  sum of each collum
!    2.12500000
!    2.12500000
!    2.12500000
!    2.12500000
!  END matrix_stat:....................
!  --> different special
!                                   dim1        dim2
!  lower bound index array          -3           0
!  upper bound index array           3           2
!  BEGIN matrix_stat:....................
!  number of rows:           7
!  number of collums:           3
!  the largest value is:   1.90910006
!  the smallest value is:   9.09089968E-02
!                                   dim1        dim2
!  lower bound index array           1           1
!  upper bound index array           7           3
!  sum of each row:
!    3.00002003
!    3.00001001
!    3.00004005
!    2.99994993
!    2.99994993
!    3.00000906
!    3.00002003
!  sum of each collum
!    6.99993944
!    7.00003004
!    7.00002909
!  END matrix_stat:....................
! 
! De eerste array heeft de vorm 4*4
! De indexen lopen van 1 tot en met 4, en hierdoor is geen verschil te merken als
! men deze opvraagt binnen of buiten een subroutine.
! De twee array heeft indexen lopen van -3 tot en met 3 in de eerste dimensie.
! Als de array wordt doorgegeven aan dee subroutine hebben we plots een index van 1 tot en met 7.
! Een array is nu eenmaal slechts een start pointer en een lengte. 
! --------------------------------------------------------------------------------------------
! uitvoer van deel2:
! 12345678901234567890123456789012345678901234567890123456789012345678901234567890
!                                         ********************xxxxxxxxxxxxxxxxxxxx
! ********************xxxxxxxxxxxxxxxxxxxx
!                     ********************xxxxxxxxxxxxxxxxxxxx
!                     xxxxxxxxxxxxxxxxxxxx********************
! --------------------------------------------------------------------------------------------
! uitvoer van deel3:
! --- with integer --
!           7
! --- with vector --
! ---> input
!           0           1           2           3           4
! ---> output
!           0           1           3           2           6
! --- with matrix --
! ---> input
!           0           1           2           3           4
!           5           6           7           8           9
!          10          11          12          13          14
!          15          16          17          18          19
! ---> output
!           0           1           3           2           6
!           7           5           4          12          13
!          15          14          10          11           9
!           8          24          25          27          26
! 
! Gray code verschilt van binairy notatie omdat het slechts een bit
! wijzigt bij het overgaan naar een volgend getal.
! De binaire notatie geeft een overhangen met twee bits die veranderen bv. 1->2
!     0001 -> 0010
!       ||
!       ||-> bit gaat van 1 naar 0
!       |
!       |-> bit gaat van 0 naar 1
! In gray code is dit niet zo van 1 naar 2 is als volgt
!     0001 -> 0011
!       |
!       |-> alleen deze bit verandert, van 0 naar 1

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
    character, dimension(80) :: first_line
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
    print *, repeat('#',20)," PART1:MATRIX ",repeat('#',20)
    print *, "--> something special"
    print *, "                       ",repeat(' ',10),"dim1",repeat(' ',8),"dim2"
    print *, "lower bound index array",lbound(something_special)
    print *, "upper bound index array",ubound(something_special)
    call matrix_stats(something_special)
    print *, "--> different special"
    print *, "                       ",repeat(' ',10),"dim1",repeat(' ',8),"dim2"
    print *, "lower bound index array",lbound(different_special)
    print *, "upper bound index array",ubound(different_special)
    call matrix_stats(different_special)
    print *, repeat('#',20)," END PART1:MATRIX ",repeat('#',20)
    ! --- END PART1:MATRIX---

    ! --- PART2:print ---
    print *, repeat('#',20)," PART2 ",repeat('#',20)
    do i=0,7
        do j=1,9
            number=i*10+j
            Write( first_line(number), '(i0)' ) j
        end do
        Write( first_line(i*10+10), '(i0)' ) 0
    end do
    print *, first_line
    call printText('r')
    call printText('l')
    call printText('c') 
    call printText('i')
    print *, repeat('#',20)," END PART2 ",repeat('#',20)
    ! --- PART2:print ---

    
    ! --- PART3:GRAY CODE ---
    print *, repeat('#',20)," PART3 ",repeat('#',20)
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
    print *, repeat('#',20)," PART3 ",repeat('#',20)
    ! --- END PART3: GRAY CODE ---
contains
    subroutine matrix_stats(matrix)
        real :: matrix(:,:)
        integer, dimension(2) :: shape_array
        print *, "BEGIN matrix_stat:", repeat('.',20)

        ! De afmetingen (aantal rijen, aantal kolommen) en het aantal elementen.
        shape_array  = shape(matrix)
        print*,"number of rows:", shape_array(1) 
        print*,"number of collums:", shape_array(2) 
        ! De kleinste en grootste waarde in de hele matrix.
        print *, "the largest value is:",MAXVAL(matrix)
        print *, "the smallest value is:",MINVAL(matrix)
        ! De bereiken van de indices voor zowel de rijen als de kolommen. 
        ! -- Dit doe je zowel in de subroutine als in het hoofdprogramma: bespreek het verschil.
        print *, "                       ",repeat(' ',10),"dim1",repeat(' ',8),"dim2"
        print *, "lower bound index array",lbound(matrix)
        print *, "upper bound index array",ubound(matrix)
        ! De som van elke rij en de som van elke kolom.
        print *, "sum of each row:"
        do i=1,shape_array(1)
            print *, SUM(matrix(i,:))
        end do

        print *, "sum of each collum"
        do i=1,shape_array(2)
            print *, SUM(matrix(:,i))
        end do
        print *, "END matrix_stat:", repeat('.',20)
    end subroutine

    subroutine printText(alignment)
        character alignment
        ! create a unique string
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

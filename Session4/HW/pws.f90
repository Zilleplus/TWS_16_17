! Willem Melis
! WIT
! compiler-commando:  gfortran pws.f90
! gecompileerd met GNU Fortran (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609
! gecompileerd op server vilvoorde
!
! Deze opdracht was ongeveer 2 uur werk.
! De syntax van where is niet eenvoudig en het woord "target" was ik 
! vergeten. De error gaf nochtans een goede tip, maar ik deed er toch lang over..
!
! Het gebruik van pointers kan geheugen besparen.
! zonder pointers
! --> total heap usage: 32 allocs, 32 frees, 20,751 bytes allocated
! met pointers:
! --> total heap usage: 31 allocs, 31 frees, 20,727 bytes allocated
! De pointer zal de submatrix dus niet overkopieeren en appart bewaren.
! Dit verbruikt duidelijk minder geheugen.
!
! De play_with_array subroutine  gaf altijd een array met alles op true terug als de random array wordt gebruikt.
! Dit is niet merkwaardig aangezien de situatie waarbij w false wordt vrij zeldzaam is.
! vandaar een kollom op nul wordt gezet... op deze manier zie we toch een true tevoorschijn komen.
!
! Over de where syntax valt niet veel te zeggen. Het is duidelijk korter
! maar of het leesbaarder is, dat is een andere vraag.
!
! OUTPUT
! random array with value between 0 and 1
!   0.00000000      0.217951715      0.855692387      0.605693221      0.659047484      0.769614279      0.552902997
!   0.00000000      0.133160353      0.401286900      0.719047904      0.554005086      0.339322507      0.997919261
!   0.00000000      0.900524497      0.206874311      0.897334576      0.977760077      0.115818799      0.990394711
!   0.00000000      0.386765957      0.968539417      0.658229113      0.901923299      0.614369154      0.746309638
!   0.00000000      0.445482254      0.598399520      0.150716782      0.657924652      0.820617139      0.953759015
!   0.00000000      0.661932170      0.672980726      0.612314880      0.728858471      0.947094619       9.32746530E-02
!   0.00000000       1.61082745E-02  0.456882298      0.978660226      0.402455211      0.731128633      0.734023631
!   0.00000000      0.650854826      0.330015123      0.999142230      0.928627610      0.497603893      0.751761615
!   0.00000000      0.646408796      0.100382924      0.256797969      0.147835135      0.374801695      0.946848452
!   0.00000000      0.322987258      0.755453289      0.550865352      0.674529254      0.421505809      0.706176341
! calling play_with_array
! resulting array x after play_with_array:
!   0.00000000      0.217951715      0.855692387      0.449999988      0.659047484      0.769614279      0.449999988
!   0.00000000      0.133160353      0.449999988      0.719047904      0.449999988      0.449999988      0.997919261
!   0.00000000      0.900524497      0.206874311      0.897334576      0.977760077      0.115818799      0.990394711
!   0.00000000      0.449999988      0.968539417      0.658229113      0.901923299      0.449999988      0.746309638
!   0.00000000      0.449999988      0.449999988      0.150716782      0.657924652      0.820617139      0.953759015
!   0.00000000      0.661932170      0.672980726      0.449999988      0.728858471      0.947094619       9.32746530E-02
!   0.00000000       1.61082745E-02  0.449999988      0.978660226      0.449999988      0.731128633      0.734023631
!   0.00000000      0.650854826      0.449999988      0.999142230      0.928627610      0.449999988      0.751761615
!   0.00000000      0.449999988      0.100382924      0.256797969      0.147835135      0.449999988      0.946848452
!   0.00000000      0.449999988      0.755453289      0.449999988      0.674529254      0.449999988      0.706176341
! array v:
!           2          37          37          37          37          37          37
! array w:
! F T T T T T T
! calling without pointers
!  0.946848452

program main
    implicit none
    real, dimension(10,7) :: x
    integer :: v(7)
    logical:: w(7)
    real, dimension(:,:), pointer :: d
    character :: arg
    logical usePointers

    ! read out the command line argument if there is one
    usePointers=.false.
    if(command_argument_count()>0) then
        call get_command_argument(1, arg)
        if(arg=='p') then
            usePointers=.true.
        end if
    end if

    ! fill the array x with random values between 0 and 1
    CALL RANDOM_NUMBER(x)

    ! !!!!!! zet deze lijn aan om te testen op play with array wel werkt !!
    x(:,1) = (/ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0/)

    print *, "random array with value between 0 and 1"
    call printArrayX()

    print *, "calling play_with_array"
    call play_with_array(x,v,w)

    print *, "resulting array x after play_with_array:"
    call printArrayX()

    print *, "array v:"
    print *,v
    print *, "array w:"
    print *,w

    if(usePointers) then
        print *, "calling pointers are awesome"
        call pointers_are_awesome(x)
    else
        print *, "calling without pointers"
        call without_pointers(x)
    end if

    contains
    subroutine printArrayX()
        integer :: i
        i=1
        do i=1,10
            print * , x(i,:)
        end do
    end subroutine printArrayX
    subroutine play_with_array(x,v,w)
        real,dimension(:,:) :: x
        integer :: v(:)
        logical :: w(:)

        ! replace all elements in range [0.3, 0.65) with 0.45
        where(x > 0.3 .and. x<0.65)
            x = 0.45
        endwhere

        ! fill array v
         where(maxval(x,1) > 0.75)
            v = 37
            w=.true.
         endwhere
    end  subroutine
    subroutine without_pointers(x)
        real,dimension(:,:) :: x

        real, allocatable :: d(:,:)

        d = x(8:9,5:7)

        ! find the largest element in the submatrix and print it
        print *, maxval(maxval(d,2),1)
    end subroutine without_pointers
    subroutine pointers_are_awesome(x)
        real,target,dimension(:,:) :: x

        real, dimension(:,:), pointer :: d

        d => x(8:9,5:7) 

        ! find the largest element in the submatrix and print it
        print *, maxval(maxval(d,2),1)
    end subroutine pointers_are_awesome
end program


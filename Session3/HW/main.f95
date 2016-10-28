program main
    call print_type_info_single
    call print_type_info_double
    contains
        subroutine print_type_info_single
            integer, parameter :: wp_single= selected_real_kind(4)
            real(kind=wp_single) x
            x=0 ! assign value to avoid annoying warning from compiler
            print *, "-----------------------------------------------------------"
            print *, "----- SINGLE precision -------"
            print *, "------------------------------"
            print '(A,I10)', " mantissa length: ",DIGITS(x)
            print '(A,E8.1)'," epsilon:                ",EPSILON(x)
            print '(A,E8.1)', " max number:             ",HUGE(x)
            print '(A,I10)', " max exponent:     ",MAXEXPONENT(x)
            print *, "-----------------------------------------------------<"
        end subroutine print_type_info_single
        subroutine print_type_info_double
            integer, parameter :: wp_double= selected_real_kind(8)
            real(kind=wp_double) x
            x=0 ! assign value to avoid annoying warning from compiler
            print *, "----- DOUBLE precision -------"
            print *, "------------------------------"
            print '(A,I10)', " mantissa length: ",DIGITS(x)
            print '(A,E8.1)'," epsilon:                ",EPSILON(x)
            print '(A,E8.1)', " max number:             ",HUGE(x)
            print '(A,I10)', " max exponent:      ",MAXEXPONENT(x)
            print *, "-----------------------------------------------------------"
        end subroutine print_type_info_double
end  program main

! Numeric inquiry functions
! DIGITS (X) Number of significant digits of the model
! EPSILON (X) Number that is almost negligible compared to one
! HUGE (X) Largest number of the model
! MAXEXPONENT (X) Maximum exponent of the model
! MINEXPONENT (X) Minimum exponent of the model
! PRECISION (X) Decimal precision
! RADIX (X) Base of the model
! RANGE (X) Decimal exponent range
! TINY (X) Smallest positive number of the model
!
! Floating-point manipulation functions
! EXPONENT (X) Exponent part of a model number
! FRACTION (X) Fractional part of a number
! NEAREST (X, S) Nearest different processor number in given
! direction
! RRSPACING (X) Reciprocal of the relative spacing of model
! numbers near given number
! SCALE (X, I) Multiply a real by its base to an integer power
! SET EXPONENT (X, I) Set exponent part of a number
! SPACING (X) Absolute spacing of model numbers near given
! number


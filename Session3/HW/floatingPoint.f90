! OUTPUT GFORTRAN
! THE ROUNDING MODE IS NEAREST
! -----------------------------------------------------------
! ----- SINGLE precision kind=4 -------
! ------------------------------
! mantissa length:               24
! max exponent:                  128
! min exponent:                 -125
! Decimal precision:             6
! Decimal exponent range:        37
! epsilon:                       0.1E-06
! -----------------------------------------------------<
! ----- DOUBLE precision kind=8 -------
! ------------------------------
! mantissa length:               53
! max exponent:                  1024
! min exponent:                 -1021
! Decimal precision:             15
! Decimal exponent range:        307
! epsilon:                       0.2E-15
! -----------------------------------------------------------
!----- higher precision kind=10 -------
! ------------------------------
! mantissa length:               64
! max exponent:                 16384
! min exponent:                -16381
! Decimal precision:             18
! Decimal exponent range:       4931
! epsilon:                       0.1E-18
! -----------------------------------------------------------
! 
!
! Round to Nearest – rounds to the nearest value; if the number falls midway 
! it is rounded to the nearest value with an even (zero) least significant bit,
!
! ## bespreking SINGLE PRECISION ##
!
! De matissa is 23 lang (de eerste nul wordt niet bewaard) daarnaast hebben we nog 1 tekenbit, de eponent is dus 32-23-1=8 lang.
! Aangezien de exponent een tekenbit bevat hebben we dus een bovengrens van 2^7=128. 
! Een exponent van 0xFF is de inf waarde, en dus het max getal dat je kunt voorstellen is 127 en niet 128.
! De ondergrens van de min exponent is -125 de resterende range is gebruikt
! voor het voostellen van speciale tekens!.
! De machine precisie is ongeveer 0.1e-6, we weten dat de mantissa 23 
! bits lang is. Daarnaast weten we dat de afronding NEAREST is.
!
! Het getal 1 wordt voorgesteld als: 0,100.. veel nullen ...0 * 2^1
! Dit is dus een enkele 1 en dan 22 nullen.
! De 23ste digit heeft dus het gewicht (2^-23)*2^1 . Als we de helft van (2^-23)*2^1 bij 1 
! bijtellen zal nearest round afronden naar het volgende getal, aangezien de waarde van de 
! minst significate bit van 1 oneven is. De machine precisie (epsilon) is 2^-23~=0.1e-6
! Als de machine precisie 0.1e-6 is dan is de decimale precisie natuurlijk 6.
! 
! 2^127~=3,4e38 , we weten dat de matissa altijd een getal is die begint 1 cijfer na de komma.
! Het max getal die we dus kunnen gebreiken is 0.111..111*2^128 dit is dus ongeveer 2^{-1}*2^{127} = 10^37.
! 
! ## besprekeing DOUBLE PRECISION ##
! 
! De mantissa is 53 lang (de eerste nul wordt niet bewaard) daarnaast heben we nog 1 tekenbit en de exponent is dus 64-53-1=11 bits lang .
! 2^10=1024 de exponent kan van 1024 tot -1023, het resterende bereik wordt gebruikt voor speciale tekens.
! 
! Dezelfde redenering als voordien voor de machine precisie: (2^-53)*2^1 = gewicht laatste digit van mantisse van float(1)
! Dus helft van (2^-53)*2^1 = 2^-53 ~= 9.0072e+15
!
! ## besprekeing EXTENDED PRECISION (gfortran) ##
!
! Dit is het extended type vanop de intel processoren, 10bytes lang!
! De matissa is 64bits groot, daarnaast heben we opnieuw een tekenbit dus
! de lengte van de exponent is 80-64-1=15.
! 2^14=16384, opnieuw ontbreekt er een stuk van de range aan de negatieve kant.
! Zoals bij de andere formaten is dit voor speciale teken.
!
! De machine precisie is 2^64 = 0.1e-18  
! 
! 
!
program main
    USE, INTRINSIC :: IEEE_ARITHMETIC; USE, INTRINSIC :: IEEE_FEATURES 
    call print_all
    contains
        subroutine print_all
            TYPE(IEEE_ROUND_TYPE) ROUND_VALUE
            call IEEE_GET_ROUNDING_MODE(ROUND_VALUE)

            IF (ROUND_VALUE == IEEE_NEAREST) THEN
                  PRINT *, "THE ROUNDING MODE IS NEAREST"
            ENDIF

            call print_type_info_single
            call print_type_info_double
            call print_type_info_higher 
        end subroutine print_ALL
        subroutine print_type_info_single
            integer, parameter :: wp_single= selected_real_kind(4)
            real(kind=wp_single) x
            x=0 ! assign value to avoid annoying warning from compiler
            print *, "-----------------------------------------------------------"
            print *, "----- SINGLE precision kind=4 -------"
            print *, "------------------------------"
            print '(A,I10)', " mantissa length:       ",DIGITS(x)
            print '(A,I10)', " max exponent:           ",MAXEXPONENT(x)
            print '(A,I10)', " min exponent:           ",MINEXPONENT(x)
            
            print '(A,I10)', " Decimal precision:    ", PRECISION(x)
            print '(A,I10)', " Decimal exponent range:",RANGE(x)

            print '(A,E8.1)'," epsilon:                      ",EPSILON(x)
            print *, "-----------------------------------------------------<"
        end subroutine print_type_info_single
        subroutine print_type_info_double
            integer, parameter :: wp_double= selected_real_kind(8)
            real(kind=wp_double) x
            x=0 ! assign value to avoid annoying warning from compiler
            print *, "----- DOUBLE precision kind=8 -------"
            print *, "------------------------------"
            print '(A,I10)', " mantissa length:       ",DIGITS(x)
            print '(A,I10)', " max exponent:            ",MAXEXPONENT(x)
            print '(A,I10)', " min exponent:            ",MINEXPONENT(x)
            
            print '(A,I10)', " Decimal precision:     ", PRECISION(x)
            print '(A,I10)', " Decimal exponent range: ",RANGE(x)

            print '(A,E8.1)'," epsilon:                      ",EPSILON(x)
            print *, "-----------------------------------------------------------"
        end subroutine print_type_info_double
        subroutine print_type_info_higher
            integer, parameter :: hp = max(4,selected_real_kind(16,308))
            real(kind=hp) x
            x=0 ! assign value to avoid annoying warning from compiler
            print '(A,I2,A)',"----- higher precision kind=",hp, " -------"
            print *, "------------------------------"
            print '(A,I10)', " mantissa length:       ",DIGITS(x)
            print '(A,I10)', " max exponent:            ",MAXEXPONENT(x)
            print '(A,I10)', " min exponent:            ",MINEXPONENT(x)
            
            print '(A,I10)', " Decimal precision:     ", PRECISION(x)
            print '(A,I10)', " Decimal exponent range: ",RANGE(x)

            print '(A,E8.1)'," epsilon:                      ",EPSILON(x)
            print *, "-----------------------------------------------------------"
        end subroutine print_type_info_higher
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
! 
! SELECTED_REAL_KIND(P,R) returns the kind value of a real data type with decimal precision of at least P digits, exponent range of
! at least R, and with a radix of RADIX. 

! Willem Melis
! gecompileerd met GNU Fortran (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609
! compiler-commando:  gfortran vierkantsvergelijking.f90 -o Huistaak3
! Gecompileerd op server heist
! Het aantal uren voor deze taak weet ik niet, ik heb nogal veel tijd verloren aan de interpretatie(niet implementatie) van floating point resulaten
! En het zou niet juist zijn deze uren hieraan mee te rekenen.
!
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! DEEL1: floating point
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
! Round to Nearest – rounds to the nearest value; if the number falls midway 
! it is rounded to the nearest value with an even (zero) least significant bit,
!
! ## bespreking SINGLE PRECISION ##
!
! De matissa is 23 lang (de eerste nul wordt niet bewaard) daarnaast hebben we nog 1 tekenbit, de eponent is dus 32-23-1=8 lang.
! Aangezien de exponent alsook negatief gaat hebben we dus een bovengrens van 2^7=128. 
! De ondergrens van de min exponent is -125 de resterende range is gebruikt
! voor het voostellen van speciale tekens!. (8 bits hebben namelijk 256 combinaties)
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
! Het max getal die we dus kunnen gebreiken is 0.111..111*2^128 dit is dus (1-2^24)*2^128 ~= 3.4 10^38.
! In tegenstelling tot wat verwacht wou worden is dus de decimate eponent range altijd tien keer lager dan
! het grootste getal dat kan voorgesteld worden.
! 
! 
! ## besprekeing DOUBLE PRECISION ##
! 
! De mantissa is 53 lang (de eerste nul wordt niet bewaard) daarnaast heben we nog 1 tekenbit en de exponent is dus 64-53-1=11 bits lang .
! 2^10=1024 de exponent kan van 1024 tot -1021, het resterende bereik wordt gebruikt voor speciale tekens.
! 
! Dezelfde redenering als voordien voor de machine precisie: (2^-52)*2^1 = gewicht laatste digit van mantisse van float(1)
! Dus helft van (2^-52)*2^1 is 2^-53 ~= 2.2e-16 ~=0.2e-15
! Dit komt overeen met de waarde uit de epsilon functie, en verklaart de decimale precisie van 15.
! De redenering van de decimale exponent range  is idem aan de vorige oefening.
!
! ## besprekeing EXTENDED PRECISION (gfortran) ##
!
! Dit is het extended type vanop de intel processoren, 10bytes lang!
! Indien een andere compiler wordt gebruikt is dit type soms niet beschikbaar.
! Bijvoorbeeld ifort zan direct overschakelen naar quad precision dus kind=16 en niet kind=10
! De matissa is 64bits groot, daarnaast heben we opnieuw een tekenbit dus
! de lengte van de exponent is 80-64-1=15.
! 2^14=16384, opnieuw ontbreekt er een stuk van de range aan de negatieve kant.
! Zoals bij de andere formaten is dit voor speciale teken.
!
! De machine precisie is 2^63 = 0.1e-18 , identieke redenering van de vorige twee precisies. 
! Dit verklaart dan weer de decimale precisie, de decimale exponent range is alsook weer 10 maal lager dan het grootste voorstelbaar getal.
! 
! 
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! DEEL2: algoritme1 en algorithme2
!
! Als we voor b=-577 en c=13 de wortels uitrekenen krijgen we volgende resultaten.
!
! DOUBLE PRECISION:
! algorithm1:
! x1=   576.97746879089186
! x2=   2.2531209108137773E-002
! ----
! algorithm2:
! x1=   576.97746879089186
! x2=   2.2531209108117633E-002
! -----------------
! SINGLE PRECISION:
! algorithm1:
! x1=   576.977478
! x2=   2.25219727E-02
! ----
! algorithm2:
! x1=   576.977478
! x2=   2.25312095E-02!
!
! Om te "testen" hoe correct het algortme is bereken we het residu van elke wortel.
! En tellen de absoulte waarde van beide wortels op. We kijken dus naar de achterwaardse stabiliteit! (verder wordt gerefereerd naar
! stabilieteit dit is stilzwijgent achterwaardse stabiliteit)
! Opgelet! het residu van de enkele precisie wordt uitgerekent met dubbele precisie ! (om geen apples en peren te vergelijken)
!
! Als we b=-577 en c=13 dan krijgen we:
! |residu's double precision:
! |0.0E+00  0.7-309
! |residu's single precision:
! |0.5E-02  0.2E-06
!
! bij sommige b en c's is algortme1 inderdaad beter.
! Het voorbeeld hieronder is een geval waarbij de bubbele precisie van algoritme1 een
! lagere residu heeft. Maar voor enkelvoudig precisie is dat alweer niet het geval.
! Algirtme1 is duidelijk niet stabiel, en heeft soms zeer goede en soms slechte resultaten.
! Algoritme2 aan de andere kan heeft een consisitent goed resultaat.
! b=100 and c=-100
! |residu's double precision:
! |0.0E+00  0.7-309
! |residu's single precision:
! |0.3E-03  0.5E-06
! 
! maar meestal is algoritme2 beter of zijn de resultaten equivalent een ander voorbeeld:
! b=10 and c=1
! |residu's double precision:
! |0.1E-13  0.7-309
! |residu's single precision:
! |0.5E-05  0.8E-06
!
! BESLUIT: Algortme2 is duidelijk stabieler dan algortihm1. Het is dus nodig om aandacht
! te besteden aan het omvormen van een formule. Alvoors men deze implementeerd.
!
!
program main
    USE, INTRINSIC :: IEEE_ARITHMETIC; USE, INTRINSIC :: IEEE_FEATURES 
    implicit none
    integer, parameter :: wp_single= selected_real_kind(4)
    integer, parameter :: wp_double= selected_real_kind(8)
    real(kind=wp_double) :: b,c
    real(kind=wp_single) :: b_sp,c_sp

    call print_all()

    READ(*,*) , b
    READ(*,*) , c
    b_sp=b
    c_sp=c

    call printResidusDouble(b,c)
    call printResidusSingle(b_sp,c_sp)
    call evaluateBothAlgosAt(b,c) 
    
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
     ! implementation algorithm1 single precision
     function algorithm1_x1_single(b,c) result(x)
         real(kind=wp_single) x,b,c
         x = - (b/2_wp_single) + Dis_single(b,c)
     end function algorithm1_x1_single
     function algorithm1_x2_single(b,c) result(x)
         real(kind=wp_single) x,b,c
         x = - (b/2_wp_single) - Dis_single(b,c)
     end function algorithm1_x2_single

     ! implementation algorithm2 single precision
     function algorithm2_x1_single(b,c) result(x)
         real(kind=wp_single) x,b,c
         x = sign((abs(b/2) + Dis_single(b,c)),-b)
     end function algorithm2_x1_single
     function algorithm2_x2_single(b,c) result(x)
         real(kind=wp_single) x,b,c
         x = c / algorithm2_x1_single(b,c)
     end function algorithm2_x2_single
     
     ! calculate discriminant single precision
     function Dis_single(b,c) result(D)
         real(kind=wp_single) D,b,c
         D = sqrt((b/2_wp_single)**2_wp_single - c)
     end function Dis_single
 
     ! implementation algorithm1 double precision
     function algorithm1_x1_double(b,c) result(x)
         real(kind=wp_double) x,b,c
         x = - (b/2_wp_double) + Dis_double(b,c)
     end function algorithm1_x1_double

     function algorithm1_x2_double(b,c) result(x)
         real(kind=wp_double) x,b,c
         x = - (b/2_wp_double) - Dis_double(b,c)
     end function algorithm1_x2_double

     ! implementation algorithm2 double precision
     function algorithm2_x1_double(b,c) result(x)
         real(kind=wp_double) x,b,c
         x = sign((abs(b/2) + Dis_double(b,c)),-b)
     end function algorithm2_x1_double
     function algorithm2_x2_double(b,c) result(x)
         real(kind=wp_double) x,b,c
         x = c / algorithm2_x1_double(b,c)
     end function algorithm2_x2_double

     ! calculate discriminant double precision
     function Dis_double(b,c) result(D)
         real(kind=wp_double) D,b,c
         D = sqrt((b/2_wp_double)**2_wp_double - c)
     end function Dis_double

     subroutine evaluateBothAlgosAt(b,c) 
         real(kind=wp_double) :: b,c
         print *, "DOUBLE PRECISION:"
         print *, "algorithm1:"
         print *, "x1=", algorithm1_x1_double(b,c)
         print *, "x2=", algorithm1_x2_double(b,c) 
         print *, "----"
         print *, "algorithm2:" 
         print *, "x1=", algorithm2_x1_double(b,c)
         print *, "x2=", algorithm2_x2_double(b,c)

         print *,"-----------------"
         print *, "SINGLE PRECISION:"
         b_sp = b
         c_sp = c
         print *, "algorithm1:"
         print *, "x1=", algorithm1_x1_single(b_sp,c_sp)
         print *, "x2=", algorithm1_x2_single(b_sp,c_sp) 
         print *, "----"
         print *, "algorithm2:" 
         print *, "x1=", algorithm2_x1_single(b_sp,c_sp)
         print *, "x2=", algorithm2_x2_single(b_sp,c_sp)
     end subroutine
     subroutine printResidusDouble(b,c)
         real(kind=wp_double) :: b,c
         real(kind=wp_double) :: x, residu_alg1, residu_alg2

         x = algorithm1_x1_double(b,c)
         residu_alg1 = abs(x**2 + b*x +c)
         x = algorithm1_x2_double(b,c)
         residu_alg1= residu_alg1 + abs(x**2 + b*x +c)

         x = algorithm2_x1_double(b,c)
         residu_alg1 = abs(x**2 + b*x +c)
         x = algorithm2_x2_double(b,c)
         residu_alg2 = residu_alg2 + abs(x**2 + b*x +c)

         print*, "residu's double precision:"
         print '(E8.1,A,E8.1)', residu_alg1, " ",  residu_alg2
     end subroutine
     subroutine printResidusSingle(b,c)
         real(kind=wp_single) :: b,c
         real(kind=wp_double) :: x, residu_alg1, residu_alg2

         x = algorithm1_x1_single(b,c)
         residu_alg1 = abs(x**2 + b*x +c)
         x = algorithm1_x2_single(b,c)
         residu_alg1= residu_alg1 + abs(x**2 + b*x +c)

         x = algorithm2_x1_single(b,c)
         residu_alg1 = abs(x**2 + b*x +c)
         x = algorithm2_x2_single(b,c)
         residu_alg2 = residu_alg2 + abs(x**2 + b*x +c)

         print*, "residu's single precision:"
         print '(E8.1,A,E8.1)', residu_alg1, " ",  residu_alg2
     end subroutine

 end  program main


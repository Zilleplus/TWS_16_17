! Willem Melis
! gecompileerd met GNU Fortran (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609
! compiler-commando:  gfortran vierkantsvergelijking.f90 -o Huistaak3
! Gecompileerd op server tienen
! Het aantal uren voor deze taak weet ik niet, ik heb nogal gesukkelt met de interpretatie van floating point resulaten
! En het zou niet juist zijn deze uren hieraan mee te rekenen.
!
! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
! 
! Als we vor b=-577 en c=13 de wortels uitrekenen krijgen we volgende resultaten.
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
! En tellen de absoulte waarde daarvan op. We kijken dus naar de achterwaardse stabiliteit!
! Opgelet! het residu van de enkele precisie wordt uitgerekent met dubbele precisie ! (om geen apples en peren te vergelijken)
!
! Als we b=-577 en c=13 dan krijgen we:
! |residu's double precision:
! |0.0E+00  0.7-309
! |residu's single precision:
! |0.5E-02  0.2E-06
!
! bijs sommige b en c's is algortme1 inderdaad beter.
! Het voorbeeld hieronder is een geval waarbij de bubbele precisie van algoritme1 een
! lagere residu heeft. Maar voor enkelvoudig precisie is dat alweer niet het geval.
! Algirtme1 is duidelijk niet stabiel, en heeft soms zeer goede en soms slechte resultaten.
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
! BESLUIT: spijtig genoeg blijkt algortim2 niet beter dan algoritme1, dit was nochtans wat ik verwacht had.
! De testresultaten zijn wat ze zijn. Geen van beide van deze algoritmes

program main
    implicit none
    integer, parameter :: wp_single= selected_real_kind(4)
    integer, parameter :: wp_double= selected_real_kind(8)
    real(kind=wp_double) :: b,c
    real(kind=wp_single) :: b_sp,c_sp

    READ(*,*) , b
    READ(*,*) , c
    b_sp=b
    c_sp=c

    call printResidusDouble(b,c)
    call printResidusSingle(b_sp,c_sp)
    call evaluateBothAlgosAt(b,c) 
    
contains
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


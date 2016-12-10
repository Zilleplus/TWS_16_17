! ---------------------------------------------------------------------------------------
! Willem Melis WIT
! r0348639
! compiler commando: 
!
! gfortran -c matrixop.f90 -lblas -fopenmp  --param loop-block-tile-size=100
! gfortran -O3 test.f90  matrixop.o -lblas -fopenmp  --param loop-block-tile-size=100
! ./a.out
!
! tijdsbesteding 6 uur
! Wel heel irritant dat somige mensen uit het niets ploseling al de pc's op CW nodig
! hebben voor berekeningen, en ik dus moet stoppen. Dit gebeurde meerdere keren.
! Daarnaast heb ik de testen per ongeluk eens gedaan op een pc met minder goede specs.
! de cache was veel kleiner en men resultaten waren plotseling veel slechter.
! Misschien is dit een nuttige waarschuwing voor in de opgave, de pcs op CW zijn niet gelijk
! van specs.
! ---------------------------------------------------------------------------------------
! OUTPUT:
! starting test with N=          20
! starting test with N=          30
! starting test with N=          40
! starting test with N=          50
! starting test with N=          60
! starting test with N=          70
! starting test with N=          80
! starting test with N=          90
! starting test with N=         100
! starting test with N=         200
! starting test with N=         300
! starting test with N=         400
! starting test with N=         500
! starting test with N=         700
! starting test with N=        1000
! ---------------------------------------------------------------------------------------
!
! 
! ---------------------------------------------------------------------------------------
! DEEL 1 bespreking van de code uit de oefenzitting
! ---------------------------------------------------------------------------------------
! 1. JKI is de snelste van de eerste 6 oplossingen, KJI komt zeer dicht in de buurt.
! I wordt het best als binnenste loop uitgevoerd omdat deze altijd in de zelfde kollom blijven.
! 
! --> c(i,j) = c(i,j) + a(i,k)*b(k,j)
! 
! Merk op dat i bij c en a itereerd door de  kollom met index j of k.
! In b zal k itereren door de jde kollom
! 
! Dit is in in Fortran sneller omdat de matrixen kollom per kollom worden bijgehouden. 
! Als een element uit de matrix wordt opgehaald zullen de volgende elementen uit de kollom 
! gecached worden. Als dit net de elementen zijn die nodig zijn in de volgende iteratie zal 
! het algortime dus een stuk sneller zijn.
! 
! 2. De vector operaties zijn duidelijk sneller dan de individueele operaties.
! De compiler kan hier dus beter optimaliseren.
! 
! 3. Het dot product wordt uitgerekend tussen  de rijen van a en de kollommen van b. 
! Het uitlezen van de rijen van a zal traag gebeuren omdat opnieuw fortran de matrixen per kollom bewaard.
! 
! 4. Door a te transponeren wordt het dot product berekend tussen twee kollommen, Het uitlezen
! van de kollommen van een matrix kan zeer snel gebeuren. Er is duidelijk een tijdwinst.
! 
! 
! 5. BLAS lijkt raar genoeg geen meerdere cores te gebruiken, eerst keek op ik top als er meerdere 
! core's belast waren. Dit bleek niet zo te zijn, dus vroeg ik me af of er wel nog verschillende processen waren. 
! In principe kan het zijn dat de scheduler alle taken op 1 core plaatst, ps ax | grep a.out gaf aan dat er maar 
! 1 proces was.
! En aangezien de PC's op CW linux machines zijn weten we dat er een 1-1 mapping is tussen processen vanuit
! userspace en kernel space. Dus geen multicore als er maar 1 proces ID zichtbaar is!
!
! ####
!
! 6. wat is de L2 cach grote? volgens /proc/cpu is de cache 256kibiByte groot
! De formule uit de presenties van de voorbereiding vermeld volgende formule:
!     de blocksize moet dus kleiner zijn dan sqrt(MiB/3)
! Aangezien gewerkt wordt met double precision die 8 bytes per woord bevatten moeten we M ook nog delen
! door 8 als we de eenheid van n willen idpv het aantal bytes.
! 
! -> max_blocksize = sqrt((M/3)/aantal bytes in 1 getal) = sqrt(((256000/8)/3)) = 103.2796
! 
! 
! Dit is alsook waar te nemen met een klein experiment:
! We nemen een matrix van groote N=3000 en varieeren de blok grote n=?
! 
! n=50   | 8.88  seconden
! n=100  | 8.14  seconden
! n=120  | 7.99  seconden
! n=150  | 9.46  seconden
! n=300  | 8.35  seconden
! n=1000 | 12.18 seconden
!
! Doordat alles nu in de L2 cache zit maakt het minder uit welke routine je gebruikt.
! We hebben nog steeds een L1 cache waarmee rekening moet worden gehouden.
! Dus het maakt nog uit, maar het verschil in snelheid zal minder erg zijn.
! 
! ####
! 
! 7. matmul
! We doen opnieuw hetzelfde experiment met een matrix van N=3000, dit maal varieeren we de blocksize
! van matmul bij het compileren
! 
! 
! gfortran -c matrixop.f90 -O3 -lblas -floop-block -fopenmp --param loop-block-tile-size=n
! gfortran -O3 dmr.f90 matrixop.o -lblas -floop-block -fopenmp --param loop-block-tile-size=n
! N=3000
! ---------------------
! n=500 | 14.1 seconden
! n=200 | 13.93
! n=100 | 13.81 seconden
! n=50  | 13.9 seconden
!
! Het verschil is merkbaar, maar eigenlijk totaal niet zo extreem als ik het verwacht had.
!
! Wat als we nagfor proberen?
! compiler commando: nagfor -c matrixop.f90 -lblas -Oblock=n
!                    nagfor dmr.f90 matrixop.o -lblas -Oblock=n
! Voor een matrix met N=2000 duur dit al 34.55 seconden, dit is veel trager dan gfortran.
! N=3000 heb ik even laten lopen maar die eindigde maar niet achter een halve minuut, het
! is dus overduidelijk trager. Persoonlijk had ik een beter tijd verwacht van de nagfor compiler.
! Hopelijk zijn er andere voordelen aan nagfor, waarom zou je die anders aankopen?
!
! ####
!
! 8. extra Algortim, aangezien de voorbereiding filmpjes waren over parallelisren van algoritmes
! ben ik dit gaan doen met het block algoritme. In de hoop dat deze da sneller zou zijn bij
! grote matrixen. Dit bleek niet het geval te zijn.
! Bij de huidige implementatie heeft iedere parallel proces een block om te rekenen die
! groot genoeg is om in zijn cache te passen. Moesten we en iedere proces meerdere blokken
! geven zodat die net in zijn L3 cache konden kunnen we het aantal berichte tussen de processen
! verlagen. En zal het algoritme waarschijnlijk een stuk sneller zijn.
!
! Een alternatieve aanpak was het strassen algortme, me sneller te zijn voor een zoor grote matrix.
!
! ---------------------------------------------------------------------------------------
! DEEL 2 testen + grafiek
! ---------------------------------------------------------------------------------------
!
! Aangezien dmr.f al tijdsmetingen deed heb ik deze aangepast zodat deze de uitvoer naar 
! tekst bestanden wegschrijft. Deze tekst bestanden hebben de structuur :
! N minimum average maximum 
!
! Dit formaat met de spacies is makkelijk in te laden in matlab met het load commando.
! Vervolgende heb het het gemiddelde in de bovenhelft van de figuur geplaatst en het 
! minimum en het maximum in de onderste helft. Het matlab script graph.m zal de grafiek genereren.
! 
! Het probleem die ik tegekwam bij het berekenen van de maximum is dat de kleinste 
! tijd van de meting bij het bereken van het aantal flop/s ontploft. aangezien we 
! delen door een extreem klein getal. Het gemiddelde en het min aantal flop/s heeft 
! dit probleem natuurlijk niet als ik genoeg metingen doe. 
!
! De link met de cursus/voorbereiding: uitleg cache,parallel algoritme, strassen algo vermeld... eerder linken.
!
! De grafiek is zoals te verwachten blas domineerd vrij extreem bij grote matrixen.
! De extra methode die parallel is haalt matmul in vannaf een matrx van dimensie 800.
! Dan wordt waarschijnlijk de overhead van de parallelisatie relatief gezien zeer klein.
! matmul is de derde snelste en de blocks zit nog een beetje achter. De rest is vrij slecht.
!
! Bij het maximum is blas zeer dominant, alhoewel de metingen van het max aantal flop/s vrij slecht is zoals al eerder besproken.
!
! Het minimum illustreerd hoe stabiel blas is, zelfs de minimum waarden blijven hoog!

program dmr
    use matrixop
    USE, INTRINSIC :: IEEE_ARITHMETIC, ONLY: IEEE_IS_FINITE 
    use, intrinsic :: iso_fortran_env
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
    real :: flops ! not flop/s as its a variable name
    real :: dummy_i, dummy_j
    integer, dimension(:), allocatable :: seed
    real(kind=dp), dimension(:,:), allocatable :: a, b, c
    real(kind=dp), dimension(:,:), allocatable :: c_matmul
    integer ::  unit_number_loops,unit_number_dot_product,&
                unit_number_blas,unit_number_block, &
                unit_number_matmul, unit_number_extra 
    integer :: index_test
    integer, parameter :: qp = selected_real_kind (32)
    integer :: possibleN(15)
    ! open the log files:
    unit_number_loops=7
    unit_number_dot_product=8
    unit_number_blas=9
    unit_number_block=10
    unit_number_matmul=11
    unit_number_extra=12

    OPEN(UNIT=unit_number_loops,        FILE="data_pureLoops.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_dot_product,  FILE="data_dot_product.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_blas,         FILE="data_blas.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_block,        FILE="data_block.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_matmul,       FILE="data_matmul.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")
    OPEN(UNIT=unit_number_extra,        FILE="data_extra.txt",FORM="FORMATTED",STATUS="REPLACE",ACTION="WRITE")

    ! Make sure we use the same pseudo-random numbers each time by initializing
    ! the seed to a certain value.
    call random_seed(size=k)
    allocate(seed(k))
    seed = N
    call random_seed(put=seed)

    possibleN= (/ 20, 30, 40, 50, 60 ,70 ,80 , 90, 100, 200, 300, 400, 500, 700, 1000 /) 
    do index_test=1,size(possibleN)
        N=possibleN(index_test)

        if(N<100) then
            blocksize=N
        else
            blocksize=100
        end if

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

        ! 8. extra function , parallel blocks
        call do_timing( "extra function", unit_number_extra , method_blocks=a_maal_b_extra)
        
        deallocate(a, b, c, c_matmul)
    end do
    
    ! close the log files
    CLOSE(UNIT=unit_number_loops)
    CLOSE(UNIT=unit_number_dot_product)
    CLOSE(UNIT=unit_number_blas)
    CLOSE(UNIT=unit_number_block)
    CLOSE(UNIT=unit_number_matmul)
    CLOSE(UNIT=unit_number_extra)
contains
    subroutine do_timing( name,unit_number, method, method_blocks )
        character(len=*), intent(in) :: name
        procedure(a_maal_b_interface), optional :: method
        procedure(a_maal_b_blocks_interface), optional :: method_blocks
        real(kind=dp) :: mynorm
        integer :: number_of_simulations=3
        real :: t1, t2
        real(kind=qp) ::  number_of_simulations_qp, min_flops,max_flops,avg_flops,infinity
        real(kind=qp),allocatable ::  delta_t(:)
        integer , intent(in):: unit_number
        integer i
        ! real(dp), parameter :: nan =  transfer(-2251799813685248_int64, 1._dp)
        if(N<256) then
            number_of_simulations = 10
        end if
        ! the really fast ones need way more simulations
        if(N<128) then
            number_of_simulations = 1000
        end if

        allocate(delta_t(number_of_simulations))
        number_of_simulations_qp=number_of_simulations
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
        max_flops =  N*N*(2*N-1)/MINVAL(delta_t)
        avg_flops =  N*N*(2*N-1)/(SUM(delta_t)/number_of_simulations_qp)
        min_flops =  N*N*(2*N-1)/MAXVAL(delta_t)
        
        infinity = HUGE(infinity)
        if(max_flops>infinity) then 
            max_flops=0
        end if
        write(unit_number,"(I6, A, E9.3,  A, E9.3, A, E9.3  )")&
            N, " ", &
            min_flops, " " , & 
            avg_flops , " " , &
            max_flops
    end subroutine do_timing
end program dmr

! -----------------------------------------------------------
! Willem Melis
! WIT
! compile commando: $ gfortran prime.f90
! gecompileerd met GNU Fortran (Ubuntu 5.4.0-6ubuntu1~16.04.2) 5.4.0 20160609
! gecompileerd op server vilvoorde
! -----------------------------------------------------------
! ###########################################################
! Het originele programma heeft een n=6163 priemgetal is 60859
! De aanpassingen zijn aangeduid in de code met een nummer [x] waarbij x=de verbeteringsstap
! 1. De useless array is compleet nutteloos, en is daarom verwijdert uit het programma 
!  -> n=6077 priemgetal=60209, merkwaardig genoeg is dit dus slechter? check=false
! 2. Primelist was een 2D array, maar er is slechts een 1D array nodig
!    De lijn (primeList(3,j) = min(i,j)) wordt alsook verwijdert, gezien deze alleen gebruik maakt 
!    van de 3de rij van deze matrix en alsook geen nut heeft.
!  -> n=6092 priemgetal=60383   check=false
! 3. Nbchecks wordt alsook niet gebruikt, en is daarom alsook verwijdert 
!  ->n=6122 pn=60733   check=false
! 4. De individuele print van ieder priemgetal is alsook verwijdert, wegens overbodig
!       Alleen het hoogste priemgetal wordt achteraf afgeprint
!  -> n=6660 pn=60841  check=false
! 5. Bij het vinden van een deler moet niet meer verder gezocht
!        worden op iets een priegetal is.
!    volgende loop krijgt een exit
!    # if (modulo(primeList(i), primeList(j)) == 0) then
!    #     isPrime = .false.
!    #     exit <-- deze komt erbij !
!    # end if
! -> n=21630 pn=244939  check=true
! 6. Alle even en oneven nummers worden overlopen nochtans zijn
!      even nummers al zeker geen priemgetallen zijn
!    Dit vraagt een aantal aanpassingen
!     -> voeg 3 voorafaan toe aan de priemgetal lijst
!     -> verander de volgende lijn: 
!           primeList(i) = primeList(i) + 1
!        naar:
!           primeList(i) = primeList(i) + 2
! -> n=21686 pn=245071  check=true        
! ###########################################################
! OUTPUT:
! Enter the value of n: 10000
! Prime 1: 2
! Elapsed real time =    218.000000
! Prime 10000 is 104729, check = T
! ###########################################################

program prime

implicit none
integer     :: n, i, j! , nbChecks [3]
integer, dimension(:), allocatable	:: primeList
! integer, dimension(:,:), allocatable    :: primeList  [aanpassing2] 
real :: useless(900)
logical     :: isPrime
integer ts1,ts2
integer prime_10000
logical check
logical outOfTime

prime_10000 = 104729

write(unit=*, fmt="(A)", advance="no") "Enter the value of n: "
read *, n

call system_clock ( ts1)

! nbChecks = 0 [3]
!allocate(primeList(3,n)) [2]
allocate(primeList(n))

primeList(1) = 2 ! [2]  
primeList(2) = 3 ! [2]
write(unit=*, fmt="(A, I0, A, I0)") "Prime ", 1, ": ", primeList(1) ! [2]

do i = 3,n
  ! check if the time ellaps i snot too high
  call system_clock ( ts2)
  if((ts2-ts1)<1000) then
    ! put the last element in new one
    primeList(i) = primeList(i-1) ![2]
    do
      ! keep incrementing towards a possible prime
      primeList(i) = primeList(i) + 2 ![2] [6]
      ! useless(mod(i,900)) = cos(i+0.5) [aanpassing 1]
      isPrime = .true.
      do j = 1,i-1
        ! nbChecks = nbChecks + 1 [3]
        ! if its divisible by a previous prime, it cant be a prime
        if (modulo(primeList(i), primeList(j)) == 0) then ! [2]
          isPrime = .false.
          exit ! [5]
        end if
      end do
      if (isPrime) then
        ! write(unit=*, fmt="(A, I0, A, I0)") "Prime ", i, ": ", primeList(i) ![2] [4]
        exit
      end if
    end do
  else
      outOfTime=.true.
      exit
  end if
end do

if (outOfTime) then
  ! we are out of time,
  print *, "OUT OF TIME, max 1 second of calculation time allowed"
  n=i-1
else
  call system_clock ( ts2)
  write ( *, * ) 'Elapsed real time = ', real ( ts2 - ts1 )
end if 


! check if the last prime is 104729
if(i>10000) then
    check=primeList(10000)==prime_10000 ![2]
else
    check=.false.
end if

write(unit=*, fmt="(A, I0, A, I0, A, L, A)")  "! Prime ", n , " is ", primeList(n), ", check = ", check ![2]

deallocate(primeList)
end program prime


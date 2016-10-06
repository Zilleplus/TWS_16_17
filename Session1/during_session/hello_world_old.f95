program main
    implicit none
    integer i
    integer read_i


    read(*,*) read_i
    i=1
    ! if (i==1) then
    !     print *, "Hello World!"
    ! end if
    do i=1,read_i
        print *, "Hello World!"
    end do
end program

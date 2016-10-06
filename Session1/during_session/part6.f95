program main
    implicit none
    print *, rec(5)
    contains

    function rec(n) result(n_out) 
        implicit none
        integer, intent(in) :: n
        integer :: n_out

        if(n>0) then
            n_out=n*(n-2)
        elseif(n==0 .OR. n==-1) then
            n_out=1
        else
            n_out=0
        end if


    end function rec
end program



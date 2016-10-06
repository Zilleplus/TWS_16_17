program main 
    integer i,j
    character, dimension(80) :: first_line
    character(len=50) :: text="Here's to the crazy ones. The misfits. The rebels."
    character(len=80) :: second_line = ""
    character(len=80) :: tirth_line = ""
    integer number

    do i=0,7
        do j=1,9
            number=i*10+j
            Write( first_line(number), '(i0)' ) j
        end do
        Write( first_line(i*10+10), '(i0)' ) 0
    end do

    second_line(15:65) = text
    tirth_line(30:80) = text
    
    print *, first_line
    print *, text
    print *, second_line
    print *, tirth_line 

end program

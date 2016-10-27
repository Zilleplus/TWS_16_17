program main
    implicit none

    integer, parameter :: wp= selected_real_kind(8)

    real(kind=wp) z
    real(kind=wp) last_z
    real(kind=wp) g_z
    real(kind=wp) g_z_taylor
    real(kind=wp) difference

    integer :: i

    z=1_wp
    last_z=0_wp
    i=0
    do while ( (z-last_z) /= 0_wp )           
        last_z=z
        z = 1_wp-(2_wp**(-i + 0.0_wp))

        g_z = 1/(acos(z)**2_wp)- (1_wp/(2_wp-z*2))
        g_z_taylor = -(1_wp/12_wp) + (z-1_wp)/120_wp - (31_wp*((z-1_wp)**2_wp))/15120_wp + (289_wp*((z-1_wp)**3_wp))/453600_wp 

        difference = g_z - g_z_taylor
        
        ! print *, i," ",g_z
        ! print *, i," ",g_z_taylor
        print *,z," ",difference
        ! print *, "---"
        i=i+1
    end do
end program




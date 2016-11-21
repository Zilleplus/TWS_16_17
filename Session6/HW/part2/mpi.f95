program main
    USE mpi
    implicit none
    integer :: error,rank,numberOfProcesses,i
    integer :: status_mpi(MPI_status_size)
    logical :: send_recv_buffer


    call MPI_init(error)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, error)
    call MPI_Comm_size(MPI_COMM_WORLD, numberOfProcesses, error) 

    print *, "executing process:",rank
    if(rank==0) then
        ! if we are in the root process
        print *, "the number of processes running:",numberOfProcesses
        do i=1,numberOfProcesses-1
            !                                           source  tag
            call MPI_Recv(send_recv_buffer,1,MPI_LOGICAL         ,   i,    i,    MPI_COMM_WORLD,   status_mpi , error)
            print *,"received", send_recv_buffer
        end do
    else 
        ! non root  process
        send_recv_buffer=.true.
        !                                              dest  tag 
        call MPI_Send(send_recv_buffer, 1, MPI_LOGICAL        ,   0,  rank,    MPI_COMM_WORLD, error)
    end if

    call MPI_FINALIZE(error)
end program main

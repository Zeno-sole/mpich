! This file created from f77/coll/split_typef.f with f77tof90
!
! Copyright (C) by Argonne National Laboratory
!     See COPYRIGHT in top-level directory
!

      program main
      use mpi
      integer ierr, errs
      integer i, ans, size, rank, color, comm, newcomm
      integer maxSize, displ
      parameter (maxSize=128)
      integer scounts(maxSize), sdispls(maxSize), stype
      integer rcounts(maxSize), rdispls(maxSize), rtype
      integer sbuf(maxSize), rbuf(maxSize)

      errs = 0

      call mtest_init( ierr )

      call mpi_comm_dup( MPI_COMM_WORLD, comm, ierr )
      call mpi_comm_rank( comm, rank , ierr )

      call mpi_comm_split_type( comm, MPI_COMM_TYPE_SHARED, rank, &
      &     MPI_INFO_NULL, newcomm, ierr )
      call mpi_comm_rank( newcomm, rank, ierr )
      call mpi_comm_size( newcomm, size, ierr )

      do i=1, size
         scounts(i) = 1
         sdispls(i) = (i-1)
         sbuf(i) = rank * size + i
         rcounts(i) = 1
         rdispls(i) = (i-1)
         rbuf(i) = -1
      enddo
      stype  = MPI_INTEGER
      rtype  = MPI_INTEGER
      call mpi_alltoallv( sbuf, scounts, sdispls, stype, &
      &     rbuf, rcounts, rdispls, rtype, newcomm, ierr )

      call mpi_comm_free( newcomm, ierr )
      call mpi_comm_free( comm, ierr )

      call mtest_finalize( errs )
      end

module Stationary

contains

  ! Accepts row-major triple format
  
  subroutine sym_gauss_seidel(irows,icols,vals,b,N,NNZ,x, N_ITER)
    integer, intent(in) :: N, NNZ
    integer, intent(in), dimension(NNZ) :: irows, icols
    real(kind=8), intent(in), dimension(NNZ) :: vals
    real(kind=8), intent(in), dimension(N) :: b
    real(kind=8), intent(out), dimension(N) :: x
    integer,intent(in) ::  N_ITER
    
    integer :: i,k
    real(kind=8) :: diag

    x = 0.0
    
    do it=1,n_iter

       ! Forward iteration
       k=1
       do i=1,N
          ! calculate x[i]
          x(i) = b(i)
          do while (k<=NNZ .AND. irows(k)==i)
             j=icols(k) ! column index
             if (i==j) then
                diag = vals(k) ! diagonal
             else
                x(i) = x(i) - x(j)*vals(k)
             end if
             k = k+1
          end do
          x(i) = x(i) / diag
       end do

       ! Backward iteration
       k=NNZ
       do i=N,1,-1
          ! calculate x[i]
          x(i) = b(i)
          do while (k>0 .AND. irows(k)==i)
             j=icols(k) ! column index
             if (i==j) then
                diag = vals(k) ! diagonal
             else
                x(i) = x(i) - x(j)*vals(k)
             end if
             k = k-1
          end do
          x(i) = x(i) / diag
       end do

    end do
  
  end subroutine sym_gauss_seidel

  ! Accepts row-major triple format
  ! Irows and icols can start with values 0
  ! This was modified by me
  
  subroutine sym_gauss_seidel_zero(irows,icols,vals,b,N,NNZ,x, N_ITER)
    integer, intent(in) :: N, NNZ
    integer, intent(in), dimension(NNZ) :: irows, icols
    real(kind=8), intent(in), dimension(NNZ) :: vals
    real(kind=8), intent(in), dimension(N) :: b
    real(kind=8), intent(out), dimension(N) :: x
    integer,intent(in) ::  N_ITER
    
    integer :: i,k
    real(kind=8) :: diag

    x = 0.0
    
    do it=1,n_iter

       ! Forward iteration
       k=1
       do i=1,N
          ! calculate x[i]
          x(i) = b(i)
          do while (k<=NNZ .AND. irows(k)==i-1) ! see SGSFortranPreconditioner
             j=icols(k)+1 ! column index, see SGSFortranPreconditioner
             if (i==j) then
                diag = vals(k) ! diagonal
             else
                x(i) = x(i) - x(j)*vals(k)
             end if
             k = k+1
          end do
          x(i) = x(i) / diag
       end do

       ! Backward iteration
       k=NNZ
       do i=N,1,-1
          ! calculate x[i]
          x(i) = b(i)
          do while (k>0 .AND. irows(k)==i-1) ! see SGSFortranPreconditioner
             j=icols(k)+1 ! column index, see SGSFortranPreconditioner
             if (i==j) then
                diag = vals(k) ! diagonal
             else
                x(i) = x(i) - x(j)*vals(k)
             end if
             k = k-1
          end do
          x(i) = x(i) / diag
       end do

    end do
  
  end subroutine sym_gauss_seidel_zero
  
  ! Uses 0-based indexing
  ! Suggested by user thrope in freenode
  
  subroutine sym_gauss_seidel_thrope(irows,icols,vals,b,N,NNZ,x, N_ITER)
    integer, intent(in) :: N, NNZ
    integer, intent(in), dimension(0:NNZ-1) :: irows, icols
    real(kind=8), intent(in), dimension(0:NNZ-1) :: vals
    real(kind=8), intent(in), dimension(0:N-1) :: b
    real(kind=8), intent(out), dimension(0:N-1) :: x
    integer,intent(in) ::  N_ITER
    
    integer :: i,k
    real(kind=8) :: diag

    x = 0.0
    
    do it=1,n_iter

       ! Forward iteration
       k=0
       do i=0,N-1
          ! calculate x[i]
          x(i) = b(i)
          do while (k<NNZ .AND. irows(k)==i)
             j=icols(k) ! column index
             if (i==j) then
                diag = vals(k) ! diagonal
             else
                x(i) = x(i) - x(j)*vals(k)
             end if
             k = k+1
          end do
          x(i) = x(i) / diag
       end do

       ! Backward iteration
       k=NNZ - 1
       do i=N-1,0,-1
          ! calculate x[i]
          x(i) = b(i)
          do while (k>=0 .AND. irows(k)==i)
             j=icols(k) ! column index
             if (i==j) then
                diag = vals(k) ! diagonal
             else
                x(i) = x(i) - x(j)*vals(k)
             end if
             k = k-1
          end do
          x(i) = x(i) / diag
       end do

    end do
  
  end subroutine sym_gauss_seidel_thrope
end module Stationary

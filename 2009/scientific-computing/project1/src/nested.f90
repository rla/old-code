module Nested

contains

  subroutine Sum(values, nesting, res, M, N)
    integer, intent(in) :: N
    real(8), intent(in) :: values(M)
    integer, intent(in) :: nesting(M)
    real(8), intent(out) :: res(N)

    integer k

    res = 0.0
    do k=1,M
       i = nesting(k)
       res(i) = res(i)+values(k)
    end do
  end subroutine Sum

end module Nested

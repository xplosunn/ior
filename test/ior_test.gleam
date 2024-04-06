import gleeunit
import gleeunit/should
import ior.{Both, Left, Right}
import gleam/option.{None, Some}

pub fn main() {
  gleeunit.main()
}

pub fn is_left_test() {
  Left(1)
  |> ior.is_left()
  |> should.be_true()

  Right(1)
  |> ior.is_left()
  |> should.be_false()

  Both(1, 2)
  |> ior.is_left()
  |> should.be_false()
}

pub fn get_left_test() {
  Left(1)
  |> ior.get_left()
  |> should.equal(Some(1))

  Right(1)
  |> ior.get_left()
  |> should.equal(None)

  Both(1, 2)
  |> ior.get_left()
  |> should.equal(Some(1))
}

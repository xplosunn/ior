import gleam/option.{type Option, None, Some}

pub type Ior(left, right) {
  Left(val: left)
  Right(val: right)
  Both(left: left, right: right)
}

pub fn fold(
  ior: Ior(left, right),
  case_left: fn(left) -> new,
  case_right: fn(right) -> new,
  case_both: fn(left, right) -> new,
) -> new {
  case ior {
    Left(val) -> case_left(val)
    Right(val) -> case_right(val)
    Both(left, right) -> case_both(left, right)
  }
}

pub fn bimap(
  ior: Ior(left, right),
  left_map: fn(left) -> new_left,
  right_map: fn(right) -> new_right,
) -> Ior(new_left, new_right) {
  case ior {
    Left(val) -> Left(left_map(val))
    Right(val) -> Right(right_map(val))
    Both(left, right) -> Both(left_map(left), right_map(right))
  }
}

pub fn map(ior: Ior(left, right), f: fn(right) -> new) -> Ior(left, new) {
  case ior {
    Left(val) -> Left(val)
    Right(val) -> Right(f(val))
    Both(left, right) -> Both(left, f(right))
  }
}

pub fn left_map(ior: Ior(left, right), f: fn(left) -> new) -> Ior(new, right) {
  case ior {
    Left(val) -> Left(f(val))
    Right(val) -> Right(val)
    Both(left, right) -> Both(f(left), right)
  }
}

pub fn flat_map(
  ior: Ior(left, right),
  combine: fn(left, left) -> left,
  f: fn(right) -> Ior(left, new),
) -> Ior(left, new) {
  case ior {
    Left(val) -> Left(val)
    Right(val) -> f(val)
    Both(left, right) ->
      f(right)
      |> left_map(combine(left, _))
  }
}

pub fn combine(
  ior: Ior(left, right),
  ior2: Ior(left, right),
  combine_left: fn(left, left) -> left,
  combine_right: fn(right, right) -> right,
) -> Ior(left, right) {
  let left_map = case
    ior2
    |> get_left
  {
    Some(val) -> combine_left(_, val)
    None -> fn(val) { val }
  }
  let right_map = case
    ior2
    |> get_right
  {
    Some(val) -> combine_right(_, val)
    None -> fn(val) { val }
  }
  ior
  |> bimap(left_map, right_map)
}

pub fn put_left(ior: Ior(left, right), left: new) -> Ior(new, right) {
  case ior {
    Left(_) -> Left(left)
    Right(val) -> Both(left, val)
    Both(_, right) -> Both(left, right)
  }
}

pub fn put_right(ior: Ior(left, right), right: new) -> Ior(left, new) {
  case ior {
    Left(value) -> Both(value, right)
    Right(_) -> Right(right)
    Both(left, _) -> Both(left, right)
  }
}

pub fn is_left(ior: Ior(left, right)) -> Bool {
  case ior {
    Left(_) -> True
    _ -> False
  }
}

pub fn is_right(ior: Ior(left, right)) -> Bool {
  case ior {
    Right(_) -> True
    _ -> False
  }
}

pub fn is_both(ior: Ior(left, right)) -> Bool {
  case ior {
    Both(_, _) -> True
    _ -> False
  }
}

pub fn get_left(ior: Ior(left, right)) -> Option(left) {
  case ior {
    Left(val) -> Some(val)
    Right(_) -> None
    Both(left, _) -> Some(left)
  }
}

pub fn get_right(ior: Ior(left, right)) -> Option(right) {
  case ior {
    Left(_) -> None
    Right(val) -> Some(val)
    Both(_, right) -> Some(right)
  }
}

pub fn only_left(ior: Ior(left, right)) -> Option(left) {
  case ior {
    Left(val) -> Some(val)
    _ -> None
  }
}

pub fn only_right(ior: Ior(left, right)) -> Option(right) {
  case ior {
    Right(val) -> Some(val)
    _ -> None
  }
}

pub fn only_both(ior: Ior(left, right)) -> Option(#(left, right)) {
  case ior {
    Both(left, right) -> Some(#(left, right))
    _ -> None
  }
}

pub fn as_options(ior: Ior(left, right)) -> #(Option(left), Option(right)) {
  case ior {
    Left(val) -> #(Some(val), None)
    Right(val) -> #(None, Some(val))
    Both(left, right) -> #(Some(left), Some(right))
  }
}

pub fn swap(ior: Ior(left, right)) -> Ior(right, left) {
  case ior {
    Left(val) -> Right(val)
    Right(val) -> Left(val)
    Both(left, right) -> Both(right, left)
  }
}

pub fn exists(ior: Ior(left, right), predicate: fn(right) -> Bool) -> Bool {
  case
    ior
    |> get_right
  {
    Some(val) -> predicate(val)
    None -> False
  }
}

pub fn for_all(ior: Ior(left, right), predicate: fn(right) -> Bool) -> Bool {
  case
    ior
    |> get_right
  {
    Some(val) -> predicate(val)
    None -> True
  }
}

pub fn get_or_else(ior: Ior(left, right), default: right) -> right {
  case
    ior
    |> get_right
  {
    Some(val) -> val
    None -> default
  }
}

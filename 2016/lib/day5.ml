let hash id n = Digest.MD5.string (id ^ string_of_int n)

let char_from_hash hash =
  let hex = Digest.to_hex hash in
  if String.starts_with hex ~prefix:"00000" then Some (String.get hex 5) else None

let rec find_char id n =
  let hash = hash id n in
  match char_from_hash hash with Some c -> (c, n) | None -> find_char id (n + 1)

let rec find_password id password n =
  if String.length password = 8 then password
  else
    let c, n = find_char id n in
    let password = password ^ String.make 1 c in
    find_password id password (n + 1)

let part1 input = find_password input "" 0
let part2 _input = "not implemented"

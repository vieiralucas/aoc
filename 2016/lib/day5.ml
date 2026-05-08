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

let char_from_hash2 hash =
  let hex = Digest.to_hex hash in
  if String.starts_with hex ~prefix:"00000" then
    let pos = String.sub hex 5 1 |> int_of_string_opt in
    match pos with Some p when p < 8 -> Some (p, String.get hex 6) | _ -> None
  else None

let rec find_char2 id n =
  let hash = hash id n in
  match char_from_hash2 hash with
  | Some (p, c) -> (p, c, n)
  | None -> find_char2 id (n + 1)

let rec find_password2 id password n =
  let is_complete = List.find_opt (fun c -> c = '_') password |> Option.is_none in
  if is_complete then List.to_seq password |> String.of_seq
  else
    let p, c, n = find_char2 id n in
    let password =
      List.mapi (fun i curr -> if i = p && curr = '_' then c else curr) password
    in
    find_password2 id password (n + 1)

let part2 input = find_password2 input (List.init 8 (Fun.const '_')) 0

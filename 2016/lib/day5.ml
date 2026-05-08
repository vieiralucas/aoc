let md5 id n = Digest.MD5.string (id ^ string_of_int n)

let rec search id n pred =
  let h = md5 id n in
  match pred h with Some x -> (x, n) | None -> search id (n + 1) pred

let char_from_hash hash =
  let hex = Digest.to_hex hash in
  if String.starts_with hex ~prefix:"00000" then Some hex.[5] else None

let char_from_hash2 hash =
  let hex = Digest.to_hex hash in
  if String.starts_with hex ~prefix:"00000" then
    match hex.[5] with
    | '0' .. '7' as c -> Some (Char.code c - Char.code '0', hex.[6])
    | _ -> None
  else None

let rec update_at p c = function
  | [] -> ([], false)
  | x :: xs when p = 0 && x = '_' -> (c :: xs, true)
  | x :: xs ->
      let xs', did_write = update_at (p - 1) c xs in
      (x :: xs', did_write)

let part1 input =
  let rec loop acc count n =
    if count = 8 then List.rev acc |> List.to_seq |> String.of_seq
    else
      let c, n = search input n char_from_hash in
      loop (c :: acc) (count + 1) (n + 1)
  in
  loop [] 0 0

let part2 input =
  let rec loop password filled n =
    if filled = 8 then List.to_seq password |> String.of_seq
    else
      let (p, c), n = search input n char_from_hash2 in
      let password', did_write = update_at p c password in
      let filled' = if did_write then filled + 1 else filled in
      loop password' filled' (n + 1)
  in
  loop (List.init 8 (Fun.const '_')) 0 0

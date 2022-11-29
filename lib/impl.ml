module GraphImpl = struct
  type node = string
  type graph = node list * (node * node * int) list
  module NodeSet = Set.Make(String)
  let empty = ([], [])
  let is_empty g = g = empty
  let mem_vertex n g = match g with (nl, _) ->
    let find = List.find_opt (fun x -> x = n) nl in
    match find with
    | None -> (false, "")
    | Some(n) -> (true, n)
  let mem_edge (n1, n2, w) g = match g with (_, el) -> 
    let find = List.find_opt 
    (fun (n1', n2', w) -> (n1 = n1' && n2 = n2') || (n1 = n2' && n2 = n1')
    ) el in
    match find with
    | None -> (false, ("", "", 0))
    | Some(e) -> (true, e)
  let add_vertex n g = 
    let (exist, _) = mem_vertex n g in 
    if exist then g else
    match g with (nl, el) -> (n::nl, el)
  let add_edge (n1, n2, w) g = 
    let (exist, _) = mem_edge (n1, n2, w) g in
    if exist then g else
    let g = add_vertex n1 g in
    let g = add_vertex n2 g in
    match g with (nl, el) -> 
      (nl, (n1, n2, w)::el)
end

module PlanificateurImpl = Model.Planificateur(GraphImpl)
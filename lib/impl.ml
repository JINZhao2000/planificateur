module GraphImpl = struct
  type node = string
  type graph = node list * (node * node * int) list
  module NodeSet = Set.Make(String)
  module NodeMap = Map.Make(String)
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
  let succs n g = 
    let (res, _) = mem_vertex n g in
    if not res then NodeSet.empty else
      match g with (_, el) -> 
        List.fold_left 
        (fun acc (f, t, w) -> 
          if f = n then 
            NodeSet.add t acc 
          else if t = n then
            NodeSet.add f acc
          else
            acc) 
          NodeSet.empty el
  let print_graph g = match g with (nl, el) -> 
    let _ = List.fold_left (fun _ n -> output_string stdout @@ "Node : " ^ n ^ "\n") () nl in
    let _ = List.fold_left (fun _ (f, t, w) -> output_string stdout @@ "Edge : " ^ f ^ "-" ^ (string_of_int w) ^ "->" ^ t ^ "\n") () el in ()
  
  let dijkstra src dest g = 
    (* let (res1, _) = mem_vertex src g in
    let (res2, _) = mem_vertex dest g in
    if not (res1 && res2) then [] else
    match g with (nl, el) ->
    let dist = List.fold_left (fun d n -> NodeMap.add n (-1) d) NodeMap.empty nl in
    let prev = List.fold_left (fun p n -> NodeMap.add n "" p) NodeMap.empty nl in
    let q = nl in
    let dist = NodeMap.add src 0 dist in
    let dijkstra0 q dist prev = 
      if (List.length q = 0) then (dist, prev) else
        let (u, w) = List.fold_left (fun (n, w) curr -> 
          let w' = NodeMap.find curr dist in
          if w' < 0 || w' >= w then
            (n, w)
          else
            (curr, w')) ("", -1) q in
        let dist = NodeMap.remove u dist in
        (dist, []) in
        not finished *)
    []
end

module PlanificateurImpl = Model.Planificateur(GraphImpl)
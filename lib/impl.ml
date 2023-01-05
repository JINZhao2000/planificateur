module GraphImpl = struct
  type node = string
  module NodeSet = Set.Make(String)
  module NodeMap = Map.Make(String)
  
  type graph = NodeSet.t * (int NodeMap.t) NodeMap.t

  let empty = (NodeSet.empty, NodeMap.empty)

  let is_empty g = g = empty

  let mem_vertex n g = match g with (ns, _) -> 
    match NodeSet.find_opt n ns with
    | None -> (false, "")
    | Some(node) -> (true, node)

  let mem_edge (n1, n2, w) g = match g with (_, nm) ->
    if n1 = n2 then (false, ("", "", 0)) else
    match NodeMap.find_opt n1 nm with
    | None -> (false, ("", "", 0))
    | Some(nm') -> 
      begin match NodeMap.find_opt n2 nm' with
      | None -> (false, ("", "", 0))
      | Some(w') -> if w = w' then (true, (n1, n2, w)) else (false, ("", "", 0)) 
      end

  let add_vertex n g = match g with (ns, nm) -> 
    (NodeSet.add n ns, nm)

  let rec add_edge (n1, n2, w) g = match g with (ns, nm) ->
    let g' = match NodeMap.find_opt n1 nm with
    | None -> add_edge (n1, n2, w) (NodeSet.add n1 ns, NodeMap.add n1 NodeMap.empty nm)
    | Some(nm') -> 
      let m = NodeMap.add n2 w nm' in
      (ns, NodeMap.add n1 m nm)
    in
    match g' with (ns, nm) ->
      match NodeMap.find_opt n2 nm with
      | None -> add_edge (n1, n2, w) (NodeSet.add n2 ns, NodeMap.add n2 NodeMap.empty nm)
      | Some(nm') -> 
        let m = NodeMap.add n1 w nm' in
        (ns, NodeMap.add n2 m nm)

  let succs n g = 
    let (res, _) = mem_vertex n g in
    if res then
      match g with (ns, nm) ->
        match NodeMap.find_opt n nm with
        | None -> NodeSet.empty
        | Some(nm') -> NodeMap.fold (fun n _ acc -> NodeSet.add n acc) nm' NodeSet.empty
    else
      NodeSet.empty
    
  let print_graph g = match g with (ns, nm) -> 
    Printf.fprintf stdout "nodes:\n";
    NodeSet.fold (fun n _ -> Printf.fprintf stdout "\t%s\n" n) ns ();
    Printf.fprintf stdout "edges:\n";
    NodeMap.fold (fun n1 nm' _ -> 
      NodeMap.fold (fun n2 w _ ->
        Printf.fprintf stdout "\t%s->%s:%d\n" n1 n2 w;
      ) nm' ()
    ) nm ()

  let rec convert_path_list m acc src dest = 
    if src = dest then acc@[dest] else
    let next = NodeMap.find src m in
    convert_path_list m (acc@[src]) next dest
  
  let dijkstra src dest g = 
    let (res1, _) = mem_vertex src g in
    let (res2, _) = mem_vertex dest g in
    if not (res1 && res2) then [] else
    match g with (ns, nm) -> 
    let dist = NodeSet.fold (fun n acc -> NodeMap.add n (-1) acc) ns NodeMap.empty in
    let prev = NodeSet.fold (fun n acc -> NodeMap.add n "" acc) ns NodeMap.empty in
    let q = NodeSet.fold (fun n acc -> NodeSet.add n acc) ns NodeSet.empty in
    let dist = NodeMap.add src 0 dist in

    let find_min m =
      let (n, _) = NodeMap.fold (fun k v (mink, minv) -> 
        if v = -1 then (k, v)
        else if v < minv then (k, v)
        else (mink, minv)) m ("", -1) in n in
      
    let rec dij dist prev q = 
      if q = NodeSet.empty then
        (dist, prev)
      else
        let u = find_min dist in
        let q = NodeSet.remove u q in
        let neigh = succs u g in
        let neigh = NodeSet.filter (fun n -> NodeSet.mem n q) neigh in
        let (dist, prev) = NodeSet.fold (
          fun v (d, p) -> 
            let alt = NodeMap.find u d + NodeMap.find v (NodeMap.find u nm) in
            if alt < NodeMap.find v d then (NodeMap.add v alt d, NodeMap.add v u p) else (d, p)
        ) neigh (dist, prev) in
        dij dist prev q in
    let (_, prev) = dij dist prev q in
    convert_path_list prev [] src dest
end

module PlanificateurImpl = Model.Planificateur(GraphImpl)
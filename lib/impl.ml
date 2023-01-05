module GraphImpl = struct
  type node = string
  module NodeSet = Set.Make(String)
  module NodeMap = Map.Make(String)
  module IntSet = Set.Make(Int)
  
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

  let weight n1 n2 g = match g with (ns, nm) -> 
    let (res1, _) = mem_vertex n1 g in
    let (res2, _) = mem_vertex n2 g in
    if not (res1 && res2) then 0 else
      NodeMap.find n2 (NodeMap.find n1 nm)
  
  let dijkstra src dest g = 
    let (res1, _) = mem_vertex src g in
    let (res2, _) = mem_vertex dest g in
    if not (res1 && res2) then ([], 0) else
    match g with (ns, nm) -> 
    let dist = NodeSet.fold (fun n acc -> NodeMap.add n (Int.max_int / 2) acc) ns NodeMap.empty in
    let prev = NodeSet.fold (fun n acc -> NodeMap.add n "" acc) ns NodeMap.empty in
    let q = NodeSet.fold (fun n acc -> NodeSet.add n acc) ns NodeSet.empty in
    let dist = NodeMap.add src 0 dist in

    let find_min m s =
      let (k, _) = NodeSet.fold (
        fun k (mink, minv) -> 
          let v = NodeMap.find k m in
          if v < minv then
            (k, v)
          else
            (mink, minv)
      ) s ("", Int.max_int) in
      k in
      
    let rec dij dist prev q = 
      if q = NodeSet.empty then
        (dist, prev)
      else
        let u = find_min dist q in
        let q = NodeSet.remove u q in
        let neigh = succs u g in
        let neigh = NodeSet.filter (fun n -> NodeSet.mem n q) neigh in
        let (dist, prev) = NodeSet.fold (
          fun v (d, p) -> 
            let alt = NodeMap.find u d + NodeMap.find v (NodeMap.find u nm) in
            if alt < NodeMap.find v d then (NodeMap.add v alt d, NodeMap.add v u p) else (d, p)
        ) neigh (dist, prev) in
        dij dist prev q in

    let rec convert_path_list p acc src dest = 
    if src = dest then (src::acc) else
    let prev = NodeMap.find dest p in
    if prev = "" then raise Not_found else
      convert_path_list p (dest::acc) src prev in
    
    let (dist, prev) = dij dist prev q in
    (convert_path_list prev [] src dest, NodeMap.find dest dist)

  let min_time pathlst g = 
    let cal_priority timelst pathlst = 
      let tcnt = List.length timelst in
      let pcnt = List.length pathlst in
      int_of_float ((float_of_int (pcnt - tcnt) /. (float_of_int) pcnt) *. 100.) in

    let next_path timelst pathlst = 
      let tcnt = List.length timelst in
      let pcnt = List.length pathlst in
      if tcnt = pcnt then (false, "", "") else
        if tcnt = 0 then (true, List.nth pathlst 0, List.nth pathlst 1) else
        (true, List.nth pathlst (tcnt-1), List.nth pathlst (tcnt)) in

    let merge_next pvlst = 
      let map = NodeMap.empty in
      let pvilst = List.mapi (fun i (p, v) -> (i, p, v)) pvlst in
      let map = List.fold_left (
        fun acc (i, p, v) ->
          let (res, n1, n2) = next_path v p in
          let (n1, n2) = if compare n1 n2 > 0 then (n2, n1) else (n1, n2) in
          if not res then acc else
          if NodeMap.mem n1 acc then 
            let m2 = NodeMap.find n1 acc in
            if NodeMap.mem n2 m2 then
              let m2 = NodeMap.add n2 (i::NodeMap.find n2 m2) m2 in
              NodeMap.add n1 m2 acc
            else
              NodeMap.add n1 (NodeMap.add n2 [i] m2) acc
          else
            NodeMap.add n1 (NodeMap.add n2 [i] NodeMap.empty) acc
      ) map pvilst in
      NodeMap.fold (fun k v acc -> 
        NodeMap.fold (fun kin vin accin -> 
          if List.length vin < 2 then
            accin
          else
            (k, kin, vin)::accin
          ) v acc
        ) map [] in
    
    let is_end pvlst = 
      not (List.fold_left (fun acc (p, v) ->
        let (res, _, _) = next_path v p in
        acc || res) false pvlst) in

    let resolve (n1, n2, lst) pvlst = 
      let prios = List.fold_left (fun acc x -> 
        let (p, v) = List.nth pvlst x in
        (x, cal_priority v p)::acc) [] lst in
      let (lesmax, _) = List.fold_left (fun (ac, pc) (i, p) ->
        if pc < p then
          ([i], p)
        else if pc = p then
          (i::ac, pc)
        else
          (ac, pc)
        ) ([], 0) prios in
      let max = List.fold_left (
        fun acc x -> 
        let (p, v) = List.nth pvlst x in
        let (res, n1, n2) =  (next_path (0::v) p) in
        if res then
          if weight n1 n2 g > acc then x else acc
        else
          acc
      ) 0 lesmax in
      max in  

    let rec calcul pvlst = 
      if is_end pvlst then pvlst else
      let nxts = merge_next pvlst in
      let (s1, s2) = List.fold_left (
        fun (acs, acn) (n1, n2, l) ->
          let s = resolve (n1, n2, l) pvlst in
          let acs = IntSet.add s acs in
          (acs, List.fold_left (fun acc x -> if not (IntSet.mem x acs) then IntSet.add x acc else acc) acn l)
      ) (IntSet.empty, IntSet.empty) nxts in
      let pvilst = List.mapi (fun i (p, v) -> (i, p, v)) pvlst in
      let pvlst = List.fold_left (fun acc (i, p, v) -> 
        if IntSet.mem i s2 then
          (p, v)::acc
        else
          let (res, n1, n2) = next_path v p in
          if not(res) then (p, v)::acc
          else if v=[] then (p, [0])::acc
          else (p, (weight n1 n2 g + List.hd v)::v)::acc
      ) [] pvilst in
      calcul pvlst in

    let pathvaluelst = List.fold_left (fun acc x -> (List.rev x, [])::acc) [] pathlst in
    calcul pathvaluelst
end

module PlanificateurImpl = Model.Planificateur(GraphImpl)
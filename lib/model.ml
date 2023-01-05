exception Not_found

module type Graph = sig
  module NodeSet : Set.S
  module NodeMap : Map.S
  type node 
  type graph
  val empty: graph
  val is_empty : graph -> bool
  val add_vertex: node -> graph -> graph
  val add_edge: node * node * int -> graph -> graph
  val succs : node -> graph -> NodeSet.t
  val dijkstra : node -> node -> graph -> node list * int
  val min_time : node list list -> graph -> (node list * int list) list
end

module type S = sig
  type elt
  type t
  val empty : t
  val is_empty : t -> bool
  val add_transactions : (elt * elt * int) list -> t -> t
  val phase1 : (elt * elt * int) list * (elt * elt) -> elt list * int
  val phase2 : (elt * elt * int) list * elt list list -> (elt list * int list) list * int
end

module Planificateur(G:Graph) = struct 
  type elt = G.node
  type t = G.graph

  let empty = G.empty

  let is_empty t = G.is_empty t

  let rec add_transactions el g = match el with
  | [] -> g
  | h::t -> add_transactions t @@ G.add_edge h g

  let phase1 (t, (src, dest)) = 
    let g = add_transactions t empty in
    G.dijkstra src dest g

  let phase2 (t, plst) = 
    let g = add_transactions t empty in
    let lst = G.min_time plst g in
    let time = List.fold_left (fun acc (_, x) ->
      let localt = List.hd x in
      if localt > acc then
        localt
      else
        acc) 0 lst in
    (List.map (fun (el, tl) -> 
      let tl = List.map (fun x -> time - x) tl in
      let tl = List.rev (List.tl (List.rev tl)) in 
      let el = List.rev el in
      (el, tl)
      )) lst, time
end
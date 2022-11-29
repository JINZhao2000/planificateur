exception Not_found

module type Graph = sig
  type node 
  type graph
  module NodeSet : Set.S with type elt = node
  val empty: graph
  val is_empty : graph -> bool
  val add_vertex: node -> graph -> graph
  val add_edge: node * node * int -> graph -> graph
end

module type S = sig
  type elt
  type t
  val empty : t
  val is_empty : t -> bool
  val add_transactions : (elt * elt * int) list -> t -> t
end

module Planificateur(G:Graph) = struct 
  type elt = G.node
  type t = G.graph

  let empty = G.empty
  let is_empty t = G.is_empty t
  let rec add_transactions el g = match el with
  | [] -> g
  | h::t -> add_transactions t @@ G.add_edge h g
end
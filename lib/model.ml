exception Not_found

module type Graph = sig
  type node 
  type graph
  module NodeSet : Set.S with type elt = node
  val empty: graph
  val is_empty : graph -> bool
  val add_vertex: node -> graph -> graph
  val add_edge: node * node * int -> graph -> graph
  (* val succs : node -> graph -> NodeSet.t *)
end

module type S = sig
  type elt
  type t
end

module GraphImpl = struct
  type node = string
  type graph = node list * (node * node * int) list
  module NodeSet = Set.Make(String)
  let empty = ([], [])
  let is_empty g = g = empty
  let add_vertex n g = failwith "not inplemented"
  let add_edge (n1, n2, w) g = failwith "not inplemented"
  let add_vertex n g = failwith "not inplemented"
end

module Planificateur(G:Graph) = struct 
  type elt = G.node
  type t = G.graph
end

module PlanificateurImpl = Planificateur(GraphImpl)
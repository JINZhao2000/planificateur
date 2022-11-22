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

module Planificateur(G:Graph):S with type elt = G.node
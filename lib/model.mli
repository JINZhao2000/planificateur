exception Not_found

(** data structure graph *)
module type Graph = sig

    (** type node *)
    type node 

    (** type graph*)
    type graph

    (** data structure set of node *)
    module NodeSet : Set.S

    (** data structure map of node *)
    module NodeMap : Map.S

    (** @return new empty graph *)
    val empty : graph

    (** verify if a graph is empty
        @param g a graph
        @return true if graph is empty *)
    val is_empty : graph -> bool

    (** add a vertex into a graph [add_vertex n g]
        @param n a node
        @param g a graph
        @return a new graph with node n added *)
    val add_vertex : node -> graph -> graph

    (** add a edge into a graph [add_edge (n1, n2, w) g]
        @param n1 first node
        @param n2 second node
        @param w weight of edge
        @param g a graph
        @return a new graph with edge (n1, n2, w) added *)
    val add_edge : node * node * int -> graph -> graph

    (** find the successor of a node [succs n g]
        @param n a node
        @param g a graph
        @return a set of seccessor of node n *)
    val succs : node -> graph -> NodeSet.t

    (** find the shortest path [dijkstra n1 n2 g]
        @param n1 start
        @param n2 end
        @param g a graph
        @return the node list of path *)
    val dijkstra : node -> node -> graph -> node list * int 

    (** calculate the minimun time with the path declared 
        @param plst a list of path declared
        @param g a graph
        @return a list of path with begin time *)
    val min_time : node list list -> graph -> (node list * int list) list
end

(** T interface *)
module type S = sig

    (** type of element *)
    type elt

    (** type of collection *)
    type t

    (** @return an empty collection *)
    val empty : t

    (** verify if a collection is empty [is_empty t]
        @param t a collection
        @return if a collection is empty *)
    val is_empty : t -> bool

    (** add the path exists [add_transactions tlst t]
        @param l a list of data to add
        @param t the collection
        @return new collection with added elements *)
    val add_transactions : (elt * elt * int) list -> t -> t

    (** phase 1 find the shortest path for individual
        @param t the path
        @param ss the start point and the end point 
        @return p the shortest path list and time
        @raise Not_found when the path doesn't exist *)
    val phase1 : (elt * elt * int) list * (elt * elt) -> elt list * int

    (** phase 2 find the begin of path no conflicts
        @param t the path
        @param plst a list of path declared
        @param g a graph
        @return a list of path with begin time and the total time*)
    val phase2 : (elt * elt * int) list * elt list list -> (elt list * int list) list * int
end

module Planificateur(G:Graph):S with type elt = G.node
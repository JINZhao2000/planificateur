open Planificateur
open Impl
open OUnit2

let suite1 = 
  "Graph" >::: [
    "empty graph" >:: (fun _ -> assert_bool "graph not empty" (GraphImpl.(is_empty empty)));
    "not empty graph" >:: (fun _ -> assert_bool "graph empty" (not GraphImpl.(empty |> add_vertex "a"|> is_empty)));
    "no vertex" >:: (fun _ -> assert_bool "graph with node" (GraphImpl.(let (res, _) = empty |> mem_vertex "a" in not res)));
    "has vertex" >:: (fun _ -> assert_bool "graph without node" (GraphImpl.(let (res, _) = empty |> add_vertex "a" |> mem_vertex "a" in res)));
    "no edge" >:: (fun _ -> assert_bool "graph with edge" (GraphImpl.(let (res, _) = empty |> mem_edge ("a", "b", 1) in not res)));
    "has vertex src of edge" >:: (fun _ -> assert_bool "graph without vertex of edge" (GraphImpl.(let (res, _) = empty |> add_edge ("a", "b", 1) |> mem_vertex "a" in res)));
    "has vertex dest of edge" >:: (fun _ -> assert_bool "graph without vertex of edge" (GraphImpl.(let (res, _) = empty |> add_edge ("a", "b", 1) |> mem_vertex "b" in res)));
    "has edge" >:: (fun _ -> assert_bool "graph without edge" (GraphImpl.(let (res, _) = empty |> add_edge ("a", "b", 1) |> mem_edge ("a", "b", 1) in res)));
    "has edge" >:: (fun _ -> assert_bool "graph without inversed edge" (GraphImpl.(let (res, _) = empty |> add_edge ("a", "b", 1) |> mem_edge ("b", "a", 1) in res)));
    "no succs" >:: (fun _ -> assert_equal GraphImpl.NodeSet.empty (GraphImpl.(empty |> succs "a")));
    "no succs2" >:: (fun _ -> assert_equal GraphImpl.NodeSet.empty (GraphImpl.(empty |> add_vertex "a" |>succs "a")));
    "has succs" >:: (fun _ -> assert_equal GraphImpl.NodeSet.(empty |> add "b") (GraphImpl.(empty |> add_edge ("a", "b", 1) |>succs "a")));
    "has succs2" >:: (fun _ -> assert_equal GraphImpl.NodeSet.(empty |> add "a") (GraphImpl.(empty |> add_edge ("a", "b", 1) |>succs "b")))
  ]

(* let (path1, t1) = PlanificateurImpl.phase1 (Analyse.analyse_file_1 "../dataset/entry1")
let (path2, t2) = PlanificateurImpl.phase1 (Analyse.analyse_file_1 "./dataset/entry2")

let suite2 = 
  "Phase1" >::: [
    "path1" >:: (fun _ -> assert_equal path1 ["a"; "c"]);
    "time1" >:: (fun _ -> assert_equal 2 t1);
    "path2" >:: (fun _ -> assert_equal path2 ["a"; "c"; "e"]);
    "time2" >:: (fun _ -> assert_equal 8 t2);
  ] *)

let _ = run_test_tt_main suite1
(* let _ = run_test_tt_main suite2 *)
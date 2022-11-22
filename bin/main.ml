open Planificateur

let (t, ss) = Analyse.analyse_file_1 "./dataset/entry1"
let _ = 
  List.fold_left (fun _ (b, e, t) -> output_string stdout @@ b ^ ", " ^ e ^ ", " ^ string_of_int t ^ "\n") () t;
  match ss with (start, stop) -> output_string stdout @@ start ^ ", " ^ stop ^ "\n"

let _ = Analyse.output_sol_1 2 ["a"; "c"]
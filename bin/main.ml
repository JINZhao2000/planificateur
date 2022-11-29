open Planificateur
open Impl
let argc = Array.length Sys.argv
let _ = 
  if argc = 3 then
    let file = Array.get Sys.argv 1 in
    let phase = int_of_string @@ Array.get Sys.argv 2 in
    if phase = 1 then
      let (t, ss) = Analyse.analyse_file_1 file in
      let _ = PlanificateurImpl.(add_transactions t empty) in
      let _ = 
        List.fold_left (fun _ (b, e, t) -> output_string stdout @@ b ^ ", " ^ e ^ ", " ^ string_of_int t ^ "\n") () t;
        match ss with (start, stop) -> output_string stdout @@ start ^ ", " ^ stop ^ "\n" in
      let _ = Analyse.output_sol_1 2 ["a"; "c"] in ()
    else if phase = 2 then ()
    else if phase = 3 then ()
    else
      failwith "The phase is not a right number"
  else
    output_string stdout "\nUsage : dune exec planificateur <arg1> <arg2>
    <arg1> : The first argument is a file of plan
    <arg2> : The second argument is the number of phase
    \tit should be 1, 2, or 3\n";
    exit 0

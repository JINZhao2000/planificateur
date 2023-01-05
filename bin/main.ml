open Planificateur
open Impl
let argc = Array.length Sys.argv
let _ = 
  if argc = 3 then
    let file = Array.get Sys.argv 2 in
    let phase = int_of_string @@ Array.get Sys.argv 1 in
    if phase = 1 then
      let (path, t) = PlanificateurImpl.phase1 (Analyse.analyse_file_1 file) in
      let _ = Analyse.output_sol_1 t path in ()
    else if phase = 2 then
      let (path, time) = PlanificateurImpl.phase2 (Analyse.analyse_file_2 file) in
      let _ = Analyse.output_sol_2 path in
      let _ = Printf.fprintf stdout "%d\n" time; in ()
    else if phase = 3 then ()
    else
      Printf.fprintf stderr "The phase is not a right number it should be 1, 2, or 3\n";
      exit 0
  else
    Printf.fprintf stdout "\nUsage :
    dune exec planificateur <arg1> <arg2>
    make run PHASE=<arg1> FILE=<arg2>
    <arg1> : The second argument is the number of phase, it should be 1, 2, or 3
    <arg2> : The first argument is a file of plan\n";
    Printf.fprintf stdout "Make options :
    build : build project
    run   : run project
    doc   : generate document
    test  : test project
    clean : clean project\n";
    exit 0

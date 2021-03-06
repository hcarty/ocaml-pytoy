let add_toy_python_module () =
  (* A global module that we expose our OCaml functions through *)
  let pymod = Py.Import.add_module "toy" in

  (* Expose a toy function for testing *)
  let good_fun s = String.uppercase_ascii s in
  let good_fun_py py_args =
    Py.String.of_string (good_fun (Py.String.to_string py_args.(0)))
  in
  Py.Module.set_function pymod "good_fun" good_fun_py;

  (* Add an empty dictionary that Python code can manipulate *)
  Py.Module.set pymod "setme" (Py.Dict.create ())

let get_py_fun filename =
  let pymod_name = Filename.basename filename |> Filename.chop_extension in
  let pymod = Py.import pymod_name in
  Py.Module.get_function pymod "runme"

let load_and_run_py file =
  let py = get_py_fun file in
  let result = py [||] in
  if Py.is_none result then
    print_endline "None"
  else
    print_endline "Something..."

let () =
  Py.initialize ();
  add_toy_python_module ();
  load_and_run_py "a.py";
  load_and_run_py "b.py";
  load_and_run_py "c.py"

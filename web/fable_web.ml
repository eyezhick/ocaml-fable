open Js_of_ocaml
open Js_of_ocaml_lwt
open Fable.DSL

let doc = Dom_html.document
let by_id id = Js.Opt.get (doc##getElementById (Js.string id)) (fun () -> assert false)

let set_text id txt =
  let el = by_id id in
  el##.textContent := Js.Opt.return (Js.string txt)

let clear_choices () =
  let choices = by_id "choices" in
  choices##.innerHTML := Js.string ""

let add_choice text callback =
  let choices = by_id "choices" in
  let btn = doc##createElement (Js.string "button") in
  btn##.textContent := Js.Opt.return (Js.string text);
  Dom_html.addEventListener btn Dom_html.Event.click (Dom_html.handler (fun _ -> callback (); Js._false)) Js._false |> ignore;
  Dom.appendChild choices btn

let rec run_story node state =
  match node with
  | Say text ->
      set_text "story" text;
      clear_choices ();
      add_choice "Continue" (fun () -> run_story (Seq []) state)
  | Sayf (template, vars) ->
      set_text "story" (Fable.DSL.render_template template vars);
      clear_choices ();
      add_choice "Continue" (fun () -> run_story (Seq []) state)
  | Choice options ->
      set_text "story" "What would you like to do?";
      clear_choices ();
      List.iter (fun (text, f) -> add_choice text (fun () -> run_story (f ()) state)) options
  | RandomChoice options ->
      let total = List.fold_left (fun acc (p, _, _) -> acc +. p) 0.0 options in
      let r = Random.float total in
      let rec pick acc = function
        | [] -> failwith "No random choice available"
        | (p, text, f) :: rest ->
            if r < acc +. p then (text, f) else pick (acc +. p) rest
      in
      let (_text, action) = pick 0.0 options in
      run_story (action ()) state
  | Seq nodes ->
      (match nodes with
      | [] -> set_text "story" ""; clear_choices ()
      | hd :: tl -> run_story hd state; if tl <> [] then add_choice "Next" (fun () -> run_story (Seq tl) state))
  | SetTrait _ | MoveTo _ | SetFlag _ | AddInventory _ | RemoveInventory _ | Effect _ ->
      run_story (Seq []) state
  | IfFlag (_, yes, no) -> run_story yes state (* Simplified for demo *)
  | End text ->
      set_text "story" (text ^ "\nThe End.");
      clear_choices ()

let () =
  let open Dom_html in
  let story =
    seq [
      say "You wake up in a web-based cave!";
      choice [
        ("Click the torch", fun () ->
          seq [
            say "The web glows with OCaml magic.";
            end_story "You have illuminated the browser!"
          ]);
        ("Refresh the page", fun () ->
          end_story "The story resets...")
      ]
    ]
  in
  Dom_html.window##.onload := Dom_html.handler (fun _ ->
    run_story story Fable.DSL.initial_state;
    Js._false
  ) 
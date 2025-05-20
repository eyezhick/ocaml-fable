open Js_of_ocaml
open Js_of_ocaml_lwt
open Fable.DSL

let doc = Dom_html.document
let by_id id = Js.Opt.get (doc##getElementById (Js.string id)) (fun () -> assert false)

let set_text id txt =
  let el = by_id id in
  el##.textContent := Js.Opt.return (Js.string txt)

let add_class id cls =
  let el = by_id id in
  el##.classList##add (Js.string cls)

let remove_class id cls =
  let el = by_id id in
  el##.classList##remove (Js.string cls)

let clear_choices () =
  let choices = by_id "choices" in
  choices##.innerHTML := Js.string ""

let add_choice text callback =
  let choices = by_id "choices" in
  let btn = doc##createElement (Js.string "button") in
  btn##.classList##add (Js.string "choice-btn");
  btn##.textContent := Js.Opt.return (Js.string text);
  Dom_html.addEventListener btn Dom_html.Event.click (Dom_html.handler (fun _ -> callback (); Js._false)) Js._false |> ignore;
  Dom.appendChild choices btn

let update_mood_display character mood =
  let mood_display = by_id "mood-display" in
  let mood_text = Printf.sprintf "%s is feeling %s (intensity: %d)" character.name mood.name mood.intensity in
  mood_display##.textContent := Js.Opt.return (Js.string mood_text);
  add_class "mood-display" "active"

let update_inventory_display character =
  let inventory = by_id "inventory" in
  let items = String.concat ", " character.inventory in
  inventory##.textContent := Js.Opt.return (Js.string items)

let show_save_dialog () =
  let save_dialog = by_id "save-dialog" in
  save_dialog##.style##.display := Js.string "block"

let hide_save_dialog () =
  let save_dialog = by_id "save-dialog" in
  save_dialog##.style##.display := Js.string "none"

let show_load_dialog () =
  let load_dialog = by_id "load-dialog" in
  load_dialog##.style##.display := Js.string "block"

let hide_load_dialog () =
  let load_dialog = by_id "load-dialog" in
  load_dialog##.style##.display := Js.string "none"

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
  | SetTrait (character, trait) ->
      update_inventory_display character;
      run_story (Seq []) state
  | SetMood (character, mood) ->
      update_mood_display character mood;
      run_story (Seq []) state
  | MoveTo location ->
      set_text "location" location.name;
      run_story (Seq []) state
  | SetFlag _ | IfFlag _ | IfMood _ ->
      run_story (Seq []) state
  | AddInventory (character, _) | RemoveInventory (character, _) ->
      update_inventory_display character;
      run_story (Seq []) state
  | Effect eff ->
      (match eff with
      | Print msg -> set_text "effects" msg
      | Sound s -> set_text "effects" ("[Sound] " ^ s)
      | Custom (tag, json) -> set_text "effects" ("[Custom effect: " ^ tag ^ "] " ^ Yojson.Safe.to_string json));
      run_story (Seq []) state
  | SaveState name ->
      show_save_dialog ();
      run_story (Seq []) state
  | LoadState name ->
      show_load_dialog ();
      run_story (Seq []) state
  | End text ->
      set_text "story" (text ^ "\nThe End.");
      clear_choices ();
      add_choice "Start Over" (fun () -> run_story story Fable.DSL.initial_state)

let () =
  let open Dom_html in
  let story =
    seq [
      say "Welcome to the enhanced Fable story system!";
      choice [
        ("Begin your adventure", fun () ->
          seq [
            say "You find yourself in a mysterious room with three doors.";
            choice [
              ("Open the red door", fun () ->
                seq [
                  say "The red door leads to a room filled with ancient artifacts.";
                  set_mood (create_character "Player" [] []) (create_mood "curious" 5 [("discover", 0.8)]);
                  choice [
                    ("Examine the artifacts", fun () ->
                      seq [
                        say "You discover a magical amulet!";
                        add_inventory (create_character "Player" [] []) "Magical Amulet";
                        end_story "Your adventure has just begun..."
                      ]);
                    ("Leave the room", fun () ->
                      end_story "You decide to explore elsewhere...")
                  ]
                ]);
              ("Open the blue door", fun () ->
                seq [
                  say "The blue door reveals a peaceful garden.";
                  set_mood (create_character "Player" [] []) (create_mood "calm" 3 [("heal", 0.6)]);
                  end_story "You find tranquility in the garden..."
                ]);
              ("Open the green door", fun () ->
                seq [
                  say "The green door opens to a dark forest.";
                  set_mood (create_character "Player" [] []) (create_mood "cautious" 4 [("stealth", 0.7)]);
                  end_story "The forest awaits your exploration..."
                ])
            ]
          ]);
        ("Save your progress", fun () ->
          save_state "autosave");
        ("Load previous game", fun () ->
          load_state "autosave")
      ]
    ]
  in
  Dom_html.window##.onload := Dom_html.handler (fun _ ->
    run_story story Fable.DSL.initial_state;
    Js._false
  ) 
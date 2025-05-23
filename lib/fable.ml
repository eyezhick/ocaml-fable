open Base
open Stdlib

(* Core types for our narrative DSL *)

type trait = {
  name: string;
  value: int;
  description: string;
} [@@deriving show, eq, yojson]

type character = {
  name: string;
  traits: trait list;
  inventory: string list;
} [@@deriving show, eq, yojson]

type location = {
  name: string;
  description: string;
  connections: string list;
} [@@deriving show, eq, yojson]

type flag = string * bool

type effect =
  | Print of string
  | Sound of string
  | Custom of string * Yojson.Safe.t

type mood = {
  name: string;
  intensity: int;
  effects: (string * float) list;  (* (effect_name, probability) *)
} [@@deriving show, eq, yojson]

(* New: Probabilistic choice, flags, effects, and templating *)
type 'a story_node =
  | Say of string
  | Sayf of string * (string * string) list (* templated say *)
  | Choice of (string * (unit -> 'a story_node)) list
  | RandomChoice of (float * string * (unit -> 'a story_node)) list
  | Seq of 'a story_node list
  | SetTrait of character * trait
  | SetMood of character * mood
  | MoveTo of location
  | SetFlag of string * bool
  | IfFlag of string * 'a story_node * 'a story_node
  | IfMood of character * string * 'a story_node * 'a story_node
  | AddInventory of character * string
  | RemoveInventory of character * string
  | Effect of effect
  | SaveState of string
  | LoadState of string
  | End of string
[@@deriving show, eq]

(* Helper functions for creating story elements *)
let say text = Say text
let sayf template vars = Sayf (template, vars)
let choice options = Choice options
let random_choice options = RandomChoice options
let seq nodes = Seq nodes
let set_trait character trait = SetTrait (character, trait)
let move_to location = MoveTo location
let set_flag name value = SetFlag (name, value)
let if_flag name yes no = IfFlag (name, yes, no)
let add_inventory character item = AddInventory (character, item)
let remove_inventory character item = RemoveInventory (character, item)
let effect eff = Effect eff
let end_story text = End text

(* Story execution monad *)
type 'a story_state = {
  current_location: location option;
  characters: character list;
  visited_nodes: string list;
  flags: (string, bool) Hashtbl.t;
  moods: (string, mood) Hashtbl.t;
  rng: Random.State.t;
  story_history: string list;
}

let initial_state = {
  current_location = None;
  characters = [];
  visited_nodes = [];
  flags = Hashtbl.create (module String);
  moods = Hashtbl.create (module String);
  rng = Random.State.make_self_init ();
  story_history = [];
}

let render_template template vars =
  List.fold_left vars ~init:template ~f:(fun acc (k, v) ->
    Str.global_replace (Str.regexp ("{{" ^ k ^ "}}")) v acc)

(* Story interpreter with new features *)
let rec interpret_node node state =
  match node with
  | Say text ->
      print_endline text;
      state
  | Sayf (template, vars) ->
      print_endline (render_template template vars);
      state
  | Choice options ->
      print_endline "\nWhat would you like to do?";
      List.iteri options ~f:(fun i (text, _) ->
        Printf.printf "%d. %s\n" (i + 1) text);
      let choice = read_line () |> Int.of_string in
      let (_, action) = List.nth_exn options (choice - 1) in
      interpret_node (action ()) state
  | RandomChoice options ->
      let total = List.fold_left options ~init:0.0 ~f:(fun acc (p, _, _) -> acc +. p) in
      let r = Random.State.float state.rng total in
      let rec pick acc = function
        | [] -> failwith "No random choice available"
        | (p, text, f) :: rest ->
            if r < acc +. p then (text, f) else pick (acc +. p) rest
      in
      let (text, action) = pick 0.0 options in
      print_endline ("Random event: " ^ text);
      interpret_node (action ()) state
  | Seq nodes ->
      List.fold nodes ~init:state ~f:interpret_node
  | SetTrait (character, trait) ->
      { state with
        characters = List.map state.characters ~f:(fun c ->
          if String.equal c.name character.name
          then { c with traits = trait :: c.traits }
          else c)
      }
  | SetMood (character, mood) ->
      Hashtbl.set state.moods ~key:character.name ~data:mood;
      { state with
        story_history = Printf.sprintf "Mood changed: %s is now %s" character.name mood.name :: state.story_history
      }
  | MoveTo location ->
      { state with current_location = Some location }
  | SetFlag (name, value) ->
      Hashtbl.set state.flags ~key:name ~data:value;
      state
  | IfFlag (name, yes, no) ->
      let v = Hashtbl.find state.flags name |> Option.value ~default:false in
      interpret_node (if v then yes else no) state
  | IfMood (character, mood_name, yes, no) ->
      let current_mood = Hashtbl.find state.moods character.name in
      let has_mood = match current_mood with
        | Some m -> String.equal m.name mood_name
        | None -> false
      in
      interpret_node (if has_mood then yes else no) state
  | AddInventory (character, item) ->
      { state with
        characters = List.map state.characters ~f:(fun c ->
          if String.equal c.name character.name
          then { c with inventory = item :: c.inventory }
          else c)
      }
  | RemoveInventory (character, item) ->
      { state with
        characters = List.map state.characters ~f:(fun c ->
          if String.equal c.name character.name
          then { c with inventory = List.filter c.inventory ~f:(fun i -> not (String.equal i item)) }
          else c)
      }
  | Effect eff ->
      (match eff with
      | Print msg -> print_endline ("[Effect] " ^ msg)
      | Sound s -> print_endline ("[Sound] " ^ s)
      | Custom (tag, json) -> print_endline ("[Custom effect: " ^ tag ^ "] " ^ Yojson.Safe.to_string json));
      state
  | SaveState name ->
      let state_json = Yojson.Safe.to_string (state_to_yojson state) in
      let filename = Printf.sprintf "saves/%s.json" name in
      let oc = open_out filename in
      output_string oc state_json;
      close_out oc;
      { state with
        story_history = Printf.sprintf "Game saved: %s" name :: state.story_history
      }
  | LoadState name ->
      let filename = Printf.sprintf "saves/%s.json" name in
      let ic = open_in filename in
      let state_json = really_input_string ic (in_channel_length ic) in
      close_in ic;
      let loaded_state = state_of_yojson (Yojson.Safe.from_string state_json) in
      { loaded_state with
        story_history = Printf.sprintf "Game loaded: %s" name :: loaded_state.story_history
      }
  | End text ->
      print_endline text;
      print_endline "\nThe End.";
      exit 0

let create_character name traits inventory =
  { name; traits; inventory }

let create_location name description connections =
  { name; description; connections }

let create_trait name value description =
  { name; value; description }

let create_mood name intensity effects =
  { name; intensity; effects }

module DSL = struct
  let say = say
  let sayf = sayf
  let choice = choice
  let random_choice = random_choice
  let seq = seq
  let set_trait = set_trait
  let move_to = move_to
  let set_flag = set_flag
  let if_flag = if_flag
  let add_inventory = add_inventory
  let remove_inventory = remove_inventory
  let effect = effect
  let end_story = end_story
  let create_character = create_character
  let create_location = create_location
  let create_trait = create_trait
  let interpret_node = interpret_node
  let set_mood = SetMood
  let if_mood = IfMood
  let save_state = SaveState
  let load_state = LoadState
  let create_mood = create_mood
end 
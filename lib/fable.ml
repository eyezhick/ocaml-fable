open Base

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

type 'a story_node =
  | Say of string
  | Choice of (string * (unit -> 'a story_node)) list
  | Seq of 'a story_node list
  | SetTrait of character * trait
  | MoveTo of location
  | End of string
[@@deriving show, eq]

(* Helper functions for creating story elements *)

let say text = Say text

let choice options = Choice options

let seq nodes = Seq nodes

let set_trait character trait = SetTrait (character, trait)

let move_to location = MoveTo location

let end_story text = End text

(* Story execution monad *)
type 'a story_state = {
  current_location: location option;
  characters: character list;
  visited_nodes: string list;
}

let initial_state = {
  current_location = None;
  characters = [];
  visited_nodes = [];
}

(* Story interpreter *)
let rec interpret_node node state =
  match node with
  | Say text ->
      print_endline text;
      state
  | Choice options ->
      print_endline "\nWhat would you like to do?";
      List.iteri options ~f:(fun i (text, _) ->
        Printf.printf "%d. %s\n" (i + 1) text);
      let choice = read_line () |> Int.of_string in
      let (_, action) = List.nth_exn options (choice - 1) in
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
  | MoveTo location ->
      { state with current_location = Some location }
  | End text ->
      print_endline text;
      print_endline "\nThe End.";
      exit 0

(* Example story creation helpers *)
let create_character name traits inventory =
  { name; traits; inventory }

let create_location name description connections =
  { name; description; connections }

let create_trait name value description =
  { name; value; description }

(* Export the DSL interface *)
module DSL = struct
  let say = say
  let choice = choice
  let seq = seq
  let set_trait = set_trait
  let move_to = move_to
  let end_story = end_story
  let create_character = create_character
  let create_location = create_location
  let create_trait = create_trait
  let interpret_node = interpret_node
end 
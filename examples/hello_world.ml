open Fable.DSL

(* Create our story world *)
let player = create_character "Hero" [] ["torch"; "map"]
let cave = create_location "Dark Cave" "A mysterious cave with ancient runes on the walls" ["entrance"; "tunnel"]
let bravery = create_trait "Bravery" 5 "Your courage in the face of danger"

(* Define our story *)
let explore_cave () =
  seq [
    say "The cave stretches deeper into the mountain. Your torch casts long shadows on the walls.";
    choice [
      ("Study the runes", fun () ->
        seq [
          say "The runes tell a story of an ancient civilization that worshipped a powerful artifact.";
          set_trait player bravery;
          say "You feel a surge of courage as you decipher the ancient text.";
          end_story "You've uncovered the first piece of the ancient mystery."
        ]);
      ("Continue deeper", fun () ->
        seq [
          say "The tunnel narrows, and you must squeeze through a tight passage.";
          say "On the other side, you find a small chamber with a glowing crystal.";
          end_story "The crystal's light reveals a hidden treasure map carved into the floor."
        ])
    ]
  ]

let story =
  seq [
    say "You wake up in a dark cave, the air thick with mystery.";
    say "Your torch flickers, casting dancing shadows on the walls.";
    choice [
      ("Light your torch", fun () -> 
        seq [
          say "The flickering light reveals ancient runes on the wall.";
          explore_cave ()
        ]);
      ("Feel your way in the dark", fun () ->
        seq [
          say "Your hands touch something cold and metallic...";
          say "It's an old sword!";
          set_trait player bravery;
          say "You feel more confident with the sword in your hand.";
          explore_cave ()
        ])
    ]
  ]

(* Run the story *)
let () =
  print_endline "Welcome to Fable: The Cave of Mysteries\n";
  ignore (interpret_node story initial_state) 
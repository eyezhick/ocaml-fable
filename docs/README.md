# 🦊 Fable DSL Documentation

Welcome to the Fable DSL documentation! Here you'll learn how to create your own interactive stories using our functional programming approach to narrative design.

## Core Concepts

### Story Nodes

The basic building blocks of your story are nodes. Each node represents a piece of your narrative:

- `Say text`: Display text to the player
- `Choice options`: Present choices to the player
- `Seq nodes`: Sequence multiple nodes together
- `SetTrait character trait`: Modify a character's traits
- `MoveTo location`: Change the current location
- `End text`: End the story with a final message

### Characters

Characters are the actors in your story. They have:
- A name
- A list of traits
- An inventory

```ocaml
let hero = create_character "Hero" [] ["sword"; "shield"]
```

### Traits

Traits represent character attributes that can change during the story:

```ocaml
let bravery = create_trait "Bravery" 5 "Your courage in the face of danger"
```

### Locations

Locations are places in your story world:

```ocaml
let cave = create_location "Dark Cave" 
  "A mysterious cave with ancient runes on the walls" 
  ["entrance"; "tunnel"]
```

## Writing Stories

### Basic Story Structure

Here's a simple story:

```ocaml
let story =
  seq [
    say "Once upon a time...";
    choice [
      ("Go left", fun () -> say "You found a treasure!");
      ("Go right", fun () -> say "You found a monster!");
    ]
  ]
```

### Creating Branches

You can create complex story branches using nested choices:

```ocaml
let explore_cave () =
  seq [
    say "The cave stretches deeper...";
    choice [
      ("Study the runes", fun () ->
        seq [
          say "The runes tell a story...";
          set_trait player bravery;
          end_story "You've uncovered a mystery!"
        ]);
      ("Continue deeper", fun () ->
        say "You find a hidden chamber...")
    ]
  ]
```

### Character Development

Modify character traits based on player choices:

```ocaml
let story =
  seq [
    say "A dragon appears!";
    choice [
      ("Stand your ground", fun () ->
        seq [
          set_trait player bravery;
          say "Your bravery increases!"
        ]);
      ("Run away", fun () ->
        say "You live to fight another day...")
    ]
  ]
```

## Best Practices

1. **Keep Functions Pure**: Write your story nodes as pure functions when possible
2. **Use Type Safety**: Let OCaml's type system help catch narrative inconsistencies
3. **Modular Design**: Break your story into smaller, reusable functions
4. **State Management**: Use the story state to track important changes

## Advanced Features

### State Management

The story state tracks:
- Current location
- Characters and their traits
- Visited nodes

### Pattern Matching

Use OCaml's pattern matching to create dynamic story elements:

```ocaml
let get_character_trait character trait_name =
  List.find character.traits ~f:(fun t -> String.equal t.name trait_name)
```

## Examples

Check out the `examples` directory for complete story examples:
- `hello_world.ml`: A simple cave exploration story
- More examples coming soon!

## Contributing

Want to add features to the DSL? Check out our contributing guidelines and join the fun! 
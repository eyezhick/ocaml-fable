# Fable: Where Stories Come Alive in OCaml

> "Once upon a time, there was a language that made storytelling magical..."

Welcome to Fable, where we're turning the art of storytelling into a functional programming adventure! This isn't your grandma's choose-your-own-adventure book (though she might enjoy it too). We're building a domain-specific language that lets you craft interactive narratives using the elegance of OCaml.

## What's the Magic?

Fable is like having a magical quill that writes stories with type safety. It's where functional programming meets narrative design, and where your imagination meets OCaml's powerful type system. Think of it as "Twine meets Haskell" but with OCaml's pattern matching magic.

### Features That Make Storytellers Smile

- **Branching Narratives**: Create complex story trees that would make a weeping willow jealous
- **Dynamic Characters**: Give your characters traits that evolve as the story unfolds
- **World Building**: Define locations with behaviors that respond to player choices
- **Type-Safe Storytelling**: Let OCaml's type system catch your plot holes before your readers do
- **Random Events**: Add a dash of unpredictability to your tales
- **Flags & Inventory**: Track player state, items, and world changes
- **Dynamic Text**: Use templates for immersive, personalized output
- **Extensible Effects**: Add sound, visuals, or custom hooks

## Quick Start

```ocaml
(* A simple story about a brave adventurer *)
let story =
  seq [
    say "You wake up in a dark cave, the air thick with mystery.";
    choice [
      ("Light your torch", fun () -> 
        seq [
          say "The flickering light reveals ancient runes on the wall.";
          choice [
            ("Study the runes", study_runes);
            ("Continue deeper", explore_cave);
          ]
        ]);
      ("Go back to sleep", fun () -> end_story "You sleep forever.");
    ]
  ]
```

## 🕹️ Demo: What Playing Fable Looks Like

```
You wake up in a dark cave, the air thick with mystery.
Your torch flickers, casting dancing shadows on the walls.

What would you like to do?
1. Light your torch
2. Feel your way in the dark

> 1
The flickering light reveals ancient runes on the wall.
The cave stretches deeper into the mountain. Your torch casts long shadows on the walls.

What would you like to do?
1. Study the runes
2. Continue deeper

> 2
The tunnel narrows, and you must squeeze through a tight passage.
On the other side, you find a small chamber with a glowing crystal.
The crystal's light reveals a hidden treasure map carved into the floor.

The End.
```

## 🍀 Advanced DSL Features

### Random/Probabilistic Choices

```ocaml
random_choice [
  (0.7, "You find a gold coin!", fun () -> say "Lucky day!");
  (0.3, "A bat swoops at your head!", fun () -> say "You duck just in time!");
]
```

### Flags & Conditional Branching

```ocaml
seq [
  set_flag "has_sword" true;
  if_flag "has_sword"
    (say "You draw your sword bravely!")
    (say "You wish you had a sword...");
]
```

### Inventory Management

```ocaml
seq [
  add_inventory player "magic key";
  sayf "You now have: {{item}}" ["item", "magic key"];
  remove_inventory player "magic key";
]
```

### Dynamic Text Templating

```ocaml
sayf "Hello, {{name}}! Welcome to {{place}}." ["name", "Alice"; "place", "the Enchanted Forest"]
```

### Effects (Print, Sound, Custom)

```ocaml
effect (Sound "mysterious-chime.wav");
effect (Print "A chill runs down your spine...");
effect (Custom ("sparkle", `Assoc ["intensity", `Int 5]));
```

## Why Fable?

Because sometimes you want to write stories that are as elegant as your code. Fable brings together:

- The expressiveness of functional programming
- The power of algebraic data types
- The beauty of pattern matching
- The joy of interactive storytelling

## Getting Started

```bash
# Clone the repository
git clone https://github.com/yourusername/ocaml-fable.git

# Build the project
dune build

# Run the example story
dune exec fable examples/hello_world.ml
```

## Project Goals

- Create an intuitive DSL for narrative design
- Explore the intersection of computational logic and storytelling
- Build a bridge between game narrative modeling and functional programming
- Make storytelling in OCaml as natural as writing prose

## Contributing

Found a bug? Have a story to tell? Want to add your own chapter to Fable? Pull requests are welcome! Let's make this project as collaborative as the stories it helps create.

## Learn More

- [Documentation](docs/README.md)
- [Examples](examples/)
- [Contributing Guidelines](CONTRIBUTING.md)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*"In a world where code meets narrative, Fable is your storyteller's toolkit."* 🦊✨

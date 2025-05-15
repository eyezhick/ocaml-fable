# Fable: A Magical DSL for Interactive Storytelling in OCaml 🎭

> Once upon a time, in a world of functional programming, there was a language that made storytelling as elegant as a well-crafted function...

## 🎮 Try It Now!

[![Live Demo](https://img.shields.io/badge/Live-Demo-blue?style=for-the-badge)](https://eyezhick.github.io/ocaml-fable/)

Experience Fable in action! Write your own interactive stories or try our examples:
- 🌲 The Magic Forest
- 🏰 The Mysterious Cave
- 💎 The Treasure Hunt

## ✨ What is Fable?

Fable is a domain-specific language (DSL) built in OCaml that makes it easy to create interactive stories and text-based adventures. It combines the elegance of functional programming with the creativity of storytelling.

### 🎯 Key Features

- **Type-safe storytelling**: Catch errors before they ruin your narrative
- **Functional flow**: Compose scenes like you compose functions
- **Interactive choices**: Create branching narratives with ease
- **State management**: Track variables and character progress
- **Pure OCaml**: Leverage the full power of OCaml's type system

## 📚 Examples

### 🌲 The Magic Forest
```ocaml
(* A simple story with multiple scenes *)
let story = {
    title = "The Magic Forest";
    start = "forest_entrance";
    scenes = [
        {
            id = "forest_entrance";
            text = "You stand at the entrance of a magical forest. 
                   The trees seem to whisper secrets.";
            choices = [
                { text = "Enter the forest"; next = "forest_path" }
            ]
        },
        {
            id = "forest_path";
            text = "The path winds through ancient trees. 
                   Sunlight filters through the leaves.";
            choices = [
                { text = "Continue deeper"; next = "forest_clearing" }
            ]
        }
    ]
}
```

### 🏰 The Mysterious Cave
```ocaml
(* A story with multiple choices and branching paths *)
let story = {
    title = "The Mysterious Cave";
    start = "cave_entrance";
    scenes = [
        {
            id = "cave_entrance";
            text = "A dark cave looms before you. 
                   Strange sounds echo from within.";
            choices = [
                { text = "Enter cautiously"; next = "cave_interior" },
                { text = "Look for a torch"; next = "find_torch" }
            ]
        },
        {
            id = "cave_interior";
            text = "The cave is pitch black. 
                   You can barely see your hand in front of your face.";
            choices = [
                { text = "Feel your way forward"; next = "cave_deep" },
                { text = "Go back outside"; next = "cave_entrance" }
            ]
        }
    ]
}
```

### 💎 The Treasure Hunt
```ocaml
(* A story with variables and state management *)
let story = {
    title = "The Treasure Hunt";
    start = "beach_start";
    variables = ["coins", "map"];
    scenes = [
        {
            id = "beach_start";
            text = "You find a treasure map on the beach. 
                   Your coin purse jingles with 10 gold coins.";
            choices = [
                { text = "Follow the map"; next = "jungle_path" }
            ]
        },
        {
            id = "jungle_path";
            text = "The map leads you to a jungle path. 
                   A merchant offers to buy your map for 5 coins.";
            choices = [
                { text = "Sell the map"; next = "merchant_deal" },
                { text = "Keep the map"; next = "keep_map" }
            ]
        }
    ]
}
```

## 🚀 Getting Started

### Prerequisites

- OCaml 4.14.0 or later
- OPAM (OCaml package manager)
- Dune (build system)

### Installation

```bash
# Clone the repository
git clone https://github.com/eyezhick/ocaml-fable.git
cd ocaml-fable

# Install dependencies
opam install . --deps-only

# Build the project
dune build

# Run the tests
dune runtest
```

## 🎨 Creating Your First Story

1. Create a new file with the `.fable` extension
2. Define your story structure
3. Add scenes and choices
4. Compile and run!

Example:
```ocaml
(* my_story.fable *)
let story = {
    title = "My First Story";
    start = "beginning";
    scenes = [
        {
            id = "beginning";
            text = "Welcome to your first Fable story!";
            choices = [
                { text = "Start the adventure"; next = "adventure" }
            ]
        }
    ]
}
```

## 🤝 Contributing

We welcome contributions! Whether it's:
- 🐛 Bug fixes
- ✨ New features
- 📚 Documentation improvements
- 🎨 Example stories

Check out our [Contributing Guide](CONTRIBUTING.md) to get started.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## �� Acknowledgments

- The OCaml community for their amazing language
- All the storytellers who inspire us
- You, for checking out Fable! 

---

Made with ❤️ and OCaml

# Fable: My OCaml DSL for Interactive Storytelling

I've created Fable, a domain-specific language (DSL) in OCaml for crafting interactive stories and text-based adventures. This project combines my passion for functional programming and interactive fiction, allowing me to build branching narratives with dynamic dialogue and world logic.

## 🌟 Features I've Implemented

- **Branching Story Engine**: Create complex story paths with multiple choices and outcomes
- **Dynamic Dialogue System**: Build natural conversations that adapt to player choices
- **World State Management**: Track and modify story variables as the narrative unfolds
- **Web Demo**: Play interactive stories directly in your browser

## 🚀 Getting Started

### Prerequisites

- OCaml 4.14.0 or later
- OPAM (OCaml package manager)
- Dune build system

### Installation

```bash
# Clone my repository
git clone https://github.com/eyezhick/ocaml-fable.git
cd ocaml-fable

# Install dependencies
opam install . --deps-only

# Build the project
dune build
```

## 📝 Writing Stories

Here's a simple example of how I write stories in Fable:

```ocaml
let story = {
  title = "The Mysterious Door";
  start = "room";
  locations = [
    {
      id = "room";
      description = "You stand in a dimly lit room. A mysterious door stands before you.";
      choices = [
        {
          text = "Open the door";
          next = "beyond";
          effects = [SetFlag "door_opened"];
        };
        {
          text = "Look around";
          next = "room";
          effects = [AddItem "key"];
        };
      ];
    };
    {
      id = "beyond";
      description = "Beyond the door lies a magical garden.";
      choices = [
        {
          text = "Enter the garden";
          next = "garden";
          effects = [];
        };
      ];
    };
  ];
};
```

## 🌐 Play the Web Demo

I've created a web demo where you can try out some of my interactive stories:

[Play Fable Web Demo](https://eyezhick.github.io/ocaml-fable/)

To run the web demo locally:
```bash
# Build the web demo
dune build web/fable_web.bc.js

# Start a local server
python3 -m http.server 8000
```
Then open http://localhost:8000 in your browser.

## 🛠️ Project Structure

```
ocaml-fable/
├── lib/           # Core DSL implementation
├── examples/      # Sample stories I've written
├── web/          # Web interface for playing stories
└── tests/        # Test cases for the DSL
```

## 🤝 Contributing

While this is primarily my personal project, I'm open to suggestions and improvements! Feel free to:
- Open issues for bugs or feature requests
- Submit pull requests for improvements
- Share your own stories created with Fable

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- The OCaml community for their excellent tools and libraries
- Interactive fiction authors who inspired this project
- Everyone who has tried out my stories and provided feedback

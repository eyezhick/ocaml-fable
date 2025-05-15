# Contributing to Fable 🦊

Welcome to Fable! We're excited to have you contribute to our project. This document will help you get started.

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a new branch for your feature
4. Make your changes
5. Submit a pull request

## Development Setup

1. Install OCaml and OPAM:
   ```bash
   # On macOS with Homebrew
   brew install ocaml opam

   # On Ubuntu/Debian
   sudo apt-get install ocaml opam
   ```

2. Initialize OPAM:
   ```bash
   opam init
   eval $(opam env)
   ```

3. Install dependencies:
   ```bash
   opam install . --deps-only
   ```

4. Build the project:
   ```bash
   dune build
   ```

## Code Style

- Follow OCaml's standard formatting conventions
- Use `ocamlformat` for consistent formatting
- Write clear, descriptive commit messages
- Add comments for complex logic
- Write tests for new features

## Project Structure

```
ocaml-fable/
├── lib/              # Core library code
├── examples/         # Example stories
├── docs/            # Documentation
└── tests/           # Test suite
```

## Adding New Features

1. **Documentation First**: Update the docs before implementing
2. **Type Safety**: Use OCaml's type system to your advantage
3. **Testing**: Add tests for new features
4. **Examples**: Create examples showing how to use new features

## Pull Request Process

1. Update the README.md with details of changes if needed
2. Update the documentation with any new features
3. The PR will be merged once you have the sign-off of at least one other developer

## Questions?

Feel free to open an issue for any questions or suggestions!

## License

By contributing, you agree that your contributions will be licensed under the project's MIT License. 
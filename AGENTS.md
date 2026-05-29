# Coding conventions

<!--toc:start-->
- [Coding conventions](#coding-conventions)
  - [General coding conventions](#general-coding-conventions)
  - [Python coding conventions](#python-coding-conventions)
    - [Python tools](#python-tools)
    - [Python project structure](#python-project-structure)
<!--toc:end-->

## General coding conventions

- Prefer clear naming rather than abbreviations

## Python coding conventions

### Python tools

- Project manager: `uv`
- Liter & formatter: `ruff`
- Type checker: `ty`
- Task runner: `make`

### Python project structure

- Every runnable script must have a `main` function.
- Use `python -m <module>`, `ur run <command>`, or `make <command>` to run scripts instead of `python <script>.py`.
- Use `if __name__ == "__main__":` block to call the `main` function.

"""{basename} - Package entry point (`python -m`)."""

from {dot}.main import main

if __name__ == "__main__":
    raise SystemExit(main())

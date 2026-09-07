# Luau Dev Tool

A local Luau development environment for writing, testing, and organizing
Roblox-style scripts outside of Roblox Studio.

## Structure

- `scripts/` — game/tool logic (Luau scripts)
- `tests/` — standalone test scripts that exercise code in `scripts/`
- `tools/` — helper scripts (linting, formatting, build helpers)
- `docs/` — notes and design docs

## Requirements

- Luau CLI (`pkg install luau` on Termux)

## Running a script

    luau scripts/hello.lua

## Running tests

    luau tests/run_tests.lua

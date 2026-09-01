# General Style Guide

This general style guide covers cross-language best practices for maintainable, clear, and high-quality software and formal specifications.

## 1. File Organization and Structure
- **Single Responsibility:** Each file should have a single clear purpose (e.g., defining a specific logic, proving a specific meta-property, or declaring a particular translation).
- **Clear Imports:** Only import what is necessary. Avoid wildcard imports that clutter the namespace.
- **Top-Down Flow:** Place general/fundamental definitions at the top of the file, followed by specialized definitions and theorems that build on top of them.

## 2. Naming Conventions
- **Descriptive Names:** Choose names that reveal intent. A theorem name should reflect its statement (e.g., `action_deontic_equiv_under_strong_bridges` rather than `thm12`).
- **Consistent Case:**
  - Types/Sorts: UpperCamelCase (e.g., `World`, `Perspective`).
  - Definitions/Theorems/Lemmas: snake_case (e.g., `bisimulation_invariance`, `UNCobligatory`).
  - Variables/Hypotheses: descriptive abbreviations or prefixing (e.g., `h_serial` for a seriality hypothesis, `w` for world).

## 3. Comments and Documentation
- **Intuition First:** Precede complex definitions and theorems with comments describing the philosophical intuition, the semantic behavior, and the high-level proof strategy.
- **Inline Explanations:** Use brief inline comments to explain non-obvious steps, especially in long proofs.

## 4. Unused and Dead Code
- **No Leftovers:** Remove any debug print statements, leftover experiments, and commented-out dead code before submitting changes.
- **No Sorry/Oops:** Placeholder tags like `sorry` (Lean) or `oops`/`sorry` (Isabelle) must be completely resolved before a task is closed.

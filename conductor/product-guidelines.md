# Product Guidelines - Universal Normative Calculus (UNC)

This document outlines the design principles, prose guidelines, and proof writing style to ensure the metatheoretical library remains robust, understandable, and mathematically rigorous.

## Prose & Style Guidelines

### 1. Rigorous Philosophical and Mathematical Precision
UNC bridges the gap between abstract moral philosophy and concrete mathematical logic. Therefore:
- **Philosophical concepts** (such as "reasons", "perspectives", and "bridges") must be defined in standard philosophical terminology while mapped directly to their formal counterparts.
- **Avoid vague language.** Use terms like "necessary and sufficient conditions," "soundness," "completeness," "bisimulation," and "semantic embedding" with exact mathematical meaning.

### 2. Self-Documenting Proofs (ITP Best Practices)
In both Lean 4 and Isabelle/HOL, proofs must be legible, clean, and easily maintainable.
- **Isabelle/HOL:** Prefer Isabelle's structured proof language **Isar** over long, unreadable "apply-style" tactic scripts. Use explicit intermediate steps (`have`, `show`, `obtain`) to document the logical flow of the argument.
- **Lean 4:** Use structured tactic blocks, proper indentation, and descriptive variable names. Organize proofs into clear `have` steps rather than nested `by` expressions that are hard to debug.
- **Comments:** Every non-trivial theorem or definition must be preceded by a comment explaining the philosophical intuition and the mathematical strategy.

### 3. Symmetrical Documentation
Since the project relies on Symmetrical Cross-Validation, all documentation, specifications, and comments must match across:
- **Lean 4 source files (`.lean`)**
- **Isabelle/HOL theory files (`.thy`)**
- **Markdown documentation (`.md`)**

If a definition is adjusted in Isabelle, its corresponding definition in Lean must be updated, and the reason for the adjustment documented symmetrically.

### 4. Diagramming Guidelines
- Any architectural relationship or proof structure must be illustrated using **both ASCII text diagrams and adjacent Mermaid diagram blocks** to ensure high-quality visual and textual representation.
- All Mermaid diagrams must compile without errors.

### 5. Non-interactive Proof Execution & CI
To maintain maximum stability:
- All proofs must compile cleanly without errors in the background or during CI.
- The use of `sorry` (Lean 4) or `oops` / `sorry` (Isabelle) is forbidden in production/master branches. They are strictly temporary placeholders during active task execution.

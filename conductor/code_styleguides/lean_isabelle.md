# Lean 4 & Isabelle/HOL Coding Style Guide

This style guide covers specialized conventions and best practices for writing clean, readable, and maintainable proofs and specifications in Lean 4 and Isabelle/HOL within the UNC project.

## Isabelle/HOL Style Guidelines

### 1. Proof Structure (Isar vs. Apply Scripts)
- **Prefer Isar Proofs:** For any theorem or lemma requiring a proof longer than a few lines, always prefer structured **Isar** proofs (using `proof ... qed` with `have`, `obtain`, `show`) over a sequence of unstructured `apply` tactics.
- **Explicit Assumptions:** In Isar proofs, explicitly label assumptions and intermediate facts (e.g., `using assms`, `with H`) to make the logical dependencies transparent.
- **Clean Tactics:** When apply-scripts are used (for trivial proofs), use clean, declarative tactics (e.g., `by auto`, `by simp`, `by blast`, `by fastforce`) rather than a long chain of low-level `apply` steps.

### 2. Connectives and Symbol Conventions
- Use the established boldface unicode symbols for propositional connectives in UNC to ensure mathematical readability:
  - Negation: `\<^bold>\<not>`
  - Conjunction: `\<^bold>\<and>`
  - Disjunction: `\<^bold>\<or>`
  - Implication: `\<^bold>\<rightarrow>`
  - Equivalence: `\<^bold>\<leftrightarrow>`
  - Validity: `\<lfloor>\<phi>\<rfloor>`
- Properly format operators with syntax and binding priorities, e.g., `abbreviation UNCobligatory :: "p \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>" ("\<^bold>O\<^sub>_ _" [54,54] 55)`.

### 3. Theory Declarations
- Every theory file must begin with a standardized header indicating its name, imports, and purpose:
  ```isabelle
  theory Theory_Name
    imports Parent_Theories
  begin
  ```
- Use `Session` boundaries cleanly. Declare sessions and document theory groupings in the `ROOT` file.

---

## Lean 4 Style Guidelines

### 1. Functional Formatting & Indentation
- Use 2-space indentation.
- Limit line length to 100 characters where possible.
- Put operators on the start of the next line for wrapped expressions, or align them for readability.

### 2. Proof Block Structure
- Use `by` with a structured block for tactic-mode proofs.
- If a proof has multiple subgoals, use bullet points `·` to isolate and focus on each subgoal.
- Indent the contents of each subgoal block:
  ```lean
  theorem my_theorem : ... := by
    intro x
    apply Iff.intro
    · intro h
      ...
    · intro h
      ...
  ```

### 3. Hypothesis Naming
- Precede hypotheses with `h_` to easily distinguish them from variables and constants (e.g., `h_serial`, `h_deontic_equiv`).
- Use descriptive suffixes for related hypotheses (e.g., `h_obl1`, `h_obl2`).

### 4. Constructive Proofs
- Lean 4 supports classical logic but is foundationally constructive. Prefer constructive proofs and explicit matchings (e.g., `match ... with | ⟨v, hb⟩ => ...`) when dealing with existential quantifiers where feasible.
- Keep casts and reflection minimal, isolated to boundary translations.

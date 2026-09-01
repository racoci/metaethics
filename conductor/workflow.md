# Project Workflow - Universal Normative Calculus (UNC)

## Guiding Principles

1. **The Plan is the Source of Truth:** All work must be tracked in `plan.md` (and registered in the tracks registry if needed).
2. **The Tech Stack is Deliberate:** Any modification to the tech stack (such as updating Lean 4 version or importing new Isabelle sessions) must be documented in `tech-stack.md` before execution.
3. **Test-Driven Development (TDD) for Theorem Proving:**
   - In Interactive Theorem Proving (ITP), **theorems are our tests**.
   - **Red Phase (Failing Test):** Define the type signature of the theorem / lemma and use `sorry` (Lean 4) or `oops` / `sorry` (Isabelle). Confirm that the build system warns about unfinished proofs.
   - **Green Phase (Passing Test):** Implement the formal proof until the prover accepts it without any warnings, errors, `sorry` placeholders, or `oops` commands.
   - **Refactoring:** Once the proof is accepted, refactor it to make it more elegant, clean up intermediate steps, or generalize the result. Rerun the build to verify it remains correct.
4. **Symmetrical Cross-Validation:** Major logical steps and results must be verified symmetrically in both Lean 4 and Isabelle/HOL.

## Task Workflow

Every task in the plan must follow this lifecycle:

1. **Select Task:** Choose the next available task from `plan.md` in sequential order.
2. **Mark In Progress:** Edit `plan.md` and change the task status from `[ ]` to `[~]`.
3. **Draft the Specification (Red Phase):**
   - Declare the definitions, types, or theorem signatures in the corresponding `.lean` or `.thy` file.
   - Use `sorry` or `oops` to represent the unfinished state. Run `lake build` or `isabelle build` / `process` to verify type-checking is correct up to the proof itself.
4. **Implement the Proof (Green Phase):**
   - Work through the proof steps (using Isar or Lean tactics) until the prover reports a fully completed and verified proof.
   - Run the build tools to ensure there are no warnings or errors.
5. **Refactor and Generalize:**
   - Simplify tactic chains, replace complex manual steps with automated helpers (`simp`, `blast`, `aesop`, etc.), and improve readability.
   - Re-verify the proof.
6. **Commit Code Changes:**
   - Stage all code and theory modifications.
   - Commit with a clear message (e.g., `proof(bisimulation): Prove characteristic formulas in Isabelle`).
7. **Mark Complete:**
   - Get the commit SHA of the completed work.
   - Update `plan.md`, changing `[~]` to `[x]` and appending the commit SHA.
   - Commit the updated `plan.md`.

## Task Correction & Plan Amendment Workflows

If bugs, logical gaps, or specification drifts are identified during a task or during review:
- **In-flight refinements:** Adjust the proof or definition directly and ensure the provers fully accept the changes before committing.
- **Post-commit corrections:** Create an amendment task in `plan.md` explaining the gap, resolve it using the standard Red-Green-Refactor workflow, and commit the fix with a reference to the original task.

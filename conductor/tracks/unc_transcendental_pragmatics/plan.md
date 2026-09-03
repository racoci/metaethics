# Track Implementation Plan - Transcendental Pragmatics in UNC (unc_transcendental_pragmatics)

This implementation plan outlines the sequential phases and tasks to formalize Karl-Otto Apel's Transcendental Pragmatics. It enforces Symmetrical Cross-Validation and TDD principles for interactive theorem proving.

---

## Architectural Risks, Costs & Technical Debt

-   **Risk of Logical Triviality / Vacuum:** Defining speech-act presuppositions axiomatically without concrete models could introduce inconsistencies, rendering the theories vacuously true (where anything is provable).
-   **Risk of Infinite Proof Divergence:** Proving general self-referential properties on infinite domains can cause proof-search divergence in both Lean 4 (`aesop`) and Isabelle/HOL (`blast`, `force`).
-   **Mitigation Task (Task 4.1):** We dedicate Phase 4 specifically to model checking via Isabelle's `nitpick` over finite carrier domains to ensure absolute logical consistency and satisfiability of our newly introduced axiom systems.

---

## Phase 1: Communication Primitives & Symmetrical Signatures

We declare the core types and primitive operators in both Isabelle/HOL and Lean 4, establishing the syntactic signatures before starting any proofs.

### - [ ] Task 1.1: Declare Speech Act Primitives in Isabelle/HOL
-   **Goal:** Create a new theory file `UNC_Transcendental.thy` in `/home/racoci/Projects/metaethics/UNC/` with primitive constants for `ExecArgue`, `ExecAssert`, `Presuppose` and the logical signature for performative contradiction `PC`.
-   **Documentation:** Create `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md` and document the Isabelle signature mappings.
-   **Automated Test:** Run `isabelle process -T UNC_Transcendental` to verify it compiles with empty/`oops` proofs.

### - [ ] Task 1.2: Port Speech Act Signatures to Lean 4
-   **Goal:** Create `/home/racoci/Projects/metaethics/UNC/Transcendental.lean` with symmetrical definitions of `ExecArgue`, `ExecAssert`, `Presuppose` and signature declarations using `sorry` placeholders.
-   **Documentation:** Update `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md` to document Lean 4 equivalents.
-   **Automated Test:** Run `lake build` to ensure the project type-checks cleanly.

### - [ ] Task 1.3: Update Configuration and Sessions List
-   **Goal:** Add `UNC_Transcendental` to the `UNC/ROOT` file in Isabelle to include the new theory in the test session.
-   **Documentation:** Document the session structure in `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md`.
-   **Automated Test:** Run `isabelle build -D UNC` to verify the session compiles cleanly.

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)
-   **Criteria:** All signatures declare cleanly in both engines; builds compile successfully with warnings indicating unfinished proofs (`sorry` / `oops`).

---

## Phase 2: Presuppositions & Performative Contradiction (PC)

We formalize the core axiom of constitutivity and prove properties of the performative contradiction predicate.

### - [ ] Task 2.1: Formalize Communicative Presuppositions & PC in Isabelle/HOL
-   **Goal:** Implement the Axiom of Communicative Constitutivity and define the `PC` predicate in `UNC_Transcendental.thy`. Prove basic lemmas about performative contradiction (e.g., that an agent cannot assert $\neg \psi$ and presuppose $\psi$ without triggering `PC`).
-   **Documentation:** Document the mathematical definitions of `PC` in `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md`.
-   **Automated Test:** Run `isabelle process -T UNC_Transcendental` to ensure the proofs are accepted.

### - [ ] Task 2.2: Symmetrize Presuppositions & PC in Lean 4
-   **Goal:** Implement the constitutivity axiom and the `PC` predicate in `UNC/Transcendental.lean` and prove the matching lemmas.
-   **Documentation:** Update `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md` with Lean 4 type-theoretic proofs.
-   **Automated Test:** Run `lake build` to verify the Lean 4 proofs are verified.

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)
-   **Criteria:** `PC` is fully formalized and proven in both engines; zero warnings/errors about missing types; compilation succeeds.

---

## Phase 3: Transcendental Bridge & Discourse Ethics Deontic Force

We formalize Karl-Otto Apel's main transcendental theorem: proving that denying the communicative norms while arguing triggers performative contradictions, establishing discourse-ethical obligations.

### - [ ] Task 3.1: Prove Transcendental Bridge in Isabelle/HOL
-   **Goal:** Prove the Transcendental Bridge theorem in `UNC_Transcendental.thy`:
    $$\forall a. \lfloor \text{ExecArgue}(a, \mathbf{\neg}\mathcal{N}) \rightarrow \text{PC}(a, \mathbf{\neg}\mathcal{N}) \rfloor$$
    And prove that avoiding performative contradictions obligates discourse agents:
    $$\forall a, \phi. \lfloor \text{ExecArgue}(a, \phi) \rightarrow \mathbf{O}_d(\mathcal{N}) \rfloor$$
-   **Documentation:** Document the complete proof strategy in `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md`.
-   **Automated Test:** Run `isabelle build -D UNC` to ensure the Isabelle proofs verify.

### - [ ] Task 3.2: Symmetrize Transcendental Bridge in Lean 4
-   **Goal:** Port the Transcendental Bridge proofs to `UNC/Transcendental.lean` using tactics.
-   **Documentation:** Document the Lean 4 constructive steps in `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md`.
-   **Automated Test:** Run `lake build` to verify Lean 4 compiles.

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)
-   **Criteria:** Transcendental Bridge proofs are completed on both engines with zero placeholders (`sorry` / `oops`).

---

## Phase 4: Model Checking & Satisfiability Verification

We verify that our axiom systems are non-trivial and satisfiable, mitigating the risk of axiomatic model collapse.

### - [ ] Task 4.1: Perform Satisfiability Checking via Nitpick
-   **Goal:** Run Isabelle's `nitpick` on `UNC_Transcendental.thy` over a finite state space (with 2 worlds, 2 agents, and 2 actions) to verify the existence of non-trivial models where our axioms hold and communication succeeds without contradiction.
-   **Documentation:** Document the model configurations and verification results in a new section under `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md`.
-   **Automated Test:** Run `isabelle build -D UNC` (including the Nitpick assertion check).

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)
-   **Criteria:** Nitpick returns a valid satisfiable model, mathematically proving the theory's consistency.

---

## Phase 5: Gated Validation & Zero-Placeholder Compilation

We perform a final, comprehensive static analysis of the codebase to guarantee strict quality compliance before track completion.

### - [ ] Task 5.1: Zero-Placeholder Code Guard Verification
-   **Goal:** Audit all theory and code files in the track workspace to verify there are absolutely no `sorry`, `oops`, `admit`, or incomplete proof blocks.
-   **Documentation:** Document the final verification report in `/home/racoci/Projects/metaethics/docs/transcendental_pragmatics.md`.
-   **Automated Test:** Run both `lake build` and `isabelle build -D UNC` and confirm 100% clean exit codes.

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)
-   **Criteria:** Both provers accept the entire formalization with 100% success; zero warnings; zero placeholders.

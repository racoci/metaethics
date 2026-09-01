# Track Implementation Plan - Advanced Metatheoretical Advances (Phases III, IV, V/VI)

This implementation plan details the sequential phases and tasks to fulfill the track specification. It integrates Symmetrical Cross-Validation and strict Test-Driven Development (TDD) for theorem proving.

## Architectural Risks, Costs & Technical Debt
- **Risk of Proof Complexity Explosion:** Formulating inductive characteristic formulas on infinite domains or complex structures can lead to untractable proofs in both Isabelle and Lean 4.
- **Specification Drift:** Adding definitions in Isabelle first and neglecting Lean 4 (or vice-versa) can break the Symmetrical Cross-Validation invariant.
- **Logical Inconsistency (Collapsing Models):** Defining too many axioms can make the theory vacuously true (trivially consistent because no model exists).
- **Future Mitigation Task (Task 5.1):** We dedicate Task 5.1 to active model-checking (using Nitpick/Quickcheck in Isabelle and Lean's linting) to verify that all new definitions and axioms permit non-trivial models (satisfiability checks).

---

## Phase 1: Verification Environment & Symmetrical Mapping for Bisimulation (Phase III)

### - [x] Task 1.1: Prove Bisimulation Invariance in Lean 4 (eacdf3e)
- **Goal:** Port the definitions of `form`, `eval` ($\models$), `Bisimulation`, and the proof of `bisimulation_invariance` from Isabelle (`UNC_Bisimulation.thy`) to Lean 4.
- **Documentation:** Document the Lean 4 mapping in `docs/symmetrical_bisimulation.md`.
- **Automated Test:** Run `lake build` to ensure the Lean 4 proofs compile cleanly.

### - [ ] Task 1.2: Formalize Image-Finiteness Symmetrically
- **Goal:** Declare image-finiteness predicates for relations `B` and `R_K` in both Isabelle and Lean 4.
- **Documentation:** Add dedicated section in `docs/symmetrical_bisimulation.md`.
- **Automated Test:** `isabelle process -T UNC_Bisimulation` and `lake build` compile without warnings.

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)

---

## Phase 2: Hennessy-Milner & Characteristic Formulas (Phase III)

### - [ ] Task 2.1: Define Characteristic Formulas and Prove Their Property in Isabelle/HOL
- **Goal:** For each state in an image-finite model, inductively define its characteristic formula $\chi_w$ and prove that $\forall v, (v \models \chi_w) \longleftrightarrow Z w v$.
- **Documentation:** Document the design of characteristic formulas in `docs/characteristic_formulas.md`.
- **Automated Test:** `isabelle build -D UNC` finishes with success on `UNC_Bisimulation`.

### - [ ] Task 2.2: Prove the Hennessy-Milner Theorem in Isabelle/HOL
- **Goal:** Prove that for image-finite structures, modal equivalence is equivalent to bisimilarity.
- **Documentation:** Add proof outline and explanations in `docs/characteristic_formulas.md`.
- **Automated Test:** `isabelle build -D UNC` verifies the completed Hennessy-Milner proof.

### - [ ] Task 2.3: Symmetrize Characteristic Formulas and Hennessy-Milner in Lean 4
- **Goal:** Define characteristic formulas and prove the Hennessy-Milner theorem in Lean 4.
- **Documentation:** Symmetrize explanations and proof structures in `docs/symmetrical_bisimulation.md`.
- **Automated Test:** `lake build` compiles the Lean 4 formalization.

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)

---

## Phase 3: Qualitative Reasons Framework (Phase IV)

### - [ ] Task 3.1: Define Qualitative Reason Preferences and Reason-Obligation Link in Isabelle/HOL
- **Goal:** Define abstract reasons `q`, the supports relation, and the qualitative priority ordering $\succeq$ on sets of reasons in a new file `UNC_Reasons.thy`. Define how reasons justify obligations and prove key properties.
- **Documentation:** Create `docs/qualitative_reasons.md`.
- **Automated Test:** `isabelle process -T UNC_Reasons` builds successfully.

### - [ ] Task 3.2: Symmetrize Qualitative Reasons in Lean 4
- **Goal:** Port the reasons framework, preference relation, and reason-obligation mappings to Lean 4.
- **Documentation:** Update `docs/qualitative_reasons.md` to map Lean 4 type-theoretic equivalents.
- **Automated Test:** `lake build` succeeds.

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)

---

## Phase 4: Specific Metaethical Translations & Consistency Verification (Phase V/VI)

### - [ ] Task 4.1: Formalize Gewirth's PGC in UNC in Isabelle/HOL and Prove Deontic Consistency
- **Goal:** Create a new file `UNC_Metaethics.thy`, formalize Alan Gewirth's PGC using UNC parameters, and prove that it yields consistent deontic obligations (absence of logical contradictions).
- **Documentation:** Create `docs/metaethical_translations.md`.
- **Automated Test:** `isabelle process -T UNC_Metaethics` builds successfully.

### - [ ] Task 4.2: Symmetrize Gewirthian Parameters and Consistency Proofs in Lean 4
- **Goal:** Port the PGC formalization and consistency proofs to Lean 4.
- **Documentation:** Symmetrize the explanations in `docs/metaethical_translations.md`.
- **Automated Test:** `lake build` compiles cleanly.

### - [ ] Task: Phase Verification & Checkpoint (Refer to workflow.md)

---

## Phase 5: Technical Debt & Satisfiability Verification

### - [ ] Task 5.1: Model Checking & Satisfiability Verification (Technical Debt Mitigation)
- **Goal:** Use Isabelle's `nitpick` to verify that the formalized axioms and definitions are satisfiable (non-vacuity check) and do not collapse the models to trivial or empty spaces.
- **Documentation:** Document the satisfiability results and countermodel inspections in `docs/model_verification.md`.
- **Automated Test:** `isabelle build` runs the satisfiability checking suite.

---

## Phase 6: Recursive Risk Analysis (Final Planning & Implementation Gate)

### - [x] Task 6.1: Run Recursive Risk and Mitigation Analysis (eacdf3e)
- **Goal:** Execute a deep recursive risk analysis up to 6 levels deep (using `@recursive-risk-analyzer` skill) to analyze the risks of this known plan.
- **Documentation:** Write the final risk analysis report to `docs/recursive_risk_analysis.md`.
- **Automated Test:** Verification of the complete risk analysis artifact.

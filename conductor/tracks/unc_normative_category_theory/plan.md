# Plan: Adjunctions and Functors in the Category of Normative Systems

This plan describes the detailed engineering steps to formalize preorder categories, functors, and Galois adjunctions on normative systems in both Isabelle/HOL and Lean 4.

---

## Phase 1: Scaffolding and Planning

- [x] **Task 1.1: Scaffolding Track Artifacts**
  - Create track metadata, specification, and plan files.
  - *Verification:* Files exist and are valid.
- [x] **Task 1.2: Recursive Risk Analysis**
  - Perform 6-level deep recursive risk analysis on "Size Issues and Universe Polymorphism in Lean 4 Category Theory".
  - *Verification:* `docs/recursive_risk_analysis_category.md` exists and contains 6 levels.
- [x] **Task 1.3: Update Master Track List**
  - Update `README.md` and `conductor/tracks.md` to reflect the active Category Theory track.
  - *Verification:* Git diff shows proper updates.

## Phase 2: Isabelle/HOL Implementation

- [x] **Task 2.1: Formalize Preorder on Perspectives (`UNC_Category.thy`)**
  - Define `leq_p p1 p2` as `\<forall>\<phi> w. (UNCobligatory p2 \<phi>) w \<longrightarrow> (UNCobligatory p1 \<phi>) w`.
  - Prove reflexivity and transitivity of `leq_p`.
  - *Verification:* Basic preorder structure compiles successfully.
- [x] **Task 2.2: Formalize Functors and Galois Adjunctions**
  - Define `mono_functor F` (monotonicity).
  - Define `adjunction F G` as `\<forall>p1 p2. leq_p (F p1) p2 \<longleftrightarrow> leq_p p1 (G p2)`.
  - Prove Galois connection lemmas: extensivity (`leq_p p (G (F p))`) and co-extensivity (`leq_p (F (G p)) p`).
  - Prove idempotency of the closure operator $G(F(p))$.
  - *Verification:* Adjunction lemmas are proved.
- [x] **Task 2.3: Prove Deontic Equivalence at Galois Fixed Points**
  - Define fixed points and show they satisfy deontic equivalence `DeonticEquiv p (G (F p))`.
  - Prove this mechanically.
  - *Verification:* Deontic equivalence theorem is fully proved.
- [x] **Task 2.4: Session Registration and Consistency Checking**
  - Register `UNC_Category` in `UNC/ROOT`.
  - Run `nitpick` to check satisfiability of the category/adjunction model.
  - *Verification:* Session ROOT updated; Nitpick runs successfully without counters.

## Phase 3: Lean 4 Implementation

- [x] **Task 3.1: Create `UNC/Category.lean`**
  - Define the preorder relation `leq_p` on `Perspective`.
  - Prove reflexivity and transitivity.
  - Define functor monotonicity.
  - Define the adjunction structure.
  - *Verification:* Definitions are syntax-correct.
- [x] **Task 3.2: Prove Galois Adjunction Properties in Lean 4**
  - Prove extensivity (`leq_p p (G (F p))`) and co-extensivity.
  - Prove idempotency of closure $G(F(p))$.
  - Prove the deontic equivalence theorem at fixed points.
  - *Verification:* All proofs are clean and compile with no `sorry` or warnings.
- [x] **Task 3.3: Build Project**
  - Run `lake build` to verify correctness of the entire Lean codebase.
  - *Verification:* Zero errors, zero warnings.

## Phase 4: Closing and Commit

- [x] **Task 4.1: Final Verification and Review**
  - Perform Code Guard checks and Conductor review.
  - *Verification:* All tests pass, build is spotless.
- [x] **Task 4.2: Mark Track Completed**
  - Update `metadata.json` status to `completed`.
  - *Verification:* `metadata.json` contains `"status": "completed"`.
- [x] **Task 4.3: Atomic Commit**
  - Commit all generated/updated files to Git.
  - *Verification:* `git status` is clean.

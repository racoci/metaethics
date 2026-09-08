# Plan: Symmetrical Kant-Utilitarian Confrontation & Interactive Ethics Dashboard

This implementation plan outlines the steps for formalizing the Kant-Utilitarian confrontation, proving practical convergence in both Isabelle/HOL and Lean 4, and building an interactive dashboard for metatheoretical visualization.

---

## Architectural Risks, Costs & Technical Debt

-   **Risk of Theory Oversimplification:** Capturing Kantian and Utilitarian ethics in simple modal logic might leave out important nuances. We mitigate this by clearly specifying that we model Rule Utilitarianism and a specific Kantian formulation of treating agents as mere means.
-   **Risk of Inconsistent Axiom Sets:** Adding axioms for both Kantianism and Utilitarianism could make the logic trivial if they are contradictory. We mitigate this by defining a conditional scenario (`NoConflict`) where they are proven to align, and use `nitpick` to verify that our model remains fully consistent and satisfiable.
-   **Risk of Interactive UI Bloat:** Using complex frontend libraries could introduce security and maintenance overhead. We mitigate this by using 100% pure vanilla HTML5, CSS3, and JavaScript, ensuring a lightning-fast, dependency-free dashboard.

---

## Phase 1: Scaffolding and Risk Analysis

-   [x] **Task 1.1: Scaffolding Track Artifacts**
    -   Create track folder and define `metadata.json`, `spec.md`, and `plan.md`.
    -   *Verification:* Files exist and match guidelines.
-   [x] **Task 1.2: Recursive Risk Analysis**
    -   Conduct a 6-level deep recursive risk analysis and save to `docs/recursive_risk_analysis_confrontation.md`.
    -   *Verification:* File contains 6 distinct recursive levels.
-   [x] **Task 1.3: Update Project Roadmaps**
    -   Add the new track and the interactive dashboard feature to `README.md` and `conductor/tracks.md`.
    -   *Verification:* Roadmaps are updated.

---

## Phase 2: Isabelle/HOL Formalization

-   [x] **Task 2.1: Formalize Confrontation in Isabelle/HOL (`UNC_Confrontation.thy`)**
    -   Declare perspectives `p_kant` and `p_util`.
    -   Declare `UtilityMax :: "act \<Rightarrow> i \<Rightarrow> bool"`.
    -   Declare `Instrumentalize :: "a \<Rightarrow> \<sigma>"` and `ExecAssert :: "a \<Rightarrow> \<sigma> \<Rightarrow> \<sigma>"`.
    -   Axiomatize Kantian absolute prohibition of instrumentalization.
    -   Axiomatize Rule Utilitarian utility maximization.
    -   Define `NoConflict` scenario.
    -   Prove the **Practical Convergence Theorem**: `NoConflict w \<longrightarrow> B p_kant w = B p_util w` (which implies perfect deontic equivalence).
    -   Verify satisfiability with `nitpick`.
    -   *Verification:* The theory compiles without warnings or errors.
-   [x] **Task 2.2: Register in session ROOT**
    -   Append `UNC_Confrontation` to `UNC/ROOT`.
    -   *Verification:* File is successfully listed in session ROOT.

---

## Phase 3: Lean 4 Formalization

-   [x] **Task 3.1: Symmetrical Formalization in Lean 4 (`UNC/Confrontation.lean`)**
    -   Implement the exact same structure, axioms, and proofs of practical convergence constructively in Lean 4.
    -   *Verification:* File exists and contains verified proofs.
-   [x] **Task 3.2: Integrate and Compile**
    -   Import `UNC.Confrontation` in `Main.lean`.
    -   Run `lake build` to compile the entire project.
    -   *Verification:* Success exit code with 0 errors and no `sorry`.

---

## Phase 4: Interactive Ethics Dashboard

-   [x] **Task 4.1: Develop Dashboard (`docs/dashboard.html`)**
    -   Create the HTML5/CSS3/Vanilla JS single-page app.
    -   Implement modern "dark glow" aesthetic.
    -   Implement both scenarios (Autonomous Car Collision and Pandemic Data Surveillance).
    -   Implement interactive selectors for metaethical perspectives and real-time visualization of Ontological, Bridge, and Deontic levels.
    -   Implement the Bisimulation Simulator to run theories in parallel and calculate convergence under conflict/no-conflict states.
    -   *Verification:* File is created and verified to run in a standard web browser.

---

## Phase 5: Verification and Closure

-   [x] **Task 5.1: Final Symmetrical Check**
    -   Verify Isabelle and Lean match exactly on theorems, names, and logic.
    -   *Verification:* High-confidence alignment.
-   [x] **Task 5.2: Atomic Git Commit**
    -   Create a clean, atomic commit for the track.
    -   *Verification:* Clean working tree.
-   [x] **Task 5.3: Update Metadata to Completed**
    -   Change status in `metadata.json` to `completed`.
    -   *Verification:* JSON shows completed.

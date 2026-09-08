# Recursive Risk and Mitigation Analysis: Kant-Utilitarian Confrontation & Dashboard

This document details a **6-level deep recursive risk analysis** on the formalization of Kant-Utilitarian confrontation and its interactive web-based ethical dashboard (`docs/dashboard.html`).

---

## Recursive Analysis Tree

```text
Level 1: Oversimplification of Kantian vs. Utilitarian Theories in Logic
  └── Level 2 (Mitigation 1): Define Narrow Axioms for Mere Means & Rule Utilitarianism
        └── Level 3 (Risk 2): New Axioms Cause Logically Inconsistent/Trivial (Vacuous) State Space
              └── Level 4 (Mitigation 2): Introduce "NoConflict" World-Level Conditional Scenario
                    └── Level 5 (Risk 3): Nitpick/Model Finder Timeouts due to Infinite Worlds
                          └── Level 6 (Mitigation 3): Enforce strictly finite domain bounds & types for verification
```

---

## Deep Recursive Evaluation Loop

### Level 1: Primary Architectural Risk
- **Risk Identified:** Extreme oversimplification of complex historical ethical theories (Kantian Deontology vs. Rule Utilitarianism) within modal logic, leading to philosophically naive proofs that lose academic and logical value.
- **Likelihood:** High
- **Impact:** High
- **Mitigation Strategy:** Do not attempt to model every facet of Kantian or Utilitarian ethics. Instead, restrict the formal scope to a specific, well-defined core:
  - Kantianism is modeled strictly via the *Formula of Humanity* (prohibition of treating agents as "mere means" / instrumentalization).
  - Utilitarianism is modeled strictly as Rule Utilitarian action-optimality which aligns directly with a qualitative utility maximization predicate (`UtilityMax`).

---

### Level 2: Secondary Risk (Arising from Level 1 Mitigation)
- **Risk Identified:** Restricting the theories to specific axioms (e.g. `ExecAssert x (Instrumentalize y) w \<longrightarrow> \<not>OptimalAct p_kant x act w`) introduces a risk of logical inconsistency. If a world requires instrumentalization to survive, can any action be Kantian-optimal? If not, the Kantian perspective might select an empty set of optimal worlds ($B_{p\_kant}(w) = \emptyset$), violating the seriality constraint (Axiom D) and rendering the system deontically trivial or inconsistent.
- **Likelihood:** Medium-High
- **Impact:** High
- **Mitigation Strategy:** Define a conditional world-level predicate `NoConflict w` representing states of the world where utility-maximizing actions do not require instrumentalization. Symmetrically prove the convergence theorem *strictly under this condition*, and allow $B_{p\_kant}(w)$ to differ from $B_{p\_util}(w)$ when `NoConflict w` is false, preserving Axiom D by ensuring that even under conflict, there exists a valid selection.

---

### Level 3: Tertiary Risk (Arising from Level 2 Mitigation)
- **Risk Identified:** Introducing the `NoConflict w` predicate and conditional set-equality theorems makes the model checker (`nitpick` in Isabelle/HOL and compile-time search in Lean 4) prone to infinite search loops and timeouts. The theorem prover might fail to find countermodels or prove theorems because the state space has infinite worlds/agents.
- **Likelihood:** Medium
- **Impact:** Medium-High
- **Mitigation Strategy:** Enforce strictly finite carrier bounds and simple, constructive type signatures. In Isabelle/HOL, construct the types `i`, `a`, `act` as simple types so `nitpick` can easily exhaustively search finite domains of cardinality $\le 3$. In Lean 4, use explicit, non-recursive, constructive proofs that bypass automated search and run in constant time.

---

### Level 4: Quaternary Risk (Arising from Level 3 Mitigation)
- **Risk Identified:** Restricting model verification to small finite domains ($\le 3$) means that our safety and consistency guarantees might not scale to large systems (e.g., hundreds of agents or actions in an automated system, like multi-agent collision-avoidance). Edge cases involving combinatorial explosions of conflict might remain hidden.
- **Likelihood:** Medium
- **Impact:** Medium
- **Mitigation Strategy:** Establish a rigorous mathematical inductive proof that shows any property proven on cardinalities $\le 3$ in our pure qualitative framework generalizes to $N$ agents. This is enabled because our predicates (`NoConflict`, `OptimalAct`) are universally quantified over agents, and do not rely on cardinal sums or arithmetic aggregates.

---

### Level 5: Quinary Risk (Arising from Level 4 Mitigation)
- **Risk Identified:** Relying on purely qualitative predicates without cardinal sums (to avoid scaling issues) prevents the Rule Utilitarian model from representing complex quantitative trade-offs (e.g., sacrificing 1 to save 5 vs. sacrificing 1 to save 1,000,000). This renders the Utilitarian logic incapable of resolving standard moral dilemmas in the dashboard visualizer.
- **Likelihood:** Medium-High
- **Impact:** Medium
- **Mitigation Strategy:** Introduce a qualitative ordering relation `UtilityMax` which acts as an abstract pre-order over actions. This allows the dashboard and the formal logic to represent "better than" or "maximizes utility" abstractly, without needing hard-coded numerical values in the proof kernel, thereby preserving the qualitative-only design of UNC.

---

### Level 6: Senary Risk (Arising from Level 5 Mitigation)
- **Risk Identified:** Using an abstract qualitative pre-order for utility maximization in the dashboard can make the UI confusing for non-technical users. If the dashboard only says "action A is qualitatively preferred to B", users cannot experiment with quantitative parameters (like changing the number of saved passengers in the autonomous car scenario) to see the threshold of convergence.
- **Likelihood:** Medium
- **Impact:** Low-Medium
- **Mitigation Strategy:** Build the interactive web dashboard (`docs/dashboard.html`) to present quantitative slide-controls (e.g., "Number of lives saved", "Level of privacy intrusion"). Translate these numeric values inside the UI's JavaScript layer into qualitative relations (e.g. if saved > sacrificed, then `UtilityMax` holds) before sending them to the Bisimulation Simulator. This keeps the backend proof model clean and qualitative, while giving users an intuitive, quantitative, and fully interactive frontend experience.
- **Residual Risk Level:** **Low Likelihood / Low Impact** (The boundary between quantitative user interaction and qualitative formal verification is perfectly insulated).

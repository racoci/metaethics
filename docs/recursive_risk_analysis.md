# Recursive Risk Analysis - advanced Metatheoretical Advances

This document performs a 6-level deep recursive risk analysis on the architectural and proof design choices of the Advanced Metatheoretical Advances track.

*   **[Depth 1] Risk:** Defining Characteristic Formulas inductively over an infinite state space in Isabelle/HOL or Lean 4 might lead to infinite formulas, which are not representable in standard finite syntax `form` (High Likelihood).
    *   **Mitigation:** Enforce image-finiteness at the type/definition level using a finite set of reachable worlds, or define characteristic formulas only for finite models, or define them using a bounded depth $k$ bisimulation.
        *   **[Depth 2] Risk:** Bounded-depth bisimulation characteristic formulas only characterize bisimulation up to depth $k$. If the model is infinite or has cycles, the formula might not characterize full bisimulation (Medium Likelihood).
            *   **Mitigation:** Prove that for image-finite structures, bisimilarity is equivalent to $k$-bisimilarity for all $k$, and that if the state space is finite, there is a fixed bound $k$ (the size of the state space) beyond which $k$-bisimilarity coincides with full bisimilarity.
                *   **[Depth 3] Risk:** Proving the equivalence of $k$-bisimilarity for all $k$ and full bisimilarity in Isabelle/HOL requires complex coinductive or inductive arguments on relations, which are highly prone to proof stalling and automation failures (Medium Likelihood).
                    *   **Mitigation:** Use established coinduction packages in Isabelle/HOL (`coinduction` tactic) and structure the proof via auxiliary lemmas using a relational approach.
                        *   **[Depth 4] Risk:** Lean 4 does not have as mature a coinduction framework as Isabelle/HOL, making the coinductive proofs in Lean 4 extremely tedious and difficult to complete (Medium Likelihood).
                            *   **Mitigation:** Formalize the Lean 4 version constructively using a step-indexed relation or explicit equivalence relation on paths rather than full coinduction, which avoids coinductive packages.
                                *   **[Depth 5] Risk:** Using step-indexed relations in Lean 4 introduces high indexing overhead (e.g. tracking index variables $n, m$ through all inductive constructors) and increases cognitive load (Medium Likelihood).
                                    *   **Mitigation:** Create custom helper lemmas and automation tactics (such as a local `omega` or `aesop` configuration) to automatically handle step-index arithmetic.
                                        *   **[Depth 6] Risk:** Complex automation configs (`aesop`) are difficult to debug when they fail, leading to opaque compilation errors in Lean 4 (Low Likelihood) -> *Branch Terminated (Low Likelihood).*

*   **[Depth 1] Risk:** Inconsistency / Vacuous Truth when formalizing Qualitative Reasons and Gewirth's PGC (Medium Likelihood).
    *   **Mitigation:** Use Isabelle's `nitpick` to automatically search for non-trivial satisfying models of the axioms.
        *   **[Depth 2] Risk:** Nitpick might fail to find models if the type declarations are infinite or complex, or report "timeout" due to state space explosion (Medium Likelihood).
            *   **Mitigation:** Bound the search size explicitly in Nitpick arguments (e.g. `card i = 1-3`, `card a = 1-2`, etc.) and keep types simple.
                *   **[Depth 3] Risk:** Small cardinalities might miss subtle inconsistencies that only manifest in larger models or under specific relational constraints (Low Likelihood) -> *Branch Terminated (Low Likelihood).*

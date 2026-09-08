# Track: Symmetrical Kant-Utilitarian Confrontation & Interactive Ethics Dashboard (unc_metaethical_confrontation_viz)

This track formalizes the convergence between **Kantian Deontology** and **Rule Utilitarianism** and builds an interactive visualization dashboard.

## Structure
- [Metadata](./metadata.json)
- [Specification](./spec.md)
- [Implementation Plan](./plan.md)

## Implementation Status
- **Isabelle/HOL Proof:** Symmetrically formalizes Kant ($p_{kant}$) and Utilitarianism ($p_{util}$) in `UNC_Confrontation.thy`, proving Practical Convergence (`NoConflict w \<longrightarrow> B p_kant w = B p_util w`).
- **Lean 4 Proof:** Symmetrically formalizes the same theorems constructively in `UNC/Confrontation.lean`.
- **Interactive Dashboard:** Implements the modern web-based simulation tool `docs/dashboard.html` with practical scenarios (Collision of Autonomous Car, pandemic data surveillance), allowing selecting scenario, active perspective, and running parallel bisimulations.

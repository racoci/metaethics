# Track Specification - Advanced Metatheoretical Advances (Phases III, IV, V/VI)

This specification defines the functional, technical, and architectural requirements for extending the Universal Normative Calculus (UNC) codebase across Phases III (Hennessy-Milner Theorem / Characteristic Formulas), IV (Abstract Structure of Reasons), and V/VI (Specific Metaethical Translations).

## 1. Overview
The goal of this track is to transition UNC from foundational semantic embeddings to advanced metatheoretical properties, qualitative reason structures, and specific moral-theoretic applications. 

## 2. Functional Requirements

### Phase III: Hennessy-Milner Theorem & Characteristic Formulas
- **Image-Finiteness Constraint:** Define what it means for the modal accessibility relations (`B` and `R_K`) to be image-finite.
  - In Isabelle: `finite (B p w)` and `finite {v. R_K a w v}`.
  - In Lean 4: Represent image-finiteness using finite sets (`Finset`) or equivalent type-class constraints.
- **Characteristic Formulas:**
  - For any world $w$ in an image-finite model, define a characteristic formula $\chi_w \in \text{form}$ that uniquely identifies the bisimulation class of $w$.
  - Prove the characteristic property: $\forall v, (v \models \chi_w) \longleftrightarrow Z w v$ where $Z$ is the maximal bisimulation.
- **Hennessy-Milner Theorem:**
  - Prove that for image-finite structures, two worlds are bisimilar if and only if they satisfy the exact same set of formulas:
    $$\text{Bisimilar}(w_1, w_2) \longleftrightarrow (\forall \phi, w_1 \models \phi \longleftrightarrow w_2 \models \phi)$$

### Phase IV: Abstract Structure of Reasons (Without Cardinality)
- **Qualitative Reasons Framework:**
  - Model reasons as abstract considerations of type `q`.
  - Define a qualitative priority or preference relation over reasons (or sets of reasons) parameterized by the metaethical perspective `p`.
  - Avoid any quantitative or numeric summation of reasons (no cardinalities or numeric weights).
- **Reason-to-Obligation Justification:**
  - Define a function or relation that maps a set of active reasons and their preferences to deontic obligations.
  - Prove that if perspective $p_1$ and $p_2$ have identical qualitative reason structures, they are deontically equivalent.

### Phase V/VI: Specific Metaethical Translations
- **Gewirth's Principle of Generic Consistency (PGC) Translation:**
  - Translate the core tenets of Gewirth's PGC (that any agent by the very nature of action must claim rights to freedom and well-being) into UNC parameters.
- **Verification of Consistency:**
  - Prove that a perspective configured under Gewirthian parameters is logically consistent (e.g., guarantees that conflicting obligations are unprovable).

---

## 3. Technical Requirements & Symmetrical Constraints

- **Dual-Engine Alignment:** Every theorem proven in Isabelle/HOL must have a corresponding representation and proof skeleton in Lean 4.
- **Non-interactive Execution:** All proof files must compile without warnings or errors under `isabelle build` and `lake build`.
- **Zero Placeholder Rule:** No `sorry`, `oops`, or incomplete proofs are allowed in the final merged branch of this track.

---

## 4. Acceptance Criteria

| Phase | Criterion | Verification Method |
|---|---|---|
| Phase III | Prove Bisimulation $\implies$ Modal Equivalence | Already proven in Isabelle; must verify in Lean 4 |
| Phase III | Prove Modal Equivalence $\implies$ Bisimulation (Hennessy-Milner) | Isabelle theory build succeeds, and Lean 4 compile succeeds |
| Phase IV | Define Qualitative Reason Priority and Reason-Obligation Link | Isabelle theory build succeeds, and Lean 4 compile succeeds |
| Phase V/VI | Formalize Gewirth's PGC in UNC and prove deontic consistency | Isabelle theory build succeeds, and Lean 4 compile succeeds |

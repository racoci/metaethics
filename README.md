# Unitary Normative Core (UNC): A Formal Metatheory of Normativity

A mechanically verified metatheory of normativity designed to represent, compare, and translate diverse metaethical positions (Realism, Constructivism, Expressivism, and Transcendental Pragmatics) within a unified logical framework. UNC separates the ontology of reasons from deontic output to mathematically analyze when competing theories agree on action despite differing on their underlying metaphysical commitments.

---

## Key Framework Architecture

- **Symmetrical Cross-Verification**: Symmetrical proofs implemented and verified in both **Isabelle/HOL (LogiKEy)** and **Lean 4 (v4.32.1)**.
- **Deontic Equivalence & Ontological Incongruence**: Formal proof that diverse ontologies of reasons can yield identical deontic outputs (separating "what normativity is" from "what ought to be done").
- **Metaethical Bridge Constraints**: Verified minimal constraints (Endorsement, Admissibility, Constitutivity) necessary to establish action-deontic equivalence between competing metaethical systems.
- **Normative Bisimulation Invariance**: A complete constructive proof of Bisimulation Invariance (Theorem A) over an observational multimodal language containing deontic optimal-world selection, epistemic relations, and actions.
- **Symmetrical Hennessy-Milner Theorem**: Symmetrical formulation and verification of the Hennessy-Milner equivalence under image-finiteness.
- **Qualitative Reasons Framework**: Abstract relational model of defeasibility and priorities (independent of sums/cardinalities) successfully linked to deontic outputs.
- **Gewirthian PGC Constructivism**: Mechanically verified constructivist derivation of Alan Gewirth's Principle of Generic Consistency (PGC) from agency-constitutive requirements to moral authority.

---

## Verified Results Obtained So Far

Our dual-verification pipeline across Isabelle/HOL (using the LogiKEy framework) and Lean 4 has successfully verified the following core results:

### 1. Semantic Foundation and Deontic Core (`UNC.thy` & `UNC.lean`)
- **Axiom D Verification**: Formalized the deontic selection relation $B_p(w)$ mapping a perspective $p$ and world $w$ to a set of optimal worlds. Proved that $O\phi \rightarrow P\phi$ holds under the seriality constraint ($\forall w, B_p(w) \neq \emptyset$) in both Isabelle/HOL and Lean 4.
- **Ontological Incongruence Countermodel**: Verified the central thesis that **Ontological Incongruence does not imply Deontic Incongruence** ($\exists p_1 p_2. \neg \text{OntoEquiv}(p_1, p_2) \wedge \text{DeonticEquiv}(p_1, p_2)$). Using Isabelle's Nitpick model finder, we generated a genuine finite countermodel proving that two metaethical perspectives can differ on reason supports (`Supports`) while agreeing on all deontic obligations (`O`).

### 2. Metaethical Bridge Minimization (`UNC_Bridges.thy`)
- **Action-Deontic Equivalence**: Formalized three qualitative bridge relations: *Endorsed* ($E$), *Admissible* ($A$), and *Constitutive* ($C$). Proved that the full conjunction of these "Strong Bridges" ($E+A+C$ functioning as bicondicionals) is sufficient to guarantee action-deontic equivalence (`DeonticEquiv_Act`).
- **Propositional Inequivalence Boundary**: Verified via Nitpick that action-level equivalence under $E+A+C$ **does not** imply propositional deontic equivalence (`DeonticEquiv`) over arbitrary formulas $\phi$. This demonstrates a precise mathematical boundary to metaethical convergence.

### 3. Normative Bisimulation Invariance & Symmetrical Hennessy-Milner (`UNC_Bisimulation.thy` & `UNC/Bisimulation.lean`)
- **Deep Syntactic Embedding**: Formalized a multimodal logic syntax containing `Atom`, `Not`, `And`, `Oblig`, and `Knows` operators.
- **Invariance Proof (Theorem A)**: Completed and mechanically checked a constructive structural induction proof of **Bisimulation Invariance** in both Isabelle/HOL and Lean 4:
  $$Z \text{ is a Bisimulation} \wedge Z w_1 w_2 \implies (\phi \models w_1 \iff \phi \models w_2)$$
- **Image-Finiteness Predicates**: Defined image-finiteness constraints on sets of optimal selection worlds ($B$) and epistemic accessibility worlds ($R_K$) in both Isabelle/HOL and Lean 4, providing the essential semantic precondition for the converse of bisimulation invariance.
- **Characteristic Formulas (Theorem B)**: Symmetrically formulated step-indexed characteristic formulas $\chi_n(w)$ and successfully proved their characteristic property and the Hennessy-Milner Theorem (Logical Equivalence $\implies$ Bisimilarity) under image-finiteness in both Isabelle/HOL and Lean 4:
  $$v \models \chi_n(w) \longleftrightarrow w \approx_n v$$

### 4. Qualitative Reasons Framework (`UNC_Reasons.thy` & `UNC/Reasons.lean`)
- **Relational Non-Cardinal Reasons**: Established abstract relational priority (`ReasonPref`) and defeasibility-based conclusive reasons (`ConclusiveReason`) independent of sums/counting.
- **Reasons-to-Deontic Bridge**: Formulated and proved that if deontic selection $B_p(w)$ is defined/constrained by conclusive reasons, then conclusive reasons logically necessitate deontic obligations (`OptimalAct`).

### 5. Gewirthian PGC Constructivism (`UNC_Gewirth.thy` & `UNC/Gewirth.lean`)
- **Constitutive Agency-to-Obligation Derivation**: Formalized Alan Gewirth's Principle of Generic Consistency (PGC). Proved that agency constitutively requiring freedom and well-being logically yields the moral obligation to protect other agents' rights.

---

## Project Structure

```text
/home/racoci/Projects/metaethics/
├── UNC.lean                 # Core deontic definitions & D-axiom proof in Lean 4
├── lean-toolchain           # Fixed toolchain leanprover/lean4:v4.32.1
├── lakefile.toml            # Lean 4 project configuration
├── UNC/
│   ├── ROOT                 # Isabelle session definition file
│   ├── UNC.thy              # Core semantics & Ontological Incongruence in Isabelle/HOL
│   ├── UNC_Bridges.thy      # Metaethical Bridge and action-equivalence proof
│   ├── UNC_Bisimulation.thy # Inductive proof of Theorem A (Invariance) and Hennessy-Milner in Isabelle/HOL
│   ├── UNC_Reasons.thy      # Qualitative Reasons Framework in Isabelle/HOL
│   ├── UNC_Gewirth.thy      # Alan Gewirth PGC Constructivism in Isabelle/HOL
│   ├── Basic.lean           # Lean 4 basic declarations
│   ├── Bisimulation.lean    # Bisimulation Invariance, Characteristic Formulas & Hennessy-Milner in Lean 4
│   ├── Reasons.lean         # Qualitative Reasons Framework in Lean 4
│   └── Gewirth.lean         # Alan Gewirth PGC Constructivism in Lean 4
├── docs/
│   ├── recursive_risk_analysis.md # 6-level deep recursive risk matrix
│   ├── symmetrical_bisimulation.md # Symmetrical proof analysis
│   ├── characteristic_formulas.md # Characteristic formulas & Hennessy-Milner analysis
│   ├── qualitative_reasons.md     # Qualitative Reasons Framework analysis
│   └── metaethical_translations.md # Gewirthian constructivism analysis
└── conductor/               # Conductor Spec-Driven Development files
```

---

## Compilation

Both build suites compile with 100% type-safety and success:
- **Lean 4**: Run `lake build` to verify all submodules compile cleanly without warnings or errors.
- **Isabelle/HOL**: Build with session parameters using `ROOT`.

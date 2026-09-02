# Unitary Normative Core (UNC): A Formal Metatheory of Normativity

A mechanically verified metatheory of normativity designed to represent, compare, and translate diverse metaethical positions (Realism, Constructivism, Expressivism, and Transcendental Pragmatics) within a unified logical framework. UNC separates the ontology of reasons from deontic output to mathematically analyze when competing theories agree on action despite differing on their underlying metaphysical commitments.

---

## Key Framework Architecture

- **Symmetrical Cross-Verification**: Symmetrical proofs implemented and verified in both **Isabelle/HOL (LogiKEy)** and **Lean 4 (v4.32.1)**.
- **Deontic Equivalence & Ontological Incongruence**: Formal proof that diverse ontologies of reasons can yield identical deontic outputs (separating "what normativity is" from "what ought to be done").
- **Metaethical Bridge Constraints**: Verified minimal constraints (Endorsement, Admissibility, Constitutivity) necessary to establish action-deontic equivalence between competing metaethical systems.
- **Normative Bisimulation Invariance**: A complete constructive proof of Bisimulation Invariance (Theorem A) over an observational multimodal language containing deontic optimal-world selection, epistemic relations, and actions.

---

## Verified Results Obtained So Far

Our dual-verification pipeline across Isabelle/HOL (using the LogiKEy framework) and Lean 4 has successfully verified the following core results:

### 1. Semantic Foundation and Deontic Core (`UNC.thy` & `UNC.lean`)
- **Axiom D Verification**: Formalized the deontic selection relation $B_p(w)$ mapping a perspective $p$ and world $w$ to a set of optimal worlds. Proved that $O\phi \rightarrow P\phi$ holds under the seriality constraint ($\forall w, B_p(w) \neq \emptyset$) in both Isabelle/HOL and Lean 4.
- **Ontological Incongruence Countermodel**: Verified the central thesis that **Ontological Incongruence does not imply Deontic Incongruence** ($\exists p_1 p_2. \neg \text{OntoEquiv}(p_1, p_2) \wedge \text{DeonticEquiv}(p_1, p_2)$). Using Isabelle's Nitpick model finder, we generated a genuine finite countermodel proving that two metaethical perspectives can differ on reason supports (`Supports`) while agreeing on all deontic obligations (`O`).

### 2. Metaethical Bridge Minimization (`UNC_Bridges.thy`)
- **Action-Deontic Equivalence**: Formalized three qualitative bridge relations: *Endorsed* ($E$), *Admissible* ($A$), and *Constitutive* ($C$). Proved that the full conjunction of these "Strong Bridges" ($E+A+C$ functioning as bicondicionals) is sufficient to guarantee action-deontic equivalence (`DeonticEquiv_Act`).
- **Propositional Inequivalence Boundary**: Verified via Nitpick that action-level equivalence under $E+A+C$ **does not** imply propositional deontic equivalence (`DeonticEquiv`) over arbitrary formulas $\phi$. This demonstrates a precise mathematical boundary to metaethical convergence.

### 3. Normative Bisimulation Invariance & Characteristic Formulas (`UNC_Bisimulation.thy` & `UNC/Bisimulation.lean`)
- **Deep Syntactic Embedding**: Formalized a multimodal logic syntax containing `Atom`, `Not`, `And`, `Oblig`, and `Knows` operators.
- **Invariance Proof (Theorem A)**: Completed and mechanically checked a constructive structural induction proof of **Bisimulation Invariance** in both Isabelle/HOL and Lean 4:
  $$Z \text{ is a Bisimulation} \wedge Z w_1 w_2 \implies (\phi \models w_1 \iff \phi \models w_2)$$
- **Image-Finiteness Predicates**: Defined image-finiteness constraints on sets of optimal selection worlds ($B$) and epistemic accessibility worlds ($R_K$) in both Isabelle/HOL and Lean 4, providing the essential semantic precondition for the converse of bisimulation invariance.
- **Characteristic Formulas (Task 2.1)**: Formulated inductive step-indexed characteristic formulas $\chi_n(w)$ and successfully proved their characteristic property in Isabelle/HOL, verifying that any world satisfying the characteristic formula of $w$ at depth $n$ is list-restricted $n$-bisimilar to $w$:
  $$v \models \chi_n(w) \longleftrightarrow w \approx_n v$$
- **Compilation**: Lean 4 proofs compile with 100% type-safety under `lake build` with zero remaining placeholders (`sorry`/`oops`).

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
│   ├── UNC_Bisimulation.thy # Inductive proof of Theorem A (Invariance) and Characteristic Formulas in Isabelle/HOL
│   └── Bisimulation.lean    # Inductive proof of Theorem A (Invariance) in Lean 4
├── docs/
│   ├── recursive_risk_analysis.md # 6-level deep recursive risk matrix
│   ├── symmetrical_bisimulation.md # Symmetrical proof analysis
│   └── characteristic_formulas.md # Characteristic formulas & Hennessy-Milner analysis
└── conductor/               # Conductor Spec-Driven Development files
```

---

## Next Steps and Roadmap

### Phase III: The Hennessy-Milner Theorem (Converse & Characteristics)
- [x] **Image-Finiteness**: Formalize the semantic predicates for image-finite optimal selection ($B_p$) and epistemic accessibility ($R_K$) in both Isabelle/HOL and Lean 4.
- [x] **Characteristic Formulas**: Define step-indexed characteristic formulas $\chi_n(w)$ for state-spaces in Isabelle/HOL.
- [ ] **Theorem B Verification**: Prove the Hennessy-Milner converse (Logical Equivalence $\implies$ Bisimulation) under image-finiteness in Isabelle/HOL and Lean 4.

### Phase IV: Relational, Non-Cardinal Reason Structures
- [ ] **Defeat & Defeasibility**: Transition the definition of `Supports` from a simple truth relation to a qualitative, relational structure.
- [ ] **Relational Orderings**: Introduce partial orders representing the weights and priorities of competing pro tanto reasons, completely independent of cardinal counting or arithmetic.

### Phase V & VI: Specific Metaethical Reconstruction
- [ ] **Alan Gewirth's PGC**: Reconstruct the Principle of Generic Consistency in our unified model, formalizing the transition from agency-constitutive requirements to normative authority.
- [ ] **Performative Contradiction**: Formalize Karl-Otto Apel’s transcendental-pragmatic constraints, checking if performance-contradictory claims produce logical constraints on deontic output.
- [ ] **Symmetrical Model Check**: Run Nitpick on specific metaethical theories to ensure their axioms are mutually satisfiable and do not trigger modal collapse.

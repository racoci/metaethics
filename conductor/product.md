# Product Definition - Universal Normative Calculus (UNC)

## Product Vision & Description
The Universal Normative Calculus (UNC) is a formal metatheoretical framework for normativity, moral philosophy, and metaethics. By translating philosophical positions (such as deontology, consequentialism, and virtue ethics) into a unified, mathematically precise formal language, UNC enables the computer-assisted comparison, evaluation, and validation of ethical theories and their properties.

Through the power of interactive theorem proving (ITP), UNC mechanizes deontic logic, epistemic logic, action theory, and reason-based structures. This repository serves as the primary computational hub for UNC, employing a **dual-engine approach** using:
1. **Isabelle/HOL (with LogiKEy):** For higher-order logic (HOL) semantic embeddings, automated theorem proving, counterexample generation (via Nitpick/Sledgehammer), and bisimulation analysis.
2. **Lean 4:** For constructive proofs, type-theoretic foundations, and modern functional verification.

## Core Architectural Invariant: Symmetrical Cross-Validation
To guarantee absolute correctness and avoid specification drift between the two theorem provers:
- All core logical definitions (possible worlds, perspectives, reasons, actions, and obligations) must be modeled symmetrically in both Lean 4 and Isabelle/HOL.
- Major metatheorems (e.g., Deontic Equivalence, Bisimulation Invariance) must be proved in both environments. Correctness is verified when opposing proof systems align perfectly and yield matching semantic behavior.

## Project Scope & Core Goals
The project is divided into progressive phases to fully map the metatheoretical landscape of normativity:

- **Phase I (Foundations):** Base logic embedding, propositional connectives, validity, and parametric normative structures (`UNC.thy` and `UNC.lean`). [Status: Completed]
- **Phase II (Bridges):** Bridge laws connecting metaethical theories, optimal action characterizations, and proof of Action-Deontic Equivalence under strong bridges (`UNC_Bridges.thy`). [Status: Completed]
- **Phase III (Bisimulation & Hennessy-Milner):** Definition of bisimulation, proof of bisimulation invariance (`UNC_Bisimulation.thy`). **Next Goal:** Hennessy-Milner Theorem (characteristic formulas for bisimilarity).
- **Phase IV (Abstract Structure of Reasons):** Formalization of reason-based structures (weight, priority, support relations) without cardinality constraints, analyzing how reasons justify obligations.
- **Phase V & VI (Metaethical Translations):** Encoding specific metaethical systems (e.g., Gewirth's Principle of Generic Consistency, Kantian Deontology, Utilitarian Consequentialism) and verifying their structural compatibility.

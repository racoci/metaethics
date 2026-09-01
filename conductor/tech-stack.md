# Technology Stack - Universal Normative Calculus (UNC)

This document formalizes the software, tools, and libraries used in this project, ensuring a reproducible environment for Symmetrical Cross-Validation.

## Core Interactive Theorem Provers (ITPs)

### 1. Isabelle/HOL
- **Version:** Isabelle2025-2
- **Purpose:** Higher-Order Logic semantic embeddings, Automated Theorem Proving (ATP) integration (Sledgehammer), and model/counterexample generation (Nitpick).
- **Core Library:** `LogiKEy` logical framework for modeling non-classical and deontic structures.
- **Entry Points:** Theory files under `UNC/` (e.g., `UNC.thy`, `UNC_Bisimulation.thy`, `UNC_Bridges.thy`).

### 2. Lean 4
- **Version:** `leanprover/lean4:v4.32.1` (configured via `lean-toolchain`)
- **Purpose:** Constructive type-theoretic formalization, dependent type-driven validation of the calculus, and modern proof automation.
- **Build System:** `Lake` (configured via `lakefile.toml`)
- **Entry Points:** `UNC.lean`, `UNC/Basic.lean`, and `Main.lean`.

## Proof Inversion & Symmetrization
Symmetrical Cross-Validation dictates how we verify mathematical logic:
- Every axiom, theorem, and logical connective defined in `UNC.thy` (Isabelle) has a corresponding type-safe mapping in `UNC.lean` (Lean 4).
- The proof of a meta-property (e.g., Deontic Equivalence) in Lean 4 acts as a constructive validator of the semantic model analyzed via Nitpick and Sledgehammer in Isabelle.

## Local Verification Commands

### Isabelle/HOL Verification
To build and verify the Isabelle theories:
- Command: `isabelle build -D UNC`
- Alternate (for single theories): `isabelle process -T UNC_Bisimulation` (or via Isabelle/jEdit)

### Lean 4 Verification
To build and verify the Lean 4 project:
- Command: `lake build`
- This compiles all libraries (`UNC` and its sub-modules) and the `unc` executable target, verifying all proofs at compile-time.

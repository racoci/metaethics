# Specification: Adjunctions and Functors in the Category of Normative Systems

This specification defines the formalization, implementation, and verification of category-theoretic structures (preorders, functors, and Galois adjunctions) over normative perspectives/metaethical systems within the Universal Normative Core (UNC) framework.

---

## 1. Overview
Normative systems or metaethical perspectives can be ordered by their "demandingness" or "stringency". If perspective $p_1$ is more demanding than $p_2$, then any obligation in $p_2$ is also an obligation in $p_1$. We model this relationship as a preorder on perspectives:
$$p_1 \le p_2 \iff \forall \phi, w. (\mathbf{O}_{p_2} \phi) w \implies (\mathbf{O}_{p_1} \phi) w$$

This preorder forms a **Preorder Category** (where objects are perspectives and a unique morphism $p_1 \to p_2$ exists if and only if $p_1 \le p_2$). 

We can then define translations or mappings between systems as **Normative Functors** (monotonic maps). When we translate between different ontologies (e.g., a constructivist perspective vs. a realist perspective), these translations often form a **Galois Adjunction** (Galois connection):
$$F(p_1) \le p_2 \iff p_1 \le G(p_2)$$

This mathematical frontier allows us to prove a fundamental theorem: the composition of the adjoint functors ($G \circ F$) forms a Galois closure operator that stabilizes the normative core. At its fixed points, the translation ensures absolute deontic equivalence, guaranteeing that the translated and original perspectives are deontically identical.

---

## 2. Mathematical Formalization

### 2.1 Preorder Category of Perspectives
- **Relation:** $p_1 \le p_2 \iff \forall \phi, w. (\mathbf{O}_{p_2} \phi) w \implies (\mathbf{O}_{p_1} \phi) w$.
- **Reflexivity:** $p \le p$.
- **Transitivity:** If $p_1 \le p_2$ and $p_2 \le p_3$, then $p_1 \le p_3$.

### 2.2 Normative Functors
A functor $F : P \to P$ is a monotonic map preserving the preorder:
$$\forall p_1, p_2. p_1 \le p_2 \implies F(p_1) \le F(p_2)$$

### 2.3 Galois Adjunctions
A pair of functors $F, G : P \to P$ forms an adjunction (Galois connection) if and only if:
$$\forall p_1, p_2. F(p_1) \le p_2 \longleftrightarrow p_1 \le G(p_2)$$

### 2.4 Fundamental Galois Fixed-Point Theorem
From any Galois adjunction, we can prove:
1. **Extensivity / Inversion:** $p \le G(F(p))$ and $F(G(p)) \le p$.
2. **Idempotency:** $G(F(G(p))) \cong G(p)$ and $F(G(F(p))) \cong F(p)$.
3. **Deontic Equivalence at Fixed Points:** If a perspective is a fixed point of the closure (meaning $p \cong G(F(p))$), its deontic properties are completely stabilized under the adjoint translations.

---

## 3. Tool and Proof Requirements

### 3.1 Isabelle/HOL (`UNC_Category.thy`)
- Import `UNC`.
- Define the relation `leq_p p1 p2` representing $p_1 \le p_2$.
- Prove that `leq_p` is reflexive and transitive.
- Define a predicate `functor F` representing monotonicity.
- Define a predicate `adjunction F G` representing $F(p_1) \le p_2 \longleftrightarrow p_1 \le G(p_2)$.
- Prove the extensivity, monotonicity, and idempotency of the closure $G \circ F$.
- Prove the theorem of deontic equivalence at fixed points.
- Use `nitpick` to check satisfiability of the adjunction structure.

### 3.2 Lean 4 (`UNC/Category.lean`)
- Symmetrically formalize the preorder on `Perspective`.
- Define the preorder instance or properties in Lean 4.
- Define the monotonicity property for functors.
- Define the adjunction structure.
- Prove extensivity, idempotency, and the fixed-point deontic equivalence theorem using Lean 4 tactics without any `sorry`.

---

## 4. Acceptance Criteria
1. `UNC_Category.thy` exists in `UNC/` and is registered in `UNC/ROOT`.
2. `UNC/Category.lean` exists and compiles cleanly.
3. The whole Lean 4 project compiles via `lake build`.
4. Detailed recursive risk analysis on Lean 4 universe polymorphism and size issues is written under `docs/recursive_risk_analysis_category.md`.
5. Status in `metadata.json` updated to `completed`.
6. Master `tracks.md` updated to reflect track completion.

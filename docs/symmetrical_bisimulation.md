# Symmetrical Bisimulation Invariance Proof

This document details the symmetrical formalization of Bisimulation Invariance under Phase III of the Universal Normative Calculus (UNC) in both Isabelle/HOL and Lean 4.

## 1. Mathematical Background
Bisimulation invariance states that if two worlds $w_1$ and $w_2$ are bisimilar under a bisimulation relation $Z$, then they satisfy the exact same set of formulas $\phi$ in our modal language:
$$\forall \phi, w_1 \models \phi \longleftrightarrow w_2 \models \phi$$

This holds for any formula containing atomic actions, negation, conjunction, deontic obligations, and epistemic operators.

## 2. Isabelle/HOL Definition & Proof
In `UNC_Bisimulation.thy`, we defined the formula syntax as an inductive datatype, and the bisimulation relation as a predicate:

```isabelle
datatype form =
    Atom "a" "act"
  | Not form
  | And form form
  | Oblig p form
  | Knows a form

fun eval :: "form \<Rightarrow> i \<Rightarrow> bool" (infix "\<Turnstile>" 60) where ...

definition Bisimulation :: "(i \<Rightarrow> i \<Rightarrow> bool) \<Rightarrow> bool" where ...
```

The invariance is proved by induction on the formula $\phi$ using structured Isar proofs.

## 3. Lean 4 Definition & Proof
We established the exact same structures in `UNC/Bisimulation.lean` using Lean 4's inductive types and pattern matching:

```lean
inductive Form (Agent : Type u) (Action : Type u) (Perspective : Type u)
  | Atom : Agent → Action → Form Agent Action Perspective
  | Not : Form Agent Action Perspective → Form Agent Action Perspective
  | And : Form Agent Action Perspective → Form Agent Action Perspective → Form Agent Action Perspective
  | Oblig : Perspective → Form Agent Action Perspective → Form Agent Action Perspective
  | Knows : Agent → Form Agent Action Perspective → Form Agent Action Perspective
```

The proof in Lean is beautifully constructive and mirrors Isabelle's induction using `induction phi generalizing w1 w2`:

```lean
theorem bisimulation_invariance (Z : World → World → Prop)
  (h_bisim : Bisimulation Does B R_K Z)
  (w1 w2 : World) (h_z : Z w1 w2) (phi : Form Agent Action Perspective) :
  eval Does B R_K phi w1 ↔ eval Does B R_K phi w2
```

Both build suites (`isabelle build` and `lake build`) compile and verify these proofs with zero warnings.

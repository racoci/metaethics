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

## 4. Symmetrical Formalization of Image-Finiteness
To prepare for the proof of the Hennessy-Milner theorem, we formalized image-finiteness of both the deontic relation `B` and the epistemic relation `R_K`. Image-finiteness requires that for any state/world $w$, the set of successor states under a given relation is finite.

### 4.1 Isabelle/HOL Image-Finiteness
In `UNC_Bisimulation.thy`, image-finiteness is expressed using Isabelle's native `finite` predicate on sets:

```isabelle
definition image_finite_B_at :: "p \<Rightarrow> i \<Rightarrow> bool" where
  "image_finite_B_at p w \<equiv> finite (UNC.B p w)"

definition image_finite_R_K_at :: "a \<Rightarrow> i \<Rightarrow> bool" where
  "image_finite_R_K_at x w \<equiv> finite {v. UNC.R_K x w v}"

definition image_finite_B :: "bool" where
  "image_finite_B \<equiv> \<forall>p w. image_finite_B_at p w"

definition image_finite_R_K :: "bool" where
  "image_finite_R_K \<equiv> \<forall>x w. image_finite_R_K_at x w"
```

### 4.2 Lean 4 Image-Finiteness
In pure Lean 4 without Mathlib dependencies, we define a custom constructive finiteness predicate `IsFinite`. A predicate $P : \alpha \to \text{Prop}$ is finite if there exists a list $L$ containing all elements $v$ satisfying $P v$:

```lean
def IsFinite {α : Type u} (P : α → Prop) : Prop :=
  ∃ L : List α, ∀ v, P v → v ∈ L

def image_finite_B_at (B : Perspective → World → World → Prop) (p : Perspective) (w : World) : Prop :=
  IsFinite (fun v => B p w v)

def image_finite_R_K_at (R_K : Agent → World → World → Prop) (x : Agent) (w : World) : Prop :=
  IsFinite (fun v => R_K x w v)

def image_finite_B (B : Perspective → World → World → Prop) : Prop :=
  ∀ p w, image_finite_B_at B p w

def image_finite_R_K (R_K : Agent → World → World → Prop) : Prop :=
  ∀ x w, image_finite_R_K_at R_K x w

## 5. Symmetrical Characteristic Formulas and Hennessy-Milner in Lean 4

We have symmetrically formalized characteristic formulas, their properties, and the Hennessy-Milner theorem in `UNC/Bisimulation.lean` matching our Isabelle/HOL implementation.

### 5.1 Definitions

We defined list-based helper functions `conj_all` and `disj_all` to map finite lists of subformulas, and then `char_form` and `n_bisim_list` recursively:

```lean
def conj_all (x : Agent) (act : Action) : List (Form Agent Action Perspective) → Form Agent Action Perspective
  | [] => Form.Not (Form.And (Form.Atom x act) (Form.Not (Form.Atom x act)))
  | [phi] => phi
  | phi :: psi :: gamma => Form.And phi (conj_all x act (psi :: gamma))

def disj_all (x : Agent) (act : Action) : List (Form Agent Action Perspective) → Form Agent Action Perspective
  | [] => Form.And (Form.Atom x act) (Form.Not (Form.Atom x act))
  | [phi] => phi
  | phi :: psi :: gamma => Form.Not (Form.And (Form.Not phi) (Form.Not (disj_all x act (psi :: gamma))))
```

### 5.2 Symmetrical Proof of Hennessy-Milner

The Lean 4 theorem `hennessy_milner_logical_equiv_implies_bisim` matches our Isabelle/HOL theorem in signature and structure:

```lean
theorem hennessy_milner_logical_equiv_implies_bisim (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective)
  (x0 : Agent) (act0 : Action) (h0 : (x0, act0) ∈ atoms)
  (list_B_sound : ∀ p w v, v ∈ list_B p w ↔ B p w v)
  (list_R_K_sound : ∀ x w v, v ∈ list_R_K x w ↔ R_K x w v)
  (n : Nat) (w v : World)
  (h_equiv : logical_equiv_list Does B R_K atoms as ps n w v) :
  n_bisim_list Does B R_K atoms as ps n w v
```

This ensures complete alignment of types, operators, and logical bounds across the Isabelle and Lean 4 frameworks.

```

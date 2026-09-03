# Qualitative Reasons Framework

This document describes the design, implementation, and symmetrical formalization of the Qualitative Reasons Framework under Phase IV of the Universal Normative Calculus (UNC) in both Isabelle/HOL and Lean 4.

## 1. Context and Motivation
Traditional representations of pro tanto reasons in deontic logic often rely on quantitative measures (such as summing the cardinalities or weights of reasons) to resolve conflict and derive obligations. This is undesirable for metatheoretical comparisons, as it introduces arbitrary numerical values and assumptions about the comparability of disparate goods.

The Qualitative Reasons Framework provides an abstract, qualitative, and relational representation of reasons based on priorities and defeasibility/defeat (defeasibility of reasons) without resorting to cardinalities.

## 2. Relational Priority and Conclusive Reasons
We define a relational priority operator `ReasonPref` and a defeasibility-based `ConclusiveReason` operator:
- **`ReasonPref p q1 q2 w`**: under perspective `p` in world `w`, the consideration `q1` is strictly preferred/prioritized over `q2`.
- **`ConclusiveReason p x act w`**: There is some consideration `q1` supporting action `act` for agent `x` which is NOT defeated by any consideration `q2` supporting an alternative action `act'` that is strictly preferred to `q1`.

### Inductive Definition of Conclusive Reason (Relational Defeat)
$$ConclusiveReason(p, x, act, w) \equiv \exists q_1, Supports(p, q_1, x, act, w) \land \forall act', q_2, (act' \neq act \land Supports(p, q_2, x, act', w) \longrightarrow ReasonPref(p, q_1, q_2, w))$$

---

## 3. Isabelle/HOL Formalization

In `UNC/UNC_Reasons.thy`, we have formalized the framework as follows:

```isabelle
consts ReasonPref :: "p \<Rightarrow> q \<Rightarrow> q \<Rightarrow> i \<Rightarrow> bool"

definition ConclusiveReason :: "p \<Rightarrow> a \<Rightarrow> act \<Rightarrow> i \<Rightarrow> bool" where
  "ConclusiveReason p x act w \<equiv> \<exists>q1. (Supports p q1 x act w) \<and> 
    (\<forall>act' q2. (act' \<noteq> act \<and> (Supports p q2 x act' w)) \<longrightarrow> ReasonPref p q1 q2 w)"
```

We establish the reasons-to-obligations bridge by defining the accessible relation `B` in terms of conclusive reasons and proving the correspondence:

```isabelle
lemma conclusive_implies_optimal:
  assumes "B p w = {v. \<forall>x' act'. ConclusiveReason p x' act' w \<longrightarrow> Does x' act' v}"
  shows "ConclusiveReason p x act w \<longrightarrow> OptimalAct p x act w"
proof
  assume "ConclusiveReason p x act w"
  show "OptimalAct p x act w"
    unfolding OptimalAct_def assms
    using `ConclusiveReason p x act w` by auto
qed
```

---

## 4. Lean 4 Formalization

We have symmetrically formalized this Qualitative Reasons Framework in `UNC/Reasons.lean`:

```lean
def ConclusiveReason (p : Perspective) (x : Agent) (act : Action) (w : World) : Prop :=
  ∃ q1, Supports p q1 x act w ∧
    ∀ act' q2, act' ≠ act ∧ Supports p q2 x act' w → ReasonPref p q1 q2 w

theorem conclusive_implies_optimal (p : Perspective) (x : Agent) (act : Action) (w : World)
  (h_B : ∀ v, B p w v ↔ (∀ x' act', ConclusiveReason p x' act' w → Does x' act' v)) :
  ConclusiveReason p x act w → OptimalAct p x act w := by
  intro h_concl v h_B_v
  have h_cond := (h_B v).mp h_B_v
  exact h_cond x act h_concl
```

This completes the mathematical and structural symmetrization of Qualitative Reasons in both theorem provers.

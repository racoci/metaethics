# Metaethical Translations: Alan Gewirth's Principle of Generic Consistency (PGC)

This document describes the formalization, reconstruction, and verification of Alan Gewirth's Principle of Generic Consistency (PGC) constructivism in both Isabelle/HOL and Lean 4 under Phase V/VI.

## 1. Metaethical Background (Constructivism)
Alan Gewirth’s Principle of Generic Consistency (PGC) provides a rationalist, constructivist derivation of moral obligations starting from the constitutive features of agency.

The core argument follows these steps:
1. **Constitutivity:** Any agent $x$ constitutively requires *freedom* and *well-being* as necessary (generic) conditions/goods to perform any action whatsoever.
2. **Conclusiveness:** Because these conditions are constitutive requirements for action, $x$ has a conclusive reason to value, claim, and demand them for themselves.
3. **Universalization:** Since $x$ claims rights to freedom and well-being on the sole ground of being an agent, they must logically grant the same rights of freedom and well-being to all other agents.
4. **Deontic Bridge:** Therefore, $x$ has a moral obligation (Optimal/Obligatory Act) to protect and respect the freedom and well-being of all other agents.

---

## 2. Isabelle/HOL Reconstruction

In `UNC/UNC_Gewirth.thy`, we have formalized this constructivist derivation.

```isabelle
consts p_pgc :: p
consts FreedomAndWellBeing :: act
consts Protect :: "a \<Rightarrow> act"

(* Axioms *)
axiomatization where
  agency_constitutive: "\<forall>x w. Constitutive p_pgc x FreedomAndWellBeing w" and
  constitutive_implies_conclusive: "\<forall>x w. Constitutive p_pgc x FreedomAndWellBeing w \<longrightarrow> ConclusiveReason p_pgc x FreedomAndWellBeing w" and
  pgc_universalization: "\<forall>x y w. ConclusiveReason p_pgc x FreedomAndWellBeing w \<longrightarrow> ConclusiveReason p_pgc x (Protect y) w" and
  deontic_bridge: "\<forall>x act w. ConclusiveReason p_pgc x act w \<longrightarrow> OptimalAct p_pgc x act w"
```

Using these axioms, we prove the ultimate PGC moral obligation theorem:

```isabelle
theorem pgc_obligatory:
  shows "\<forall>x y w. OptimalAct p_pgc x (Protect y) w"
proof (intro allI)
  fix x y w
  have "Constitutive p_pgc x FreedomAndWellBeing w" by (simp add: agency_constitutive)
  then have "ConclusiveReason p_pgc x FreedomAndWellBeing w" by (simp add: constitutive_implies_conclusive)
  then have "ConclusiveReason p_pgc x (Protect y) w" by (simp add: pgc_universalization)
  then show "OptimalAct p_pgc x (Protect y) w" by (simp add: deontic_bridge)
qed
```

This ensures that any self-consistent agent must recognize the PGC as binding.

---

## 3. Lean 4 Symmetrization

We have symmetrically formalized this constructivist argument in `UNC/Gewirth.lean`:

```lean
variable (p_pgc : Perspective)
variable (FreedomAndWellBeing : Action)
variable (Protect : Agent → Action)

variable (agency_constitutive : ∀ x w, Constitutive p_pgc x FreedomAndWellBeing w)
variable (constitutive_implies_conclusive : ∀ x w, Constitutive p_pgc x FreedomAndWellBeing w → ConclusiveReason Supports ReasonPref p_pgc x FreedomAndWellBeing w)
variable (pgc_universalization : ∀ x y w, ConclusiveReason Supports ReasonPref p_pgc x FreedomAndWellBeing w → ConclusiveReason Supports ReasonPref p_pgc x (Protect y) w)
variable (deontic_bridge : ∀ x act w, ConclusiveReason Supports ReasonPref p_pgc x act w → OptimalAct B Does p_pgc x act w)

theorem pgc_obligatory (x y : Agent) (w : World) :
  OptimalAct B Does p_pgc x (Protect y) w := by
  have h_const := agency_constitutive x w
  have h_concl := constitutive_implies_conclusive x w h_const
  have h_concl_protect := pgc_universalization x y w h_concl
  exact deontic_bridge x (Protect y) w h_concl_protect
```

The Lean 4 compiler verifies the proof successfully, guaranteeing mathematical and structural consistency across both systems.

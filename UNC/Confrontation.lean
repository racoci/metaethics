import UNC
import UNC.Basic

universe u

section Confrontation

variable {World : Type u} {Agent : Type u} {Perspective : Type u} {Action : Type u}

-- 1. Core Deontic & Selection Predicate Mappings
variable (B : Perspective → World → World → Prop)
variable (Does : Agent → Action → World → Prop)

-- 2. Define perspectives for Deontology (Kant) and Rule Utilitarianism
variable (p_kant p_util : Perspective)

-- 3. Define qualitative utility, assertion, and instrumentalization predicates (ordered strictly)
variable (UtilityMax : Action → World → Prop)
variable (ExecAssert : Agent → (World → Prop) → World → Prop)
variable (Instrumentalize : Agent → World → Prop)

-- Define OptimalAct locally matching UNC reasons/gewirth
def OptimalAct (p : Perspective) (x : Agent) (act : Action) (w : World) : Prop :=
  ∀ v, B p w v → Does x act v

-- 4. Conditional "No Conflict" / "Practical Convergence" Scenario
def NoConflict (w : World) : Prop :=
  ∀ x act, UtilityMax act w ↔ ¬(∃ y, ExecAssert x (Instrumentalize y) w)

-- 5. Theorem: Practical Convergence (Action-Level Equivalence)
theorem action_equivalence
  (h_kant_def : ∀ x act w, OptimalAct B Does p_kant x act w ↔ ¬(∃ y, ExecAssert x (Instrumentalize y) w))
  (h_util_def : ∀ x act w, OptimalAct B Does p_util x act w ↔ UtilityMax act w)
  (h_nc : NoConflict UtilityMax ExecAssert Instrumentalize w) (x : Agent) (act : Action) :
  OptimalAct B Does p_kant x act w ↔ OptimalAct B Does p_util x act w := by
  have h_kant := h_kant_def x act w
  have h_util := h_util_def x act w
  have h_nc_x := h_nc x act
  rw [h_kant, h_util, h_nc_x]

-- 6. Theorem: Set-Level Equivalence of Optimal Selection Worlds
theorem B_set_equivalence
  (h_kant_def : ∀ x act w, OptimalAct B Does p_kant x act w ↔ ¬(∃ y, ExecAssert x (Instrumentalize y) w))
  (h_util_def : ∀ x act w, OptimalAct B Does p_util x act w ↔ UtilityMax act w)
  (h_B_kant : ∀ w v, B p_kant w v ↔ (∀ x act, OptimalAct B Does p_kant x act w → Does x act v))
  (h_B_util : ∀ w v, B p_util w v ↔ (∀ x act, OptimalAct B Does p_util x act w → Does x act v))
  (h_nc : NoConflict UtilityMax ExecAssert Instrumentalize w) (v : World) :
  B p_kant w v ↔ B p_util w v := by
  have h_kant := h_B_kant w v
  have h_util := h_B_util w v
  rw [h_kant, h_util]
  apply Iff.intro
  · intro h_k x act h_opt_util
    have h_equiv := action_equivalence B Does p_kant p_util UtilityMax ExecAssert Instrumentalize h_kant_def h_util_def h_nc x act
    have h_opt_kant := h_equiv.mpr h_opt_util
    exact h_k x act h_opt_kant
  · intro h_u x act h_opt_kant
    have h_equiv := action_equivalence B Does p_kant p_util UtilityMax ExecAssert Instrumentalize h_kant_def h_util_def h_nc x act
    have h_opt_util := h_equiv.mp h_opt_kant
    exact h_u x act h_opt_util

-- 7. Theorem: Local Deontic Equivalence under NoConflict
theorem local_deontic_equivalence
  (h_kant_def : ∀ x act w, OptimalAct B Does p_kant x act w ↔ ¬(∃ y, ExecAssert x (Instrumentalize y) w))
  (h_util_def : ∀ x act w, OptimalAct B Does p_util x act w ↔ UtilityMax act w)
  (h_B_kant : ∀ w v, B p_kant w v ↔ (∀ x act, OptimalAct B Does p_kant x act w → Does x act v))
  (h_B_util : ∀ w v, B p_util w v ↔ (∀ x act, OptimalAct B Does p_util x act w → Does x act v))
  (h_nc : NoConflict UtilityMax ExecAssert Instrumentalize w) (phi : World → Prop) :
  UNCobligatory B p_kant phi w ↔ UNCobligatory B p_util phi w := by
  apply Iff.intro
  · intro h_k v hb_u
    have hb_k : B p_kant w v := (B_set_equivalence B Does p_kant p_util UtilityMax ExecAssert Instrumentalize h_kant_def h_util_def h_B_kant h_B_util h_nc v).mpr hb_u
    exact h_k v hb_k
  · intro h_u v hb_k
    have hb_u : B p_util w v := (B_set_equivalence B Does p_kant p_util UtilityMax ExecAssert Instrumentalize h_kant_def h_util_def h_B_kant h_B_util h_nc v).mp hb_k
    exact h_u v hb_u

-- 8. Theorem: Global Deontic Equivalence under Global Harmony
theorem global_deontic_equivalence
  (h_kant_def : ∀ x act w, OptimalAct B Does p_kant x act w ↔ ¬(∃ y, ExecAssert x (Instrumentalize y) w))
  (h_util_def : ∀ x act w, OptimalAct B Does p_util x act w ↔ UtilityMax act w)
  (h_B_kant : ∀ w v, B p_kant w v ↔ (∀ x act, OptimalAct B Does p_kant x act w → Does x act v))
  (h_B_util : ∀ w v, B p_util w v ↔ (∀ x act, OptimalAct B Does p_util x act w → Does x act v))
  (h_nc_global : ∀ w, NoConflict UtilityMax ExecAssert Instrumentalize w) (phi : World → Prop) (w : World) :
  UNCobligatory B p_kant phi w ↔ UNCobligatory B p_util phi w := by
  exact local_deontic_equivalence B Does p_kant p_util UtilityMax ExecAssert Instrumentalize h_kant_def h_util_def h_B_kant h_B_util (h_nc_global w) phi

end Confrontation

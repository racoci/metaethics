import UNC
import UNC.Basic

universe u

section DiscourseEthics

variable {World : Type u} {Agent : Type u} {Perspective : Type u}
variable (B : Perspective → World → World → Prop)

-- 1. Speech Acts, Agents, and Perspectives
variable (Accepts : Agent → (World → Prop) → (World → Prop))
variable (OptimalAct : Perspective → Agent → (World → Prop) → (World → Prop))
variable (p_discourse : Perspective)

-- 2. Principle of Universalization (U) as a Validity Bridge
variable (U_principle : ∀ x N w, OptimalAct p_discourse x N w ↔ ∀ a, Accepts a N w)

-- 3. Convergence Condition between Procedural Consensus and another Metaethical Perspective
def ConvergenceCond (p_dis p_other : Perspective) : Prop :=
  ∀ x N w, (∀ a, Accepts a N w) ↔ UNCobligatory B p_other N w

-- 4. Procedural Deontic Equivalence Theorem
theorem procedural_deontic_equivalence (p_other : Perspective)
  (h_conv : ConvergenceCond B Accepts p_discourse p_other) :
  ∀ x N w, OptimalAct p_discourse x N w ↔ UNCobligatory B p_other N w :=
by
  intro x N w
  have h_U := U_principle x N w
  have h_C := h_conv x N w
  apply Iff.intro
  · intro h_opt
    have h_acc : ∀ a, Accepts a N w := h_U.mp h_opt
    exact h_C.mp h_acc
  · intro h_obl
    have h_acc : ∀ a, Accepts a N w := h_C.mpr h_obl
    exact h_U.mpr h_acc

end DiscourseEthics

import UNC

universe u

section Pragmatics

variable {World : Type u} {Agent : Type u} {Perspective : Type u}

-- 1. Speech Acts & Discursive Constants
variable (ExecArgue : Agent → (World → Prop) → (World → Prop))
variable (ExecAssert : Agent → (World → Prop) → (World → Prop))
variable (Presuppose : Agent → (World → Prop) → (World → Prop))
variable (N_ver : World → Prop)
variable (N_eq : World → Prop)
variable (p_discourse : Perspective)
variable (B : Perspective → World → World → Prop)

-- 2. Axioms of Discursive Constitutivity
variable (argue_assert : ∀ a phi w, ExecArgue a phi w → ExecAssert a phi w)
variable (argue_presuppose_ver : ∀ a phi w, ExecArgue a phi w → Presuppose a N_ver w)
variable (argue_presuppose_eq : ∀ a phi w, ExecArgue a phi w → Presuppose a N_eq w)

-- 3. Deontic Output under the Discourse Perspective
variable (deontic_output_ver : ∀ a phi w, ExecArgue a phi w → (∀ v, B p_discourse w v → N_ver v))
variable (deontic_output_eq : ∀ a phi w, ExecArgue a phi w → (∀ v, B p_discourse w v → N_eq v))

-- 4. Performative Contradiction Predicate
def PC (a : Agent) (chi : World → Prop) (w : World) : Prop :=
  ExecAssert a chi w ∧ ∃ psi : World → Prop, Presuppose a psi w ∧ (∀ v, chi v → ¬ psi v)

-- 5. Transcendental Bridge Theorem (The Deduction)
theorem transcendental_bridge (a : Agent) (w : World) (h_argue : ExecArgue a (fun w => ¬ N_ver w) w) :
  PC ExecAssert Presuppose a (fun w => ¬ N_ver w) w := by
  have h_assert := argue_assert a (fun w => ¬ N_ver w) w h_argue
  have h_presup := argue_presuppose_ver a (fun w => ¬ N_ver w) w h_argue
  apply And.intro h_assert
  use N_ver
  apply And.intro h_presup
  intro v h_not_ver
  exact h_not_ver

end Pragmatics

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

end Pragmatics

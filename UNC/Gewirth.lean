import UNC
import UNC.Reasons

universe u

variable {World : Type u} {Agent : Type u} {Reason : Type u} {Perspective : Type u} {Action : Type u}
variable (B : Perspective → World → World → Prop)
variable (Supports : Perspective → Reason → Agent → Action → World → Prop)
variable (Does : Agent → Action → World → Prop)
variable (ReasonPref : Perspective → Reason → Reason → World → Prop)
variable (Constitutive : Perspective → Agent → Action → World → Prop)

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

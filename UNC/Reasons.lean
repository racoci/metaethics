import UNC

universe u

variable {World : Type u} {Agent : Type u} {Reason : Type u} {Perspective : Type u} {Action : Type u}
variable (B : Perspective → World → World → Prop)
variable (Supports : Perspective → Reason → Agent → Action → World → Prop)
variable (Does : Agent → Action → World → Prop)
variable (ReasonPref : Perspective → Reason → Reason → World → Prop)

def OptimalAct (p : Perspective) (x : Agent) (act : Action) (w : World) : Prop :=
  ∀ v, B p w v → Does x act v

def ConclusiveReason (p : Perspective) (x : Agent) (act : Action) (w : World) : Prop :=
  ∃ q1, Supports p q1 x act w ∧
    ∀ act' q2, act' ≠ act ∧ Supports p q2 x act' w → ReasonPref p q1 q2 w

theorem conclusive_implies_optimal (p : Perspective) (x : Agent) (act : Action) (w : World)
  (h_B : ∀ v, B p w v ↔ (∀ x' act', ConclusiveReason p x' act' w → Does x' act' v)) :
  ConclusiveReason p x act w → OptimalAct p x act w := by
  intro h_concl v h_B_v
  have h_cond := (h_B v).mp h_B_v
  exact h_cond x act h_concl

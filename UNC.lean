section UNC

universe u
variable {World : Type u}
variable {Agent : Type u}
variable {Reason : Type u}
variable {Perspective : Type u}
variable {Action : Type u}

def UNCProp (W : Type u) := W → Prop

def UNCimp (p q : UNCProp World) : UNCProp World := fun w => p w → q w

def UNCvalid (p : UNCProp World) : Prop := ∀ w, p w

variable (B : Perspective → World → World → Prop)

def UNCobligatory (p : Perspective) (phi : UNCProp World) : UNCProp World :=
  fun w => ∀ v, B p w v → phi v

def UNCpermissible (p : Perspective) (phi : UNCProp World) : UNCProp World :=
  fun w => ∃ v, B p w v ∧ phi v

theorem D_axiom_lean 
  (serial : ∀ p w, ∃ v, B p w v) 
  (p : Perspective) (phi : UNCProp World) : 
  UNCvalid (UNCimp (UNCobligatory B p phi) (UNCpermissible B p phi)) :=
by
  intro w
  intro h_obl
  have h_serial := serial p w
  match h_serial with
  | ⟨v, hb⟩ =>
    have h_phi_v := h_obl v hb
    exact ⟨v, ⟨hb, h_phi_v⟩⟩

variable (Supports : Perspective → Reason → Agent → Action → World → Prop)

def OntoEquiv (p1 p2 : Perspective) : Prop :=
  ∀ q a act w, Supports p1 q a act w ↔ Supports p2 q a act w

def DeonticEquiv (p1 p2 : Perspective) : Prop :=
  ∀ phi w, UNCobligatory B p1 phi w ↔ UNCobligatory B p2 phi w

theorem identical_B_deontic_equiv (p1 p2 : Perspective) (h : ∀ w v, B p1 w v ↔ B p2 w v) :
  DeonticEquiv B p1 p2 :=
by
  intro phi w
  apply Iff.intro
  · intro h1 v hb2
    have hb1 : B p1 w v := (h w v).mpr hb2
    exact h1 v hb1
  · intro h2 v hb1
    have hb2 : B p2 w v := (h w v).mp hb1
    exact h2 v hb2

end UNC

import UNC

universe u

inductive Form (Agent : Type u) (Action : Type u) (Perspective : Type u)
  | Atom : Agent → Action → Form Agent Action Perspective
  | Not : Form Agent Action Perspective → Form Agent Action Perspective
  | And : Form Agent Action Perspective → Form Agent Action Perspective → Form Agent Action Perspective
  | Oblig : Perspective → Form Agent Action Perspective → Form Agent Action Perspective
  | Knows : Agent → Form Agent Action Perspective → Form Agent Action Perspective

variable {World : Type u} {Agent : Type u} {Perspective : Type u} {Action : Type u}
variable (Does : Agent → Action → World → Prop)
variable (B : Perspective → World → World → Prop)
variable (R_K : Agent → World → World → Prop)

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

def eval : Form Agent Action Perspective → World → Prop
  | Form.Atom x act => fun w => Does x act w
  | Form.Not phi => fun w => ¬(eval Does B R_K phi w)
  | Form.And phi psi => fun w => eval Does B R_K phi w ∧ eval Does B R_K psi w
  | Form.Oblig p phi => fun w => ∀ v, B p w v → eval Does B R_K phi v
  | Form.Knows x phi => fun w => ∀ v, R_K x w v → eval Does B R_K phi v

def Bisimulation (Z : World → World → Prop) : Prop :=
  ∀ w1 w2, Z w1 w2 →
    (∀ x act, Does x act w1 ↔ Does x act w2) ∧
    (∀ p v1, B p w1 v1 → ∃ v2, B p w2 v2 ∧ Z v1 v2) ∧
    (∀ p v2, B p w2 v2 → ∃ v1, B p w1 v1 ∧ Z v1 v2) ∧
    (∀ x v1, R_K x w1 v1 → ∃ v2, R_K x w2 v2 ∧ Z v1 v2) ∧
    (∀ x v2, R_K x w2 v2 → ∃ v1, R_K x w1 v1 ∧ Z v1 v2)

theorem bisimulation_invariance (Z : World → World → Prop)
  (h_bisim : Bisimulation Does B R_K Z)
  (w1 w2 : World) (h_z : Z w1 w2) (phi : Form Agent Action Perspective) :
  eval Does B R_K phi w1 ↔ eval Does B R_K phi w2 := by
  induction phi generalizing w1 w2 with
  | Atom x act =>
    have h_atom := (h_bisim w1 w2 h_z).1 x act
    exact h_atom
  | Not phi ih =>
    have h_ih := ih w1 w2 h_z
    simp only [eval]
    rw [h_ih]
  | And phi psi ih_phi ih_psi =>
    have h_ih_phi := ih_phi w1 w2 h_z
    have h_ih_psi := ih_psi w1 w2 h_z
    simp only [eval]
    rw [h_ih_phi, h_ih_psi]
  | Oblig p phi ih =>
    simp only [eval]
    apply Iff.intro
    · intro h v2 hb2
      have h_back := (h_bisim w1 w2 h_z).2.2.1 p v2 hb2
      match h_back with
      | ⟨v1, ⟨hb1, h_zv⟩⟩ =>
        have h_phi_v1 := h v1 hb1
        have h_ih := ih v1 v2 h_zv
        rw [← h_ih]
        exact h_phi_v1
    · intro h v1 hb1
      have h_fwd := (h_bisim w1 w2 h_z).2.1 p v1 hb1
      match h_fwd with
      | ⟨v2, ⟨hb2, h_zv⟩⟩ =>
        have h_phi_v2 := h v2 hb2
        have h_ih := ih v1 v2 h_zv
        rw [h_ih]
        exact h_phi_v2
  | Knows x phi ih =>
    simp only [eval]
    apply Iff.intro
    · intro h v2 hr2
      have h_back := (h_bisim w1 w2 h_z).2.2.2.2 x v2 hr2
      match h_back with
      | ⟨v1, ⟨hr1, h_zv⟩⟩ =>
        have h_phi_v1 := h v1 hr1
        have h_ih := ih v1 v2 h_zv
        rw [← h_ih]
        exact h_phi_v1
    · intro h v1 hr1
      have h_fwd := (h_bisim w1 w2 h_z).2.2.2.1 x v1 hr1
      match h_fwd with
      | ⟨v2, ⟨hr2, h_zv⟩⟩ =>
        have h_phi_v2 := h v2 hr2
        have h_ih := ih v1 v2 h_zv
        rw [h_ih]
        exact h_phi_v2

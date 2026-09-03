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

variable (list_B : Perspective → World → List World)
variable (list_R_K : Agent → World → List World)

def conj_all (x : Agent) (act : Action) : List (Form Agent Action Perspective) → Form Agent Action Perspective
  | [] => Form.Not (Form.And (Form.Atom x act) (Form.Not (Form.Atom x act)))
  | [phi] => phi
  | phi :: psi :: gamma => Form.And phi (conj_all x act (psi :: gamma))

def disj_all (x : Agent) (act : Action) : List (Form Agent Action Perspective) → Form Agent Action Perspective
  | [] => Form.And (Form.Atom x act) (Form.Not (Form.Atom x act))
  | [phi] => phi
  | phi :: psi :: gamma => Form.Not (Form.And (Form.Not phi) (Form.Not (disj_all x act (psi :: gamma))))

theorem eval_conj_all (x : Agent) (act : Action) (w : World) :
  (L : List (Form Agent Action Perspective)) →
  (eval Does B R_K (conj_all x act L) w ↔ (∀ phi ∈ L, eval Does B R_K phi w))
  | [] => by
    simp [conj_all, eval]
  | [phi] => by
    simp [conj_all, eval]
  | phi :: psi :: gamma => by
    simp only [conj_all, eval]
    rw [eval_conj_all x act w (psi :: gamma)]
    simp

theorem eval_disj_all (x : Agent) (act : Action) (w : World) :
  (L : List (Form Agent Action Perspective)) →
  (eval Does B R_K (disj_all x act L) w ↔ (∃ phi ∈ L, eval Does B R_K phi w))
  | [] => by
    simp [disj_all, eval]
  | [phi] => by
    simp [disj_all, eval]
  | phi :: psi :: gamma => by
    simp only [disj_all, eval]
    rw [eval_disj_all x act w (psi :: gamma)]
    simp [or_assoc]

def char_form (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective) (x0 : Agent) (act0 : Action) : Nat → World → Form Agent Action Perspective
  | 0, w =>
    conj_all x0 act0 (atoms.map (fun (x, act) => if Does x act w then Form.Atom x act else Form.Not (Form.Atom x act)))
  | Nat.succ n, w =>
    Form.And (char_form atoms as ps x0 act0 n w)
      (Form.And (conj_all x0 act0 (ps.map (fun p =>
        Form.And (Form.Oblig p (disj_all x0 act0 ((list_B p w).map (fun v => char_form atoms as ps x0 act0 n v))))
                 (conj_all x0 act0 ((list_B p w).map (fun v => Form.Not (Form.Oblig p (Form.Not (char_form atoms as ps x0 act0 n v))))))
      )))
      (conj_all x0 act0 (as.map (fun x =>
        Form.And (Form.Knows x (disj_all x0 act0 ((list_R_K x w).map (fun v => char_form atoms as ps x0 act0 n v))))
                 (conj_all x0 act0 ((list_R_K x w).map (fun v => Form.Not (Form.Knows x (Form.Not (char_form atoms as ps x0 act0 n v))))))
      ))))

def n_bisim_list (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective) : Nat → World → World → Prop
  | 0, w1, w2 => ∀ x act, (x, act) ∈ atoms → (Does x act w1 ↔ Does x act w2)
  | Nat.succ n, w1, w2 =>
    n_bisim_list atoms as ps n w1 w2 ∧
    (∀ p ∈ ps, ∀ v1, B p w1 v1 → ∃ v2, B p w2 v2 ∧ n_bisim_list atoms as ps n v1 v2) ∧
    (∀ p ∈ ps, ∀ v2, B p w2 v2 → ∃ v1, B p w1 v1 ∧ n_bisim_list atoms as ps n v1 v2) ∧
    (∀ x ∈ as, ∀ v1, R_K x w1 v1 → ∃ v2, R_K x w2 v2 ∧ n_bisim_list atoms as ps n v1 v2) ∧
    (∀ x ∈ as, ∀ v2, R_K x w2 v2 → ∃ v1, R_K x w1 v1 ∧ n_bisim_list atoms as ps n v1 v2)

theorem char_form_property (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective)
  (x0 : Agent) (act0 : Action) (list_B_sound : ∀ p w v, v ∈ list_B p w ↔ B p w v)
  (list_R_K_sound : ∀ x w v, v ∈ list_R_K x w ↔ R_K x w v) (n : Nat) (w v : World) :
  eval Does B R_K (char_form Does list_B list_R_K atoms as ps x0 act0 n w) v ↔ n_bisim_list Does B R_K atoms as ps n w v := by
  induction n generalizing w v with
  | zero =>
    simp only [char_form, n_bisim_list]
    rw [eval_conj_all Does B R_K x0 act0 _ v]
    simp only [List.mem_map, Prod.exists, exists_and_right]
    apply Iff.intro
    · intro h x act h_in
      have h_mem : (if Does x act w then Form.Atom x act else Form.Not (Form.Atom x act)) ∈ List.map (fun (x, act) => if Does x act w then Form.Atom x act else Form.Not (Form.Atom x act)) atoms := by
        apply List.mem_map_of_mem
        exact h_in
      have h_eval := h _ h_mem
      split_ifs at h_eval with h_does
      · simp [eval] at h_eval
        apply Iff.intro (fun _ => h_eval) (fun _ => h_does)
      · simp [eval] at h_eval
        apply Iff.intro (fun h_v => False.elim (h_eval h_v)) (fun h_w => False.elim (h_does h_w))
    · intro h phi h_phi
      rcases List.mem_map.mp h_phi with ⟨⟨x, act⟩, ⟨h_in, rfl⟩⟩
      have h_eq := h x act h_in
      split_ifs with h_does
      · simp only [eval]
        exact h_eq.mp h_does
      · simp only [eval]
        exact fun h_v => h_does (h_eq.mpr h_v)
  | succ n _ =>
    sorry

def depth : Form Agent Action Perspective → Nat
  | Form.Atom _ _ => 0
  | Form.Not phi => depth phi
  | Form.And phi psi => Nat.max (depth phi) (depth psi)
  | Form.Oblig _ phi => depth phi + 1
  | Form.Knows _ phi => depth phi + 1

def wf_form (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective) : Form Agent Action Perspective → Prop
  | Form.Atom x act => (x, act) ∈ atoms
  | Form.Not phi => wf_form atoms as ps phi
  | Form.And phi psi => wf_form atoms as ps phi ∧ wf_form atoms as ps psi
  | Form.Oblig p phi => p ∈ ps ∧ wf_form atoms as ps phi
  | Form.Knows x phi => x ∈ as ∧ wf_form atoms as ps phi

def logical_equiv_list (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective) (n : Nat) (w v : World) : Prop :=
  ∀ phi, wf_form atoms as ps phi → depth phi ≤ n → (eval Does B R_K phi w ↔ eval Does B R_K phi v)

theorem depth_conj_all (x : Agent) (act : Action) (n : Nat) :
  (L : List (Form Agent Action Perspective)) →
  (∀ phi ∈ L, depth phi ≤ n) → depth (conj_all x act L) ≤ n
  | [], _ => by simp [conj_all, depth]
  | [phi], h => by
    simp only [conj_all]
    exact h phi (by simp)
  | phi :: psi :: gamma, h => by
    simp only [conj_all, depth]
    have h_phi := h phi (by simp)
    have h_rest := depth_conj_all x act n (psi :: gamma) (by
      intro f hf
      apply h f
      simp [hf]
    )
    exact Nat.max_le.mpr ⟨h_phi, h_rest⟩

theorem depth_disj_all (x : Agent) (act : Action) (n : Nat) :
  (L : List (Form Agent Action Perspective)) →
  (∀ phi ∈ L, depth phi ≤ n) → depth (disj_all x act L) ≤ n
  | [], _ => by simp [disj_all, depth]
  | [phi], h => by
    simp only [disj_all]
    exact h phi (by simp)
  | phi :: psi :: gamma, h => by
    simp only [disj_all, depth]
    have h_phi := h phi (by simp)
    have h_rest := depth_disj_all x act n (psi :: gamma) (by
      intro f hf
      apply h f
      simp [hf]
    )
    exact h_rest

theorem wf_form_conj_all (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective)
  (x : Agent) (act : Action) (h_atom : (x, act) ∈ atoms) :
  (L : List (Form Agent Action Perspective)) →
  (∀ phi ∈ L, wf_form atoms as ps phi) → wf_form atoms as ps (conj_all x act L)
  | [], _ => by
    simp only [conj_all, wf_form]
    exact ⟨h_atom, h_atom⟩
  | [phi], h => by
    simp only [conj_all]
    exact h phi (by simp)
  | phi :: psi :: gamma, h => by
    simp only [conj_all, wf_form]
    have h_phi := h phi (by simp)
    have h_rest := wf_form_conj_all atoms as ps x act h_atom (psi :: gamma) (by
      intro f hf
      apply h f
      simp [hf]
    )
    exact ⟨h_phi, h_rest⟩

theorem wf_form_disj_all (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective)
  (x : Agent) (act : Action) (h_atom : (x, act) ∈ atoms) :
  (L : List (Form Agent Action Perspective)) →
  (∀ phi ∈ L, wf_form atoms as ps phi) → wf_form atoms as ps (disj_all x act L)
  | [], _ => by
    simp only [disj_all, wf_form]
    exact ⟨h_atom, h_atom⟩
  | [phi], h => by
    simp only [disj_all]
    exact h phi (by simp)
  | phi :: psi :: gamma, h => by
    simp only [disj_all, wf_form]
    have h_phi := h phi (by simp)
    have h_rest := wf_form_disj_all atoms as ps x act h_atom (psi :: gamma) (by
      intro f hf
      apply h f
      simp [hf]
    )
    exact ⟨h_phi, h_rest⟩

theorem depth_char_form (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective)
  (x0 : Agent) (act0 : Action) (n : Nat) (w : World) :
  depth (char_form Does list_B list_R_K atoms as ps x0 act0 n w) ≤ n := by
  induction n generalizing w with
  | zero =>
    simp [char_form]
    apply depth_conj_all _ _ 0
    intro phi h_phi
    simp only [List.mem_map, Prod.exists, exists_and_right] at h_phi
    rcases h_phi with ⟨⟨x, act⟩, ⟨_, rfl⟩⟩
    split_ifs <;> simp [depth]
  | succ n ih =>
    simp only [char_form, depth]
    apply Nat.max_le.mpr
    constructor
    · exact ih w
    · apply Nat.max_le.mpr
      constructor
      · apply depth_conj_all _ _ n
        intro phi h_phi
        simp only [List.mem_map] at h_phi
        rcases h_phi with ⟨p, ⟨_, rfl⟩⟩
        simp only [depth]
        apply Nat.max_le.mpr
        constructor
        · apply Nat.succ_le_succ
          apply depth_disj_all _ _ n
          intro f hf
          simp only [List.mem_map] at hf
          rcases hf with ⟨v, ⟨_, rfl⟩⟩
          exact ih v
        · apply depth_conj_all _ _ n
          intro f hf
          simp only [List.mem_map] at hf
          rcases hf with ⟨v, ⟨_, rfl⟩⟩
          simp only [depth]
          exact Nat.succ_le_succ (ih v)
      · apply depth_conj_all _ _ n
        intro phi h_phi
        simp only [List.mem_map] at h_phi
        rcases h_phi with ⟨x, ⟨_, rfl⟩⟩
        simp only [depth]
        apply Nat.max_le.mpr
        constructor
        · apply Nat.succ_le_succ
          apply depth_disj_all _ _ n
          intro f hf
          simp only [List.mem_map] at hf
          rcases hf with ⟨v, ⟨_, rfl⟩⟩
          exact ih v
        · apply depth_conj_all _ _ n
          intro f hf
          simp only [List.mem_map] at hf
          rcases hf with ⟨v, ⟨_, rfl⟩⟩
          simp only [depth]
          exact Nat.succ_le_succ (ih v)

theorem wf_form_char_form (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective)
  (x0 : Agent) (act0 : Action) (h0 : (x0, act0) ∈ atoms) (n : Nat) (w : World) :
  wf_form atoms as ps (char_form Does list_B list_R_K atoms as ps x0 act0 n w) := by
  induction n generalizing w with
  | zero =>
    simp [char_form]
    apply wf_form_conj_all _ _ _ _ _ h0
    intro phi h_phi
    simp only [List.mem_map, Prod.exists, exists_and_right] at h_phi
    rcases h_phi with ⟨⟨x, act⟩, ⟨h_in, rfl⟩⟩
    split_ifs <;> simp [wf_form] <;> exact h_in
  | succ n ih =>
    simp only [char_form, wf_form]
    refine ⟨ih w, ?_⟩
    constructor
    · apply wf_form_conj_all _ _ _ _ _ h0
      intro phi h_phi
      simp only [List.mem_map] at h_phi
      rcases h_phi with ⟨p, ⟨hp, rfl⟩⟩
      simp only [wf_form]
      constructor
      · constructor
        · exact hp
        · apply wf_form_disj_all _ _ _ _ _ h0
          intro f hf
          simp only [List.mem_map] at hf
          rcases hf with ⟨v, ⟨_, rfl⟩⟩
          exact ih v
      · apply wf_form_conj_all _ _ _ _ _ h0
        intro f hf
        simp only [List.mem_map] at hf
        rcases hf with ⟨v, ⟨_, rfl⟩⟩
        simp only [wf_form]
        exact ⟨hp, ih v⟩
    · apply wf_form_conj_all _ _ _ _ _ h0
      intro phi h_phi
      simp only [List.mem_map] at h_phi
      rcases h_phi with ⟨x, ⟨hx, rfl⟩⟩
      simp only [wf_form]
      constructor
      · constructor
        · exact hx
        · apply wf_form_disj_all _ _ _ _ _ h0
          intro f hf
          simp only [List.mem_map] at hf
          rcases hf with ⟨v, ⟨_, rfl⟩⟩
          exact ih v
      · apply wf_form_conj_all _ _ _ _ _ h0
        intro f hf
        simp only [List.mem_map] at hf
        rcases hf with ⟨v, ⟨_, rfl⟩⟩
        simp only [wf_form]
        exact ⟨hx, ih v⟩

theorem n_bisim_list_refl (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective) (n : Nat) (w : World) :
  n_bisim_list Does B R_K atoms as ps n w w := by
  induction n generalizing w with
  | zero =>
    simp [n_bisim_list]
  | succ n ih =>
    simp only [n_bisim_list]
    refine ⟨ih w, ?_, ?_, ?_, ?_⟩
    · intro p _ v1 hb1; exact ⟨v1, ⟨hb1, ih v1⟩⟩
    · intro p _ v2 hb2; exact ⟨v2, ⟨hb2, ih v2⟩⟩
    · intro x _ v1 hr1; exact ⟨v1, ⟨hr1, ih v1⟩⟩
    · intro x _ v2 hr2; exact ⟨v2, ⟨hr2, ih v2⟩⟩

theorem hennessy_milner_logical_equiv_implies_bisim (atoms : List (Agent × Action)) (as : List Agent) (ps : List Perspective)
  (x0 : Agent) (act0 : Action) (h0 : (x0, act0) ∈ atoms)
  (list_B_sound : ∀ p w v, v ∈ list_B p w ↔ B p w v)
  (list_R_K_sound : ∀ x w v, v ∈ list_R_K x w ↔ R_K x w v)
  (n : Nat) (w v : World)
  (h_equiv : logical_equiv_list Does B R_K atoms as ps n w v) :
  n_bisim_list Does B R_K atoms as ps n w v := by
  have h_wf := wf_form_char_form Does list_B list_R_K atoms as ps x0 act0 h0 n w
  have h_depth := depth_char_form Does list_B list_R_K atoms as ps x0 act0 n w
  have h_eval_equiv := h_equiv (char_form Does list_B list_R_K atoms as ps x0 act0 n w) h_wf h_depth
  have h_eval_w : eval Does B R_K (char_form Does list_B list_R_K atoms as ps x0 act0 n w) w := by
    rw [char_form_property Does B R_K list_B list_R_K list_B_sound list_R_K_sound atoms as ps x0 act0]
    exact n_bisim_list_refl atoms as ps n w
  have h_eval_v := h_eval_equiv.mp h_eval_w
  rw [← char_form_property Does B R_K list_B list_R_K list_B_sound list_R_K_sound atoms as ps x0 act0]
  exact h_eval_v

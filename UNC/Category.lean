import UNC
import UNC.Basic

universe u

section Category

variable {World : Type u} {Agent : Type u} {Perspective : Type u}
variable (B : Perspective → World → World → Prop)

-- 1. Preorder relation on perspectives
def leq_p (p1 p2 : Perspective) : Prop :=
  ∀ (phi : World → Prop) (w : World), UNCobligatory B p2 phi w → UNCobligatory B p1 phi w

-- 2. Reflexivity of leq_p
theorem leq_p_refl (p : Perspective) : leq_p B p p :=
by
  intro phi w h
  exact h

-- 3. Transitivity of leq_p
theorem leq_p_trans {p1 p2 p3 : Perspective} (h1 : leq_p B p1 p2) (h2 : leq_p B p2 p3) :
  leq_p B p1 p3 :=
by
  intro phi w h
  exact h1 phi w (h2 phi w h)

-- 4. Functors (Monotonic maps)
def mono_functor (F : Perspective → Perspective) : Prop :=
  ∀ p1 p2, leq_p B p1 p2 → leq_p B (F p1) (F p2)

-- 5. Galois Adjunction (Galois Connection)
def adjunction (F G : Perspective → Perspective) : Prop :=
  ∀ p1 p2, leq_p B (F p1) p2 ↔ leq_p B p1 (G p2)

-- 6. Adjunction properties: Extensivity
theorem adjunction_extensive {F G : Perspective → Perspective} (hadj : adjunction B F G) (p : Perspective) :
  leq_p B p (G (F p)) :=
by
  have h := (hadj p (F p)).mp
  exact h (leq_p_refl B (F p))

-- 7. Adjunction properties: Co-extensivity
theorem adjunction_coextensive {F G : Perspective → Perspective} (hadj : adjunction B F G) (p : Perspective) :
  leq_p B (F (G p)) p :=
by
  have h := (hadj (G p) p).mpr
  exact h (leq_p_refl B (G p))

-- 8. Adjunction implies Monotonicity of F
theorem adjunction_mono_F {F G : Perspective → Perspective} (hadj : adjunction B F G) :
  mono_functor B F :=
by
  intro p1 p2 hleq
  -- We know p2 ≤ G (F p2)
  have hext := adjunction_extensive B hadj p2
  -- By transitivity, p1 ≤ G (F p2)
  have htrans := leq_p_trans B hleq hext
  -- By adjunction, F p1 ≤ F p2
  exact (hadj p1 (F p2)).mpr htrans

-- 9. Adjunction implies Monotonicity of G
theorem adjunction_mono_G {F G : Perspective → Perspective} (hadj : adjunction B F G) :
  mono_functor B G :=
by
  intro p1 p2 hleq
  -- We know F (G p1) ≤ p1
  have hcoext := adjunction_coextensive B hadj p1
  -- By transitivity, F (G p1) ≤ p2
  have htrans := leq_p_trans B hcoext hleq
  -- By adjunction, G p1 ≤ G p2
  exact (hadj (G p1) p2).mp htrans

-- 10. Idempotency of closure operator G ∘ F
theorem closure_idempotent_G_F {F G : Perspective → Perspective} (hadj : adjunction B F G) (p : Perspective) :
  leq_p B (G (F (G (F p)))) (G (F p)) ∧ leq_p B (G (F p)) (G (F (G (F p)))) :=
by
  apply And.intro
  · -- F (G (F p)) ≤ F p by co-extensivity of F ∘ G with p := F p
    have hcoext := adjunction_coextensive B hadj (F p)
    -- G is monotonic, so G (F (G (F p))) ≤ G (F p)
    exact adjunction_mono_G B hadj (F (G (F p))) (F p) hcoext
  · -- G (F p) ≤ G (F (G (F p))) by extensivity of G ∘ F with p := G (F p)
    exact adjunction_extensive B hadj (G (F p))

-- 11. Isomorphism / Equivalence on perspectives
def equiv_p (p1 p2 : Perspective) : Prop :=
  leq_p B p1 p2 ∧ leq_p B p2 p1

-- 12. Equivalence of perspectives implies Deontic Equivalence
theorem equiv_p_implies_deontic_equiv {p1 p2 : Perspective} (hequiv : equiv_p B p1 p2) :
  DeonticEquiv B p1 p2 :=
by
  intro phi w
  apply Iff.intro
  · intro h1
    exact hequiv.right phi w h1
  · intro h2
    exact hequiv.left phi w h2

-- 13. Fundamental Theorem: Galois Fixed Points yield Deontic Equivalence
theorem galois_fixed_point_deontic_equivalence {F G : Perspective → Perspective} (hadj : adjunction B F G) (p : Perspective)
  (h_fp : leq_p B (G (F p)) p) :
  DeonticEquiv B p (G (F p)) :=
by
  have h_ext := adjunction_extensive B hadj p
  have h_equiv : equiv_p B p (G (F p)) := And.intro h_ext h_fp
  exact equiv_p_implies_deontic_equiv B h_equiv

end Category

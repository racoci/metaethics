import UNC
import UNC.Category
import UNC.Dialogical

universe u

section GrandSynthesis

variable {World : Type u} {Agent : Type u} {Perspective : Type u} {Action : Type u}
variable (B : Perspective → World → World → Prop)
variable (Does : Agent → Action → World → Prop)
variable (R_K : Agent → World → World → Prop)

-- 1. Definition of Bisimulation (defined locally to prevent dependency compilation issues)
def Bisimulation (Z : World → World → Prop) : Prop :=
  ∀ w1 w2, Z w1 w2 →
    (∀ x act, Does x act w1 ↔ Does x act w2) ∧
    (∀ p v1, B p w1 v1 → ∃ v2, B p w2 v2 ∧ Z v1 v2) ∧
    (∀ p v2, B p w2 v2 → ∃ v1, B p w1 v1 ∧ Z v1 v2) ∧
    (∀ x v1, R_K x w1 v1 → ∃ v2, R_K x w2 v2 ∧ Z v1 v2) ∧
    (∀ x v2, R_K x w2 v2 → ∃ v1, R_K x w1 v1 ∧ Z v1 v2)

-- 2. Parameterized Winning Strategy
-- WinningStrategy_p player perspective world
variable (WinningStrategy_p : Player → Perspective → World → Prop)

-- Theorem: Galois-Game Duality
theorem galois_game_duality
  {F G : Perspective → Perspective}
  (_hadj : adjunction B F G)
  (Z : World → World → Prop)
  (h_bisim : Bisimulation B Does R_K Z)
  (w1 w2 : World)
  (hz : Z w1 w2)
  (p1 p2 : Perspective)
  (hequiv : equiv_p B (F p1) p2)
  (strategic_monotonicity : ∀ (player : Player) (p1 p2 : Perspective) (w : World),
    leq_p B p1 p2 → WinningStrategy_p player p2 w → WinningStrategy_p player p1 w)
  (bisimulation_game_invariance : ∀ (Z : World → World → Prop) (w1 w2 : World) (player : Player) (p : Perspective),
    Bisimulation B Does R_K Z → Z w1 w2 → (WinningStrategy_p player p w1 ↔ WinningStrategy_p player p w2)) :
  WinningStrategy_p player (F p1) w1 ↔ WinningStrategy_p player p2 w2 := by
  apply Iff.intro
  · intro h1
    -- Since equiv_p B (F p1) p2 holds, we have leq_p B p2 (F p1)
    have h_leq : leq_p B p2 (F p1) := hequiv.right
    -- By strategic monotonicity, we get WinningStrategy_p player p2 w1
    have h2_w1 := strategic_monotonicity player p2 (F p1) w1 h_leq h1
    -- By bisimulation game invariance, we get WinningStrategy_p player p2 w2
    exact (bisimulation_game_invariance Z w1 w2 player p2 h_bisim hz).mp h2_w1
  · intro h2
    -- By bisimulation game invariance, we get WinningStrategy_p player p2 w1
    have h2_w1 := (bisimulation_game_invariance Z w1 w2 player p2 h_bisim hz).mpr h2
    -- Since equiv_p B (F p1) p2 holds, we have leq_p B (F p1) p2
    have h_leq : leq_p B (F p1) p2 := hequiv.left
    -- By strategic monotonicity, we get WinningStrategy_p player (F p1) w1
    exact strategic_monotonicity player (F p1) p2 w1 h_leq h2_w1

end GrandSynthesis

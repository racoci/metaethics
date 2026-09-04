import UNC
import UNC.Basic

universe u

-- 1. Players in the Dialogical Game
inductive Player where
  | Proponent : Player
  | Opponent : Player
  deriving DecidableEq, Repr

def opp (p : Player) : Player :=
  match p with
  | Player.Proponent => Player.Opponent
  | Player.Opponent => Player.Proponent

theorem opp_opp (p : Player) : opp (opp p) = p := by
  cases p <;> rfl

-- 2. Game States and Performative Contradictions
section Dialogical

variable {World : Type u} {Agent : Type u} {Perspective : Type u}

-- Definition of Performative Contradiction
def PC_local (ExecAssert : Agent → (World → Prop) → (World → Prop))
             (Presuppose : Agent → (World → Prop) → (World → Prop))
             (a : Agent) (chi : World → Prop) (w : World) : Prop :=
  ExecAssert a chi w ∧ ∃ psi : World → Prop, Presuppose a psi w ∧ (∀ v, chi v → ¬ psi v)

-- PlayerPC mapping PC to players
def PlayerPC (ExecAssert : Agent → (World → Prop) → (World → Prop))
             (Presuppose : Agent → (World → Prop) → (World → Prop))
             (p : Player) (a : Agent) (chi : World → Prop) (w : World) : Prop :=
  match p with
  | Player.Proponent => PC_local ExecAssert Presuppose a chi w
  | Player.Opponent => PC_local ExecAssert Presuppose a chi w

-- Theorem: Skepticism Defeated (The Definite Argument)
theorem skepticism_defeated
  {ExecArgue ExecAssert Presuppose : Agent → (World → Prop) → (World → Prop)}
  {N_ver : World → Prop}
  {WinningStrategy : Player → World → Prop}
  (a : Agent) (w : World)
  (h_argue : ExecArgue a (fun w => ¬ N_ver w) w)
  (argue_assert : ∀ a phi w, ExecArgue a phi w → ExecAssert a phi w)
  (argue_presuppose_ver : ∀ a phi w, ExecArgue a phi w → Presuppose a N_ver w)
  (pc_implies_no_winning_strategy : ∀ p a chi w, PlayerPC ExecAssert Presuppose p a chi w → ¬ (WinningStrategy p w)) :
  ¬ (WinningStrategy Player.Opponent w) := by
  have h_assert := argue_assert a (fun w => ¬ N_ver w) w h_argue
  have h_presup := argue_presuppose_ver a (fun w => ¬ N_ver w) w h_argue
  have h_pc : PC_local ExecAssert Presuppose a (fun w => ¬ N_ver w) w :=
    And.intro h_assert (Exists.intro N_ver (And.intro h_presup (fun _ h_not_ver => h_not_ver)))
  have h_play_pc : PlayerPC ExecAssert Presuppose Player.Opponent a (fun w => ¬ N_ver w) w := h_pc
  exact pc_implies_no_winning_strategy Player.Opponent a (fun w => ¬ N_ver w) w h_play_pc

-- Theorem: Proponent possesses a Winning Strategy
theorem proponent_winning_strategy
  {ExecArgue ExecAssert Presuppose : Agent → (World → Prop) → (World → Prop)}
  {N_ver : World → Prop}
  {WinningStrategy : Player → World → Prop}
  (a : Agent) (w : World)
  (h_argue : ExecArgue a (fun w => ¬ N_ver w) w)
  (argue_assert : ∀ a phi w, ExecArgue a phi w → ExecAssert a phi w)
  (argue_presuppose_ver : ∀ a phi w, ExecArgue a phi w → Presuppose a N_ver w)
  (pc_implies_opp_winning_strategy : ∀ p a chi w, PlayerPC ExecAssert Presuppose p a chi w → WinningStrategy (opp p) w) :
  WinningStrategy Player.Proponent w := by
  have h_assert := argue_assert a (fun w => ¬ N_ver w) w h_argue
  have h_presup := argue_presuppose_ver a (fun w => ¬ N_ver w) w h_argue
  have h_pc : PC_local ExecAssert Presuppose a (fun w => ¬ N_ver w) w :=
    And.intro h_assert (Exists.intro N_ver (And.intro h_presup (fun _ h_not_ver => h_not_ver)))
  have h_play_pc : PlayerPC ExecAssert Presuppose Player.Opponent a (fun w => ¬ N_ver w) w := h_pc
  have h_opp_win := pc_implies_opp_winning_strategy Player.Opponent a (fun w => ¬ N_ver w) w h_play_pc
  -- Since (opp Player.Opponent) evaluates to Player.Proponent, h_opp_win has type WinningStrategy Player.Proponent w
  exact h_opp_win

end Dialogical
